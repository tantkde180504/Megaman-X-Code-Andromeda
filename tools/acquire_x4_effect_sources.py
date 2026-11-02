"""Archive the effects/HUD sheets from the supplied Sprites INC page."""
from concurrent.futures import ThreadPoolExecutor
from hashlib import sha256
from html import unescape
import json
from pathlib import Path
import re
from PIL import Image, ImageDraw
from acquire_x4_enemy_sources import fetch

ROOT=Path(__file__).resolve().parents[1]
ART=ROOT/'art/effects/x4'
PAGE='https://sprites-inc.com/sprite.php?local=/X/X4/Misc/GameObjects/Effects/'


def main():
    source=ART/'source';source.mkdir(parents=True,exist_ok=True)
    html=fetch(PAGE,PAGE).decode('utf-8',errors='replace')
    urls=list(dict.fromkeys('https://sprites-inc.com'+unescape(p) for p in
        re.findall(r'<img[^>]+src=["\'](/files/X/X4/Misc/GameObjects/Effects/[^"\']+)',html)))
    if not urls:raise RuntimeError('No source sheets found; inspect the page')
    def archive(url):
        path=source/url.rsplit('/',1)[-1]
        if not path.exists():path.write_bytes(fetch(url,PAGE))
        with Image.open(path) as im:
            return {'file':path.name,'url':url,'width':im.width,'height':im.height,
                    'sha256':sha256(path.read_bytes()).hexdigest()}
    with ThreadPoolExecutor(max_workers=2) as pool:records=list(pool.map(archive,urls))
    (ART/'sources.json').write_text(json.dumps({'page':PAGE,'sheets':records,
        'provenance':'Original game art: Capcom. Hosted by Sprites INC; original sheets and credits retained. No independent reuse licence stated.'},indent=2)+'\n',encoding='utf-8')
    for start in range(0,len(records),8):
        preview=Image.new('RGB',(1280,600),'#29313d');draw=ImageDraw.Draw(preview)
        for i,r in enumerate(records[start:start+8]):
            x,y=i%4*320,i//4*300
            draw.text((x+4,y+4),r['file'],fill='white')
            im=Image.open(source/r['file']).convert('RGBA');im.thumbnail((312,270),Image.Resampling.NEAREST)
            preview.paste(im,(x+4,y+24),im)
        preview.save(ART/f'source-preview-{start//8+1}.png')
    print('Archived',len(records),'sheets')
    for r in records:print(r['file'],r['width'],r['height'])


if __name__=='__main__':main()
