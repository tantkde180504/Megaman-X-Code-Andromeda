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
# 1. GENERATE sX_Idle_Shoot (8 frames from Row 5)
# Canvas: 64x52, ox=28, oy=50 (matches sX_Idle origin ox=28, oy=50)
# =========================================================================
def gen_idle_shoot():
    spr_name = 'sX_Idle_Shoot'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 64, 52, 28, 50
    layer_guid = str(uuid.uuid4())
    r5_cols = [
        (85, 133), (142, 189), (198, 246), (256, 304),
        (315, 354), (374, 414), (421, 458), (465, 498)
    ]
    frame_guids = [str(uuid.uuid4()) for _ in range(8)]
    key_guids = [str(uuid.uuid4()) for _ in range(8)]
    base_y = 341
    
    for i, (cx1, cx2) in enumerate(r5_cols):
        fg = frame_guids[i]
        min_x, max_x = cx1, cx2
        min_y, max_y = 341, 297
        for y in range(297, 342):
            for x in range(cx1, cx2 + 1):
                if sheet.getpixel((x, y))[3] > 0:
                    if y < min_y: min_y = y
                    if y > max_y: max_y = y
        sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
        sw, sh = sub.size
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        # Body alignment: feet start at x=11 on canvas
        cx = 11
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
    print('sX_Idle_Shoot generated cleanly.')

# =========================================================================
# 2. GENERATE sX_Run_Shoot (16 frames: 8 from Row 12, 8 from Row 13)
# Canvas: 64x52, ox=28, oy=50 (matches sX_Run ox=28, oy=50)
# =========================================================================
def gen_run_shoot():
    spr_name = 'sX_Run_Shoot'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 64, 52, 28, 50
    layer_guid = str(uuid.uuid4())
    
    r12_cols = [(94, 138), (146, 190), (193, 236), (245, 288), (293, 337), (347, 391), (397, 446), (452, 501)]
    r13_cols = [(73, 126), (131, 184), (189, 241), (248, 300), (307, 354), (364, 411), (419, 461), (470, 512)]
    
    frame_guids = [str(uuid.uuid4()) for _ in range(16)]
    key_guids = [str(uuid.uuid4()) for _ in range(16)]
    
    for i in range(16):
        fg = frame_guids[i]
        if i < 8:
            cx1, cx2 = r12_cols[i]
            y_start, y_end = 717, 763
            base_y = 762
        else:
            cx1, cx2 = r13_cols[i - 8]
            y_start, y_end = 770, 815
            base_y = 814
            
        min_x, max_x = cx1, cx2
        min_y, max_y = y_end, y_start
        for y in range(y_start, y_end + 1):
            for x in range(cx1, cx2 + 1):
                if sheet.getpixel((x, y))[3] > 0:
                    if y < min_y: min_y = y
                    if y > max_y: max_y = y
        sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
        sw, sh = sub.size
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        # Body alignment: gem is at 26 in sub, gem on sX_Run is at 38 -> cx = 12
        cx = 12
        cy = oy - (base_y - min_y)
        canvas.paste(sub, (cx, cy))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 15.0, frame_guids, layer_guid, key_guids))
    print('sX_Run_Shoot generated cleanly.')

# =========================================================================
# 3. GENERATE sX_Jump_Shoot (11 frames matching sX_Jump from Row 10)
# Canvas: 64x64, ox=28, oy=58 (matches sX_Jump ox=28, oy=58)
# =========================================================================
def gen_jump_shoot():
    spr_name = 'sX_Jump_Shoot'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 64, 64, 28, 58
    layer_guid = str(uuid.uuid4())
    
    r10_cols = [
        (55, 88), (96, 129), (134, 167), (172, 205),
        (210, 243), (252, 285), (291, 324), (330, 363),
        (369, 405), (412, 448), (457, 496), (501, 540)
    ]
    # Map to 11 frames matching sX_Jump indices (0..10):
    # 0: prep (F1), 1: rise (F2), 2: rise (F3), 3: rise (F4),
    # 4: apex (F5), 5: apex (F6), 6: apex (F7),
    # 7: fall (F8) -> matches frame 8 of sX_Jump!
    # 8: land (F9), 9: land (F11), 10: land (F12)
    selected_indices = [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11]
    
    frame_guids = [str(uuid.uuid4()) for _ in range(11)]
    key_guids = [str(uuid.uuid4()) for _ in range(11)]
    base_y = 648
    
    for i, sel_idx in enumerate(selected_indices):
        fg = frame_guids[i]
        cx1, cx2 = r10_cols[sel_idx]
        min_x, max_x = cx1, cx2
        min_y, max_y = 648, 592
        for y in range(592, 649):
            for x in range(cx1, cx2 + 1):
                if sheet.getpixel((x, y))[3] > 0:
                    if y < min_y: min_y = y
                    if y > max_y: max_y = y
        sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
        sw, sh = sub.size
        
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
    print('sX_Jump_Shoot generated cleanly.')

