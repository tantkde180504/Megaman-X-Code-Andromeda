"""Validate imported frame alpha, stable masks, and exact opaque source pixels."""
from collections import Counter
import json
from pathlib import Path
import re
from PIL import Image

ROOT=Path(__file__).resolve().parents[1]
ART=ROOT/"art/enemies/x4"
data=json.loads((ART/"imported.json").read_text(encoding="utf-8"))
count=0
for actor in data["actors"]:
    name=actor["sprite"]
    folder=ROOT/"MegamanZ/sprites"/name
    meta=json.loads(re.sub(r",\s*([}\]])",r"\1",(folder/f"{name}.yy").read_text(encoding="utf-8")))
    assert [meta["width"],meta["height"]]==actor["size"]
    assert len(meta["frames"])==actor["frames"]
    assert meta["bboxMode"]==2 and meta["collisionKind"]==1
    assert 0<=meta["bbox_left"]<=meta["bbox_right"]<meta["width"]
    assert 0<=meta["bbox_top"]<=meta["bbox_bottom"]<meta["height"]
    source=Image.open(ART/"source"/actor["sheet"]).convert("RGBA")
    rects=[r for rows in actor["source_rects"].values() for r in rows]
    for index,record in enumerate(meta["frames"]):
        frame=Image.open(folder/f'{record["name"]}.png').convert("RGBA")
        assert list(frame.size)==actor["size"]
        assert frame.getbbox() is not None
        alpha=frame.getchannel("A")
        assert alpha.getextrema()==(0,255),f'{name}: must contain transparent and visible pixels'
        x,y,w,h=rects[index]
        original=source.crop((x,y,x+w,y+h))
        opaque=lambda im:Counter(p for p in im.get_flattened_data() if p[3])
        assert opaque(frame)==opaque(original),f'{name} frame {index}: resampling/clipping/colour change'
        count+=1
print(f'PASS: {len(data["actors"])} sprites, {count} frames, exact source pixels, alpha and fixed body masks.')
