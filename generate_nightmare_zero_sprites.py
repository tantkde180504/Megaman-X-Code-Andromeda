import os
import shutil
import uuid
from PIL import Image

sheet_path = r'd:\MZ4\MegamanZ\sprites\NightmareZero\1801d875-09c9-45d6-8a4b-98191e06600b.png'
im = Image.open(sheet_path).convert('RGBA')
w, h = im.size
sprites_dir = r'd:\MZ4\MegamanZ\sprites'

def get_frames(y0, y1):
    col_has = [any(im.getpixel((x, y))[3] > 0 for y in range(y0, y1+1)) for x in range(w)]
    segs = []
    in_s = False
    s_start = 0
    for x, ch in enumerate(col_has):
        if ch and not in_s:
            in_s = True
            s_start = x
        elif not ch and in_s:
            in_s = False
            segs.append((s_start, x-1))
    if in_s: segs.append((s_start, w-1))
    
    frames = []
    for (x0, x1) in segs:
        crop = im.crop((x0, y0, x1+1, y1+1))
        bb = crop.getbbox()
        if bb:
            rx0, ry0, rx1, ry1 = x0 + bb[0], y0 + bb[1], x0 + bb[2], y0 + bb[3]
            frames.append((rx0, ry0, rx1 - rx0, ry1 - ry0))
    return frames

def build_yy(spr_name, cw, ch, ox, oy, speed, frame_guids, layer_guid, key_guids):
    frames_json = []
    for fg in frame_guids:
        frames_json.append(f'    {{"$GMSpriteFrame":"v1","%Name":"{fg}","name":"{fg}","resourceType":"GMSpriteFrame","resourceVersion":"2.0",}},')
        
    keyframes_json = []
    for i, (fg, kg) in enumerate(zip(frame_guids, key_guids)):
        keyframes_json.append(
            f'            {{"$Keyframe<SpriteFrameKeyframe>":"","Channels":{{\n'
            f'                "0":{{"$SpriteFrameKeyframe":"","Id":{{"name":"{fg}","path":"sprites/{spr_name}/{spr_name}.yy",}},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",}},\n'
            f'              }},"Disabled":false,"id":"{kg}","IsCreationKey":false,"Key":{i}.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,}},'
        )
    
    frames_str = "\n".join(frames_json)
    keyframes_str = "\n".join(keyframes_json)
    
    yy_text = f'''{{
  "$GMSprite":"v2",
  "%Name":"{spr_name}",
  "bboxMode":0,
  "bbox_bottom":{ch - 1},
  "bbox_left":0,
  "bbox_right":{cw - 1},
  "bbox_top":0,
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
{frames_str}
  ],
  "gridX":0,
  "gridY":0,
  "height":{ch},
  "HTile":false,
  "layers":[
    {{"$GMImageLayer":"","%Name":"{layer_guid}","blendMode":0,"displayName":"default","isLocked":false,"name":"{layer_guid}","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,}},
  ],
  "name":"{spr_name}",
  "nineSlice":null,
  "origin":7,
  "parent":{{
    "name":"Sprites",
    "path":"folders/Sprites.yy",
  }},
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{{
    "$GMSequence":"v1",
    "%Name":"{spr_name}",
    "autoRecord":true,
    "backdropHeight":768,
    "backdropImageOpacity":0.5,
    "backdropImagePath":"",
    "backdropWidth":1366,
    "backdropXOffset":0.0,
    "backdropYOffset":0.0,
    "events":{{
      "$KeyframeStore<MessageEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MessageEventKeyframe>",
      "resourceVersion":"2.0",
    }},
    "eventStubScript":null,
    "eventToFunction":{{}},
    "length":{float(len(frame_guids))},
    "lockOrigin":false,
    "moments":{{
      "$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    }},
    "name":"{spr_name}",
    "playback":1,
    "playbackSpeed":{speed},
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {{"$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{{"$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
{keyframes_str}
          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",}},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,}},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":{ox},
    "yorigin":{oy},
  }},
  "swatchColours":null,
  "swfPrecision":0.5,
  "textureGroupId":{{
    "name":"Default",
    "path":"texturegroups/Default",
  }},
  "type":0,
  "VTile":false,
  "width":{cw},
}}
'''
    return yy_text

def export_sprite(spr_name, frames, speed=10.0):
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    max_w = max(b[2] for b in frames)
    max_h = max(b[3] for b in frames)
    cw = max_w + (4 if max_w % 2 == 0 else 5)
    ch = max_h + 2
    ox = cw // 2
    oy = ch - 1 # bottom center
    
    layer_guid = str(uuid.uuid4())
    frame_guids = [str(uuid.uuid4()) for _ in frames]
    key_guids = [str(uuid.uuid4()) for _ in frames]
    
    for i, (bx, by, bw, bh) in enumerate(frames):
        fg = frame_guids[i]
        crop = im.crop((bx, by, bx + bw, by + bh))
        canvas = Image.new('RGBA', (cw, ch), (0, 0, 0, 0))
        # bottom center alignment
        cx = ox - bw // 2
        cy = oy - bh
        canvas.paste(crop, (cx, cy))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    yy_text = build_yy(spr_name, cw, ch, ox, oy, speed, frame_guids, layer_guid, key_guids)
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(yy_text)
    print(f'Exported {spr_name} ({len(frames)} frames, size={cw}x{ch})')

targets = {
    'spr_nz_spawn': (10, 73, 10.0),
    'spr_nz_slash_big': (90, 151, 14.0),
    'spr_nz_run': (169, 226, 12.0),
    'spr_nz_dash_slash': (330, 375, 14.0),
    'spr_nz_air': (393, 463, 14.0),
    'spr_nz_crescent_small': (489, 534, 12.0),
    'spr_nz_ground_charge': (558, 744, 10.0),
    'spr_nz_ground_spike': (765, 908, 12.0),
    'spr_nz_shoot': (934, 984, 10.0),
    'spr_nz_ring_fx': (994, 1042, 12.0),
    'spr_nz_drill_proj': (1052, 1083, 15.0),
    'spr_nz_crescent_proj': (1103, 1170, 15.0),
    'spr_nz_dome': (1188, 1247, 10.0),
    'spr_nz_skull_wave': (1281, 1342, 12.0),
    'spr_nz_floor_burst': (1354, 1400, 14.0),
    'spr_nz_idle': (1550, 1622, 6.0),
    'spr_nz_death_ooze': (1641, 1720, 8.0),
}

exported_names = []
for name, (y0, y1, spd) in targets.items():
    frames = get_frames(y0, y1)
    export_sprite(name, frames, spd)
    exported_names.append(name)

# Hurt & down
b20 = get_frames(1739, 1795)
export_sprite('spr_nz_hurt', b20[:2], 10.0)
export_sprite('spr_nz_down', [b20[2]], 5.0)
exported_names.extend(['spr_nz_hurt', 'spr_nz_down'])

print(f'All {len(exported_names)} sprites exported successfully!')
