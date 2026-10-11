import os
import shutil
import uuid
from PIL import Image

sheet_path = r'd:\MZ4\MegamanZ\sprites\sSheet_Goc\d39637a4-0e02-4a7e-961d-6aa3225312b5.png'
sheet = Image.open(sheet_path).convert('RGBA')

sprites_dir = r'd:\MZ4\MegamanZ\sprites'

def build_yy(spr_name, w, h, ox, oy, speed, frame_guids, layer_guid, key_guids):
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
  "bbox_bottom":{h - 1},
  "bbox_left":0,
  "bbox_right":{w - 1},
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
  "height":{h},
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
  "width":{w},
}}
'''
    return yy_text

# =========================================================================
# 1. GENERATE sX_Idle (5 frames from Row 3)
# =========================================================================
def gen_idle():
    spr_name = 'sX_Idle'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 56, 52, 28, 50
    layer_guid = str(uuid.uuid4())
    boxes = [
        (189, 174, 223, 219),
        (231, 175, 265, 219),
        (274, 176, 308, 219),
        (317, 176, 351, 219),
        (359, 176, 393, 219)
    ]
    frame_guids = [str(uuid.uuid4()) for _ in range(5)]
    key_guids = [str(uuid.uuid4()) for _ in range(5)]
    
    for i, (x1, y1, x2, y2) in enumerate(boxes):
        fg = frame_guids[i]
        sub = sheet.crop((x1, y1, x2 + 1, y2 + 1))
        sw, sh = sub.size
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        cx = ox - sw // 2
        cy = oy - sh + 1
        canvas.paste(sub, (cx, cy))
        
        # Root frame png
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        # Layer png with identical layer_guid!
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 6.0, frame_guids, layer_guid, key_guids))
    print('sX_Idle generated cleanly.')

# =========================================================================
# 2. GENERATE sX_Jump (11 frames from Row 4)
# =========================================================================
def gen_jump():
    spr_name = 'sX_Jump'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 56, 64, 28, 58
    layer_guid = str(uuid.uuid4())
    jump_cols = [
        (98, 122), (131, 153), (163, 185), (203, 225), (236, 262),
        (272, 305), (312, 343), (353, 381), (391, 421), (429, 457), (464, 495)
    ]
    frame_guids = [str(uuid.uuid4()) for _ in range(11)]
    key_guids = [str(uuid.uuid4()) for _ in range(11)]
    
    for i, (cx1, cx2) in enumerate(jump_cols):
        fg = frame_guids[i]
        min_x, max_x = cx1, cx2
        min_y, max_y = 285, 229
        for y in range(229, 286):
            for x in range(cx1, cx2 + 1):
                if sheet.getpixel((x, y))[3] > 0:
                    if y < min_y: min_y = y
                    if y > max_y: max_y = y
        sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
        sw, sh = sub.size
        base_y = 284 if i < 10 else 280
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        cx = ox - sw // 2
        cy = oy - (base_y - min_y)
        canvas.paste(sub, (cx, cy))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 12.0, frame_guids, layer_guid, key_guids))
    print('sX_Jump generated cleanly.')

# =========================================================================
# 3. GENERATE sX_Dash (8 frames from Row 9)
# =========================================================================
def gen_dash():
    spr_name = 'sX_Dash'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 64, 52, 32, 50
    layer_guid = str(uuid.uuid4())
    r9_cols = [
        (94, 129), (136, 181), (188, 240), (246, 302),
        (309, 346), (353, 382), (386, 430), (437, 470)
    ]
    frame_guids = [str(uuid.uuid4()) for _ in range(8)]
    key_guids = [str(uuid.uuid4()) for _ in range(8)]
    
    for i, (cx1, cx2) in enumerate(r9_cols):
        fg = frame_guids[i]
        min_x, max_x = cx1, cx2
        min_y, max_y = 583, 540
        for y in range(540, 584):
            for x in range(cx1, cx2 + 1):
                if sheet.getpixel((x, y))[3] > 0:
                    if y < min_y: min_y = y
                    if y > max_y: max_y = y
        sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
        sw, sh = sub.size
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        cx = ox - sw // 2
        cy = oy - (583 - min_y)
        canvas.paste(sub, (cx, cy))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 15.0, frame_guids, layer_guid, key_guids))
    print('sX_Dash generated cleanly.')

# =========================================================================
# 4. GENERATE sX_WallSlide (6 frames from Row 18)
# Canvas: 56x64, ox=28 (center, matching sX_Jump!), oy=58
# Flipped horizontally so wall is on LEFT at cx=18 (x - 28 + 18 = x - 10)
# =========================================================================
def gen_wall():
    spr_name = 'sX_WallSlide'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 64, 64, 28, 58
    layer_guid = str(uuid.uuid4())
    r18_cols = [
        (67, 98), (104, 137), (147, 180),
        (189, 220), (230, 260), (272, 299)
    ]
    frame_guids = [str(uuid.uuid4()) for _ in range(6)]
    key_guids = [str(uuid.uuid4()) for _ in range(6)]
    
    for i, (cx1, cx2) in enumerate(r18_cols):
        fg = frame_guids[i]
        min_x, max_x = cx1, cx2
        min_y, max_y = 1099, 1038
        for y in range(1038, 1100):
            for x in range(cx1, cx2 + 1):
                if sheet.getpixel((x, y))[3] > 0:
                    if y < min_y: min_y = y
                    if y > max_y: max_y = y
        sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
        sub_flipped = sub.transpose(Image.FLIP_LEFT_RIGHT)
        sw, sh = sub_flipped.size
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        # Wall contact at cx = 18 on 56-wide canvas with ox = 28
        cx = 18
        cy = oy - (1096 - min_y)
        canvas.paste(sub_flipped, (cx, cy))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 12.0, frame_guids, layer_guid, key_guids))
    print('sX_WallSlide generated cleanly.')

gen_idle()
gen_jump()
gen_dash()
gen_wall()
print('ALL SPRITES GENERATED SUCCESSFULLY!')
