"""Import source-backed X4 effects and HUD pieces. Default is preview only."""
import argparse
import base64
import copy
import io
import json
from pathlib import Path
import re
import numpy as np
from PIL import Image, ImageDraw
from import_x4_enemy_library import gm, guid, sprite_metadata, write_json

ROOT=Path(__file__).resolve().parents[1]
ART=ROOT/'art/effects/x4'
PROJECT=ROOT/'MegamanZ'


def frames_from(image, region, trim=True):
    rects=region.get('rects',[])
    if 'strip' in region:
        x,y,r,b=region['strip']
        a=np.asarray(image.crop((x,y,r,b)))[:,:,3]
        flags=np.any(a>0,axis=0)
        edges=np.where(np.diff(np.r_[False,flags,False]))[0]
        rects=[[x+int(l),y,x+int(h),b] for l,h in zip(edges[::2],edges[1::2])]
    result=[]
    for rect in rects:
        assert 0<=rect[0]<rect[2]<=image.width and 0<=rect[1]<rect[3]<=image.height,rect
        frame=image.crop(rect);box=frame.getbbox()
        if not box:raise ValueError(f'Empty cell: {rect}')
        if trim:
            frame=frame.crop(box)
            rect=[rect[0]+box[0],rect[1]+box[1],rect[0]+box[2],rect[1]+box[3]]
        result.append((frame,rect))
    return result


