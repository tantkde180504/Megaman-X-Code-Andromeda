"""Deterministic native-pixel sprite import. Preview by default; --write registers prefabs."""
import argparse
import base64
import copy
import io
import json
from pathlib import Path
import re
import uuid

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "art/enemies/x4"
PROJECT = ROOT / "MegamanZ"
NS = uuid.UUID("409ba7a0-9c82-4b99-b80a-3a32c3d0cdca")


def gm(path):
    return json.loads(re.sub(r",\s*([}\]])", r"\1", path.read_text(encoding="utf-8-sig")))


def guid(key):
    return str(uuid.uuid5(NS, key))


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def extract(image, spec):
    rects = spec.get("rects", [])
    if "strip" in spec:
        left, top, right, bottom = spec["strip"]
        alpha = np.asarray(image.crop((left, top, right, bottom)))[:, :, 3]
        columns = np.any(alpha > 0, axis=0)
        runs, start = [], None
        for x, occupied in enumerate([*columns, False]):
            if occupied and start is None:
                start = x
            elif not occupied and start is not None:
                if runs and start - runs[-1][1] <= spec.get("merge_gap", 0):
                    runs[-1][1] = x
                else:
                    runs.append([start, x])
                start = None
        rects = [[left + a, top, left + b, bottom] for a, b in runs if b - a >= 8]
    frames = []
    for index, rect in enumerate(rects):
        if not (0 <= rect[0] < rect[2] <= image.width and 0 <= rect[1] < rect[3] <= image.height):
            raise ValueError(f"Out-of-sheet rectangle {rect} in {image.size}")
        frame = image.crop(rect)
        box = frame.getbbox()
        if not box:
            raise ValueError(f"Empty frame at {rect}")
        frame = frame.crop(box)
        if frame.width < 8 or frame.height < 8:
            continue
        pivot = spec.get("pivots", [None] * len(rects))[index]
        if pivot is not None: pivot = (pivot[0] - box[0], pivot[1] - box[1])
        frames.append((frame, [rect[0] + box[0], rect[1] + box[1], frame.width, frame.height], pivot))
    if not frames:
        raise ValueError(f"No usable frames: {spec}")
    return frames