# =========================================================================
# 4. GENERATE sX_Dash_Shoot (8 frames: Row 16 for dash + Row 17 for recovery)
# Canvas: 72x52, ox=32, oy=50 (matches sX_Dash oy=50)
# =========================================================================
def gen_dash_shoot():
    spr_name = 'sX_Dash_Shoot'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 72, 52, 32, 50
    layer_guid = str(uuid.uuid4())
    
    # Active dash: Row 16 (indices 0, 2, 4, 6) -> 4 frames
    r16_cols = [(44, 89), (146, 201), (269, 330), (403, 468)]
    # Recovery: Row 17 (indices 0, 2, 4, 6) -> 4 frames
    r17_cols = [(79, 126), (185, 229), (285, 328), (387, 434)]
    
    frame_guids = [str(uuid.uuid4()) for _ in range(8)]
    key_guids = [str(uuid.uuid4()) for _ in range(8)]
    
    for i in range(8):
        fg = frame_guids[i]
        if i < 4:
            cx1, cx2 = r16_cols[i]
            y_start, y_end = 927, 970
            base_y = 969
        else:
            cx1, cx2 = r17_cols[i - 4]
            y_start, y_end = 984, 1028
            base_y = 1027
            
        min_x, max_x = cx1, cx2
        min_y, max_y = y_end, y_start
        for y in range(y_start, y_end + 1):
            for x in range(cx1, cx2 + 1):
                if sheet.getpixel((x, y))[3] > 0:
                    if y < min_y: min_y = y
                    if y > max_y: max_y = y
        sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
        sw, sh = sub.size
        
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
        f.write(build_yy(spr_name, w, h, ox, oy, 15.0, frame_guids, layer_guid, key_guids))
    print('sX_Dash_Shoot generated cleanly.')

# =========================================================================
# 5. GENERATE sX_WallSlide_Shoot (2 frames from Row 18: Sprites 09 and 10)
# Canvas: 64x64, ox=28, oy=58 (matches sX_WallSlide and sX_Jump!)
# Horizontally flipped: wall on left at cx=18, buster firing right at cx=60
# =========================================================================
def gen_wall_shoot():
    spr_name = 'sX_WallSlide_Shoot'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 64, 64, 28, 58
    layer_guid = str(uuid.uuid4())
    
    # 2 Frames ONLY: Sprite 09 (buster fire) and Sprite 10 (muzzle flash)
    frames_spec = [
        ((397, 439), 1099),
        ((449, 491), 1097)
    ]
    frame_guids = [str(uuid.uuid4()) for _ in range(2)]
    key_guids = [str(uuid.uuid4()) for _ in range(2)]
    
    for i, ((cx1, cx2), base_y) in enumerate(frames_spec):
        fg = frame_guids[i]
        min_x, max_x = cx2, cx1
        min_y, max_y = 1099, 1035
        for y in range(1035, 1100):
            for x in range(cx1, cx2 + 1):
                if sheet.getpixel((x, y))[3] > 0:
                    if x < min_x: min_x = x
                    if x > max_x: max_x = x
                    if y < min_y: min_y = y
                    if y > max_y: max_y = y
        sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
        sub_flipped = sub.transpose(Image.FLIP_LEFT_RIGHT)
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        cx = 18
        cy = oy - (base_y - min_y)
        canvas.paste(sub_flipped, (cx, cy))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 12.0, frame_guids, layer_guid, key_guids))
    print('sX_WallSlide_Shoot generated cleanly.')

if __name__ == '__main__':
    gen_idle_shoot()
    gen_run_shoot()
    gen_jump_shoot()
    gen_dash_shoot()
    gen_wall_shoot()
    print('ALL SHOOTING SPRITES GENERATED SUCCESSFULLY!')