def cell_frames(source):
    # Native palette: a 5px gold highlight row plus its dark outline/shadow row.
    gold=Image.new('RGBA',(5,2));gold.paste(source.crop((102,20,107,21)),(0,0))
    shadow=source.getpixel((102,20));white=source.getpixel((13,28))
    for x in range(5):gold.putpixel((x,1),shadow)
    flash=gold.copy()
    for x in range(1,4):flash.putpixel((x,0),white)
    return [gold,flash]


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--write',action='store_true');args=parser.parse_args()
    plan=json.loads((ART/'library.json').read_text(encoding='utf-8'))
    previous=ART/'imported.json'
    owned=set(json.loads(previous.read_text(encoding='utf-8'))['resources']) if previous.exists() else set()
    template=gm(PROJECT/'sprites/sX_Victory/sX_Victory.yy')
    resources=[];records=[];atlases=[]
    for spec in plan['sprites']:
        name=spec['name'];source=Image.open(ART/'source'/spec['sheet']).convert('RGBA')
        raw=[];rects=[];clips={}
        if spec.get('assembly')=='energy_cell':
            raw=cell_frames(source);clips={'gold':[0,1],'flash':[1,1]}
        else:
            for clip,region in spec['clips'].items():
                cells=frames_from(source,region,spec.get('trim',True))
                clips[clip]=[len(raw),len(cells)];raw += [f for f,r in cells];rects += [r for f,r in cells]
        if not raw:raise ValueError(f'No frames for {name}')
        if name.startswith('sFX_') and 'play' not in clips:clips={'play':[0,len(raw)],**clips}
        w,h=max(f.width for f in raw),max(f.height for f in raw)
        anchor=spec['anchor']
        right=anchor in ('right_center','right_bottom')
        bottom=anchor in ('bottom','right_bottom')
        origin=(0,0) if anchor=='top_left' else (w if right else w//2,h if bottom else h//2)
        frames=[]
        for f in raw:
            canvas=Image.new('RGBA',(w,h))
            at=(0,0) if anchor=='top_left' else (origin[0]-(f.width if right else f.width//2),origin[1]-(f.height if bottom else f.height//2))
            canvas.paste(f,at);frames.append(canvas)
        meta,layer_id=sprite_metadata(name,frames,origin,[0,0,w-1,h-1],template)
        folder='X4 HUD' if spec.get('group')=='hud' else 'X4 Effects'
        meta['parent']={'name':folder,'path':f'folders/Sprites/{folder}.yy'}
        meta['sequence']['playbackSpeed']=float(spec.get('fps',0))
        dest=PROJECT/'sprites'/name
        if args.write:
            if dest.exists() and name not in owned:raise FileExistsError(f'Unowned resource: {name}')
            write_json(dest/f'{name}.yy',meta)
            for i,im in enumerate(frames):
                fid=meta['frames'][i]['name'];im.save(dest/f'{fid}.png')
                layers=dest/'layers'/fid;layers.mkdir(parents=True,exist_ok=True);im.save(layers/f'{layer_id}.png')
        resources.append((name,f'sprites/{name}/{name}.yy'))
        record={'name':name,'sheet':spec['sheet'],'frames':len(frames),'size':[w,h],'origin':origin,
                'clips':clips,'rects':rects,'assembly':spec.get('assembly')}
        records.append(record)
        atlas=Image.new('RGBA',(w*len(frames),h))
        for i,f in enumerate(frames):atlas.paste(f,(i*w,0))
        buf=io.BytesIO();atlas.save(buf,format='PNG')
        atlases.append({**record,'data':'data:image/png;base64,'+base64.b64encode(buf.getvalue()).decode()})
    used={s['sheet'] for s in plan['sprites']}|set(plan['reused'])
    source_names={r['file'] for r in json.loads((ART/'sources.json').read_text())['sheets']}
    assert used==source_names,'Every source sheet must have an explicit import/reuse decision'
    if args.write:
        name='oFX_X4Burst';dest=PROJECT/'objects'/name
        if dest.exists() and name not in owned:raise FileExistsError(f'Unowned effect object: {name}')
        obj=gm(PROJECT/'objects/oFX_EnemyExplosion/oFX_EnemyExplosion.yy')
        obj['%Name']=obj['name']=name
        obj['spriteId']={'name':'sFX_X4_Explosion','path':'sprites/sFX_X4_Explosion/sFX_X4_Explosion.yy'}
        obj['spriteMaskId']=None
        write_json(dest/f'{name}.yy',obj)
        (dest/'Create_0.gml').write_text('sprite_index = sFX_X4_Explosion;\nimage_speed = 0;\nimage_index = 0;\nfx_frame = 0;\nfx_rate = 0.5;\n',encoding='utf-8')
        (dest/'Step_0.gml').write_text('fx_x4_advance();\n',encoding='utf-8')
        (dest/'Draw_0.gml').write_text('draw_self();\n',encoding='utf-8')
        resources.append((name,f'objects/{name}/{name}.yy'))
        path=PROJECT/'MegamanZ.yyp';text=path.read_text(encoding='utf-8-sig');project=gm(path)
        registered={r['id']['name'] for r in project['resources']}
        additions=''.join(f'    {{"id":{{"name":"{n}","path":"{p}",}},}},\n' for n,p in resources if n not in registered)
        text=re.sub(r'("resources"\s*:\s*\[\s*\n)',lambda m:m[0]+additions,text,count=1)
        for name in ['X4 HUD','X4 Effects']:
            folder=f'folders/Sprites/{name}.yy'
            if folder not in text:
                definition='{"$GMFolder":"","%Name":"'+name+'","folderPath":"'+folder+'","name":"'+name+'","resourceType":"GMFolder","resourceVersion":"2.0",},'
                text=re.sub(r'("Folders"\s*:\s*\[\s*\n)',lambda m:m[0]+'    '+definition+'\n',text,count=1)
        path.write_text(text,encoding='utf-8',newline='\n')
        write_json(previous,{'resources':[n for n,p in resources],'sprites':records,'reused':plan['reused']})
    write_json(ART/'prepared.json',{'sprites':records,'reused':plan['reused']})
    for start in range(0,len(atlases),8):
        audit=Image.new('RGB',(1440,8*145),'#263241');draw=ImageDraw.Draw(audit)
        for row,record in enumerate(atlases[start:start+8]):
            draw.text((4,row*145+2),record['name'],fill='white')
            atlas=Image.open(io.BytesIO(base64.b64decode(record['data'].split(',')[1])))
            w,h=record['size']
            for i in range(record['frames']):
                f=atlas.crop((i*w,0,(i+1)*w,h));f.thumbnail((72,110),Image.Resampling.NEAREST)
                audit.paste(f,(4+i*78,row*145+20),f);draw.text((4+i*78,row*145+130),str(i),fill='white')
        audit.save(ART/f'frame-audit-{start//8+1}.png')
    html='''<!doctype html><meta charset="utf-8"><title>X4 Effects & HUD</title><style>body{font:15px system-ui;background:#111b29;color:#e6f0ff;margin:24px}#grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:14px}article{background:#253447;padding:14px}canvas{width:100%;height:160px;image-rendering:pixelated}button{margin:3px;padding:6px}</style><h1>X4 Effects & HUD Library</h1><p>Original sheets: Sprites INC / Capcom. Effects play once per loop in this preview; HUD rows are independent sprite frames.</p><div id="grid"></div><script>const records=__DATA__;for(const r of records){const a=document.createElement('article');a.innerHTML='<b>'+r.name+'</b><p>'+r.frames+' frames · '+r.size.join(' × ')+'</p>';const c=document.createElement('canvas');c.width=300;c.height=160;a.append(c);const ctx=c.getContext('2d'),img=new Image();img.src=r.data;let clip=Object.values(r.clips)[0];for(const [n,v]of Object.entries(r.clips)){const b=document.createElement('button');b.textContent=n;b.onclick=()=>clip=v;a.append(b)}document.querySelector('#grid').append(a);function tick(t){ctx.clearRect(0,0,300,160);ctx.imageSmoothingEnabled=false;const [w,h]=r.size,s=Math.min(4,290/w,150/h),i=clip[0]+Math.floor(t/100)%clip[1];if(img.complete)ctx.drawImage(img,i*w,0,w,h,(300-w*s)/2,(160-h*s)/2,w*s,h*s);requestAnimationFrame(tick)}requestAnimationFrame(tick)}</script>'''
    (ART/'library-preview.html').write_text(html.replace('__DATA__',json.dumps(atlases)),encoding='utf-8')
    print('Prepared',len(records),'sprites,',sum(r['frames'] for r in records),'frames;', 'imported.' if args.write else 'preview only.')


if __name__=='__main__':main()
