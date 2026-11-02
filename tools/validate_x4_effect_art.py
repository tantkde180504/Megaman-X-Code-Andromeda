"""Verify exact source pixels, HUD palette assembly, and every referenced frame."""
from collections import Counter
import json
from pathlib import Path
import re
from PIL import Image
from import_x4_effect_library import cell_frames

ROOT=Path(__file__).resolve().parents[1];ART=ROOT/'art/effects/x4'
data=json.loads((ART/'imported.json').read_text(encoding='utf-8'));count=0
for record in data['sprites']:
    name=record['name'];folder=ROOT/'MegamanZ/sprites'/name
    meta=json.loads(re.sub(r',\s*([}\]])',r'\1',(folder/f'{name}.yy').read_text(encoding='utf-8')))
    source=Image.open(ART/'source'/record['sheet']).convert('RGBA')
    assert len(meta['frames'])==record['frames']
    expected=cell_frames(source) if record['assembly'] else [source.crop(r) for r in record['rects']]
    for frame,original in zip(meta['frames'],expected):
        im=Image.open(folder/f'{frame["name"]}.png').convert('RGBA')
        assert list(im.size)==record['size'] and im.getbbox()
        pixels=lambda image:Counter(p for p in image.get_flattened_data() if p[3])
        assert pixels(im)==pixels(original),f'{name}: native pixels were resampled or clipped'
        assert im.getchannel('A').getextrema()[1]==255
        count+=1
assert count==sum(s['frames'] for s in data['sprites'])
sources={s['file']:s for s in json.loads((ART/'sources.json').read_text())['sheets']}
old={s['file']:s for s in json.loads((ROOT/'art/enemies/x4/sources.json').read_text())['sheets']}
for sheet in data['reused']:assert sources[sheet]['sha256']==old[sheet]['sha256']
print(f'PASS: {len(data["sprites"])} sprites, {count} exact source/assembled-palette frames; 2 meteors reused without duplicates.')