def sprite_metadata(name, frames, origin, core, template):
    width, height = frames[0].size
    meta = copy.deepcopy(template)
    meta["%Name"] = meta["name"] = name
    meta["parent"] = {"name": "X4 Library", "path": "folders/Sprites/X4 Library.yy"}
    meta.update(width=width, height=height, origin=9, bboxMode=2, collisionKind=1,
                bbox_left=core[0], bbox_top=core[1], bbox_right=core[2], bbox_bottom=core[3],
                edgeFiltering=False, preMultiplyAlpha=False)
    layer_id = guid(name + ":layer")
    meta["layers"][0]["%Name"] = meta["layers"][0]["name"] = layer_id
    seq = meta["sequence"]
    seq["%Name"] = seq["name"] = name
    seq.update(length=float(len(frames)), xorigin=origin[0], yorigin=origin[1], playbackSpeed=12.0)
    key_template = copy.deepcopy(seq["tracks"][0]["keyframes"]["Keyframes"][0])
    keys, meta["frames"] = [], []
    for index, frame in enumerate(frames):
        frame_id = guid(f"{name}:frame:{index}")
        meta["frames"].append({"$GMSpriteFrame":"v1", "%Name":frame_id, "name":frame_id,
                               "resourceType":"GMSpriteFrame", "resourceVersion":"2.0"})
        key = copy.deepcopy(key_template)
        key["id"], key["Key"] = guid(f"{name}:key:{index}"), float(index)
        key["Channels"]["0"]["Id"] = {"name":frame_id, "path":f"sprites/{name}/{name}.yy"}
        keys.append(key)
    seq["tracks"][0]["keyframes"]["Keyframes"] = keys
    return meta, layer_id


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    manifest = json.loads((ART / "library.json").read_text(encoding="utf-8"))
    source_records = json.loads((ART / "sources.json").read_text(encoding="utf-8"))["sheets"]
    template = gm(PROJECT / "sprites/sX_Victory/sX_Victory.yy")
    object_template = gm(PROJECT / "objects/oEnemy_MettaurD2/oEnemy_MettaurD2.yy")
    event_template = object_template["eventList"][0]
    owned_path = ART / "imported.json"
    owned = set(json.loads(owned_path.read_text())["resources"]) if owned_path.exists() else set()
    resources, records, previews, profile_gml = [], [], [], []
    for spec in manifest["profiles"] + manifest["environment"]:
        key, sheet = spec["key"], spec["sheet"]
        image = Image.open(ART / "source" / sheet).convert("RGBA")
        raw, pivots, clips, source_rects = [], [], {}, {}
        for clip, region in spec["clips"].items():
            extracted = extract(image, region)
            clips[clip] = [len(raw), len(extracted)]
            source_rects[clip] = [rect for _, rect, _ in extracted]
            raw.extend(frame for frame, _, _ in extracted)
            pivots.extend(pivot for _, _, pivot in extracted)
        ground = spec.get("ground", False)
        pivots = [pivot if pivot is not None else (f.width//2,f.height if ground else f.height//2)
                  for f,pivot in zip(raw,pivots)]
        origin = (max(p[0] for p in pivots)+2,max(p[1] for p in pivots)+2)
        width = origin[0]+max(f.width-p[0] for f,p in zip(raw,pivots))+2
        height = origin[1]+max(f.height-p[1] for f,p in zip(raw,pivots))+2
        frames = []
        for frame, pivot in zip(raw,pivots):
            canvas = Image.new("RGBA", (width, height))
            canvas.paste(frame, (origin[0] - pivot[0], origin[1] - pivot[1]))
            frames.append(canvas)
        # A stable body mask excludes weapons, flames and pose-dependent extensions.
        core_w = max(6, min(width - 4, int(raw[0].width * .7)))
        core_h = max(6, min(height - 4, int(raw[0].height * .75)))
        core = [origin[0] - core_w // 2, origin[1] - (core_h if ground else core_h // 2),
                origin[0] + (core_w - 1) // 2, origin[1] - 1 if ground else origin[1] + (core_h - 1) // 2]
        name = f"sX4_{key}"
        dest = PROJECT / "sprites" / name
        if args.write and dest.exists() and name not in owned:
            raise FileExistsError(f"Refusing to overwrite an unowned sprite: {name}")
        meta, layer_id = sprite_metadata(name, frames, origin, core, template)
        resources.append((name, f"sprites/{name}/{name}.yy"))
        if args.write:
            write_json(dest / f"{name}.yy", meta)
            for index, frame in enumerate(frames):
                frame_id = meta["frames"][index]["name"]
                frame.save(dest / f"{frame_id}.png")
                layer = dest / "layers" / frame_id
                layer.mkdir(parents=True, exist_ok=True)
                frame.save(layer / f"{layer_id}.png")
        record = {"key":key,"sprite":name,"sheet":sheet,"source_rects":source_rects,
                  "size":[width,height],"origin":origin,"mask":core,"clips":clips,"frames":len(frames)}
        if "kind" in spec:
            obj = f"oEnemy_X4_{key}"
            record["object"], record["kind"] = obj, spec["kind"]
            obj_path = PROJECT / "objects" / obj
            if args.write and obj_path.exists() and obj not in owned:
                raise FileExistsError(f"Refusing to overwrite an unowned object: {obj}")
            obj_meta = copy.deepcopy(object_template)
            obj_meta["%Name"] = obj_meta["name"] = obj
            obj_meta["parent"] = {"name":"X4 Library","path":"folders/Objects/Enemies/X4 Library.yy"}
            obj_meta["parentObjectId"] = {"name":"oEnemy_X4Base","path":"objects/oEnemy_X4Base/oEnemy_X4Base.yy"}
            obj_meta["eventList"] = [copy.deepcopy(event_template)]
            obj_meta["eventList"][0].update(eventNum=0, eventType=0)
            obj_meta["spriteId"] = obj_meta["spriteMaskId"] = {"name":name,"path":f"sprites/{name}/{name}.yy"}
            resources.append((obj, f"objects/{obj}/{obj}.yy"))
            if args.write:
                write_json(obj_path / f"{obj}.yy", obj_meta)
                (obj_path / "Create_0.gml").write_text(f'event_inherited();\nx4_enemy_apply("{key}");\n', encoding="utf-8")
            values = {"ground":ground,"hp":spec["hp"],"speed":spec["speed"],"shots":spec["shots"],
                      "radius":spec.get("radius",32),"fall_speed":spec.get("fall_speed",2),
                      "native_facing":spec.get("native_facing",1),"invulnerable":spec.get("invulnerable",False),
                      "idle":clips["idle"],"move":clips.get("move",clips["idle"]),
                      "attack":clips.get("attack",clips["idle"]),"body_height":raw[0].height}
            fields = ", ".join(f"{k}: {json.dumps(v)}" for k,v in values.items())
            profile_gml.append(f'        case "{key}": return {{sprite: {name}, kind: X4_AI_KIND.{spec["kind"]}, {fields}}};')
        records.append(record)
        # Embed atlas pixels so the preview works directly from disk without a server.
        atlas = Image.new("RGBA", (width * len(frames), height))
        for i, frame in enumerate(frames): atlas.paste(frame,(i * width,0))
        buffer = io.BytesIO(); atlas.save(buffer,format="PNG")
        previews.append({**record,"label":spec.get("label",key),
                         "data":"data:image/png;base64,"+base64.b64encode(buffer.getvalue()).decode()})
    used = {p["sheet"] for p in manifest["profiles"] + manifest["environment"]} | set(manifest["existing"])
    assert used == {r["file"] for r in source_records}, "Every source sheet must be accounted for"
    if args.write:
        base_name = "oEnemy_X4Base"
        base_path = PROJECT / "objects" / base_name
        if base_path.exists() and base_name not in owned:
            raise FileExistsError(f"Refusing to overwrite unowned base: {base_path}")
        base_meta = gm(PROJECT / "objects/oEnemyParent/oEnemyParent.yy")
        base_meta["%Name"] = base_meta["name"] = base_name
        base_meta["parent"] = {"name":"X4 Library","path":"folders/Objects/Enemies/X4 Library.yy"}
        base_meta["parentObjectId"] = {"name":"oEnemyParent","path":"objects/oEnemyParent/oEnemyParent.yy"}
        write_json(base_path / f"{base_name}.yy",base_meta)
        for event,code in {
            "Create_0":"event_inherited();\nenemy_profile = noone;\nimage_speed = 0;\n",
            "Step_0":"event_inherited();\nif (is_dead || stage_frozen || !is_struct(enemy_profile)) return;\nx4_enemy_tick();\n",
            "Draw_0":"if (is_struct(enemy_profile)) x4_enemy_draw();\nelse event_inherited();\n"
        }.items(): (base_path / f"{event}.gml").write_text(code,encoding="utf-8")
        resources.append((base_name,f"objects/{base_name}/{base_name}.yy"))
        resources.append(("scr_x4_enemy_runtime","scripts/scr_x4_enemy_runtime/scr_x4_enemy_runtime.yy"))
        path = PROJECT / "scripts/scr_x4_enemy_profiles/scr_x4_enemy_profiles.gml"
        path.parent.mkdir(parents=True,exist_ok=True)
        path.write_text('/// @desc Generated from art/enemies/x4/library.json.\nfunction x4_enemy_profile(_key) {\n    switch (_key) {\n'+
                       '\n'.join(profile_gml)+'\n    }\n    return noone;\n}\n',encoding="utf-8")
        script_meta = gm(PROJECT / "scripts/scr_stage_encounters/scr_stage_encounters.yy")
        script_meta["%Name"] = script_meta["name"] = "scr_x4_enemy_profiles"
        write_json(path.with_suffix(".yy"),script_meta)
        resources.append(("scr_x4_enemy_profiles","scripts/scr_x4_enemy_profiles/scr_x4_enemy_profiles.yy"))
        project_path = PROJECT / "MegamanZ.yyp"
        text = project_path.read_text(encoding="utf-8-sig")
        registered = {r["id"]["name"] for r in gm(project_path)["resources"]}
        additions = ''.join(f'    {{"id":{{"name":"{n}","path":"{p}",}},}},\n' for n,p in resources if n not in registered)
        text = re.sub(r'("resources"\s*:\s*\[\s*\n)',lambda m:m[0]+additions,text,count=1)
        folders = ["folders/Objects/Enemies/X4 Library.yy","folders/Sprites/X4 Library.yy"]
        for folder in folders:
            if folder not in text:
                value = '{"$GMFolder":"","%Name":"X4 Library","folderPath":"'+folder+'","name":"X4 Library","resourceType":"GMFolder","resourceVersion":"2.0",},'
                text = re.sub(r'("Folders"\s*:\s*\[\s*\n)',lambda m:m[0]+'    '+value+'\n',text,count=1)
        project_path.write_text(text,encoding="utf-8",newline="\n")
        write_json(owned_path,{"resources":[n for n,_ in resources],"actors":records})
    write_json(ART / "prepared.json",{"actors":records,"source_coverage":manifest["existing"]})
    for offset in range(0,len(previews),12):
        cells = previews[offset:offset+12]
        sheet = Image.new("RGB",(1280,780),"#1c2531"); draw=ImageDraw.Draw(sheet)
        for i,item in enumerate(cells):
            x,y=i%4*320,i//4*260
            draw.text((x+8,y+4),f'{item["key"]}: {item["frames"]} frames / {item.get("kind","asset")}',fill="white")
            for j,image in enumerate([f for f in previews if f["key"]==item["key"]]):
                with Image.open(io.BytesIO(base64.b64decode(image["data"].split(',')[1]))) as atlas:
                    frame=atlas.crop((0,0,item["size"][0],item["size"][1]))
                    scale=max(1,min(3,300//frame.width,220//frame.height))
                    frame=frame.resize((frame.width*scale,frame.height*scale),Image.Resampling.NEAREST)
                    if frame.width>310: frame.thumbnail((310,215),Image.Resampling.NEAREST)
                    sheet.paste(frame,(x+(320-frame.width)//2,y+30),frame)
        sheet.save(ART / f"library-preview-{offset//12+1}.png")
    html = '''<!doctype html><meta charset="utf-8"><title>X4 Enemy Library</title>
<style>body{background:#111a26;color:#e0edff;font:15px system-ui;margin:24px}#grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:16px}article{background:#1e2c3e;padding:16px;border:1px solid #42556e}canvas{display:block;width:100%;height:180px;image-rendering:pixelated}button{margin:4px;padding:6px}small{color:#a9c6e8}</style>
<h1>X4 Enemy Library</h1><p>Native pixel sprites from Sprites INC / Capcom. Baseline reusable behaviours; not exact original-game AI. No new enemies are placed in current stages.</p><div id="grid"></div><script>
const actors=__ACTORS__;for(const a of actors){const card=document.createElement('article');card.innerHTML='<b>'+a.label+'</b><p><small>'+ (a.object||a.sprite)+'<br>'+a.size.join(' × ')+' px · '+a.frames+' frames · '+(a.kind||'environment asset')+'</small></p>';const c=document.createElement('canvas');c.width=300;c.height=180;card.append(c);const ctx=c.getContext('2d'),img=new Image();img.src=a.data;let clip=a.clips.idle;for(const [name,range] of Object.entries(a.clips)){const button=document.createElement('button');button.textContent=name;button.onclick=()=>clip=range;card.append(button)}document.querySelector('#grid').append(card);function tick(t){ctx.clearRect(0,0,300,180);ctx.imageSmoothingEnabled=false;const [w,h]=a.size,scale=Math.min(3,290/w,170/h),i=clip[0]+Math.floor(t/100)%clip[1];if(img.complete)ctx.drawImage(img,i*w,0,w,h,(300-w*scale)/2,(180-h*scale)/2,w*scale,h*scale);requestAnimationFrame(tick)}requestAnimationFrame(tick)}
</script>'''
    (ART / "library-preview.html").write_text(html.replace('__ACTORS__',json.dumps(previews)),encoding="utf-8")
    urls={r['file']:r['url'] for r in source_records}
    lines=['# Danh mục X4 Library','',
           'AI là hành vi nền theo nhóm; xem README.md để biết giới hạn và cách đặt object.','',
           '| Prefab / sprite | Nhóm | Frame | Kích thước canvas | Nguồn |',
           '|---|---|---:|---|---|']
    for record in records:
        resource=record.get('object',record['sprite'])
        lines.append(f'| `{resource}` | {record.get("kind","Environment sprite")} | {record["frames"]} | '
                     f'{record["size"][0]}×{record["size"][1]} | [{record["sheet"]}]({urls[record["sheet"]]}) |')
    lines+=['','## Sheet đã có hoặc biến thể','', '| Sheet | Resource / ghi chú |','|---|---|']
    for sheet,note in manifest['existing'].items():lines.append(f'| [{sheet}]({urls[sheet]}) | {note} |')
    (ART/'CATALOG.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    for offset in range(0,len(previews),8):
        audit=Image.new("RGB",(1440,8*150),"#202a38"); draw=ImageDraw.Draw(audit)
        for row,item in enumerate(previews[offset:offset+8]):
            draw.text((4,row*150+2),item['key'],fill='white')
            atlas=Image.open(io.BytesIO(base64.b64decode(item['data'].split(',')[1])))
            w,h=item['size']
            for i in range(item['frames']):
                frame=atlas.crop((i*w,0,(i+1)*w,h));frame.thumbnail((82,116),Image.Resampling.NEAREST)
                x=4+i*88
                audit.paste(frame,(x,row*150+22),frame)
                draw.text((x,row*150+132),str(i),fill='white')
        audit.save(ART / f'frame-audit-{offset//8+1}.png')
    print(f'Prepared {len(manifest["profiles"])} enemy prefabs and {len(manifest["environment"])} environment sprite; '+
          f'{sum(r["frames"] for r in records)} native frames. '+('Imported.' if args.write else 'Preview only.'))


if __name__ == "__main__": main()
