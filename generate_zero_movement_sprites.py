import os
import shutil
import uuid
from PIL import Image

sheet_path = r'd:\MZ4\MegamanZ\sprites\sSheet_Z\05b35703-9173-4a74-8d75-bd5c55661edb.png'
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
# 1. GENERATE sZero_Idle (5 frames from Row 02: F5..F9)
# =========================================================================
def gen_idle():
    spr_name = 'sZero_Idle'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 64, 64, 28, 58
    layer_guid = str(uuid.uuid4())
    
    # Row 02 in sheet is y=95..152. Baseline y is 151
    # Clusters F5..F9:
    idle_cols = [(292, 334), (341, 383), (390, 431), (436, 478), (485, 527)]
    
    frame_guids = [str(uuid.uuid4()) for _ in range(5)]
    key_guids = [str(uuid.uuid4()) for _ in range(5)]
    
    for i, (cx1, cx2) in enumerate(idle_cols):
        fg = frame_guids[i]
        sub = sheet.crop((cx1, 95, cx2 + 1, 153))
        bb = sub.getbbox()
        sub_c = sub.crop(bb)
        sw, sh = sub_c.size
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        cx = ox - sw // 2
        cy = oy - sh
        canvas.paste(sub_c, (cx, cy))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 6.0, frame_guids, layer_guid, key_guids))
    print('sZero_Idle generated cleanly.')

# =========================================================================
# 2. GENERATE sZero_Run (16 frames from Row 04 + Row 05)
# =========================================================================
def gen_run():
    spr_name = 'sZero_Run'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 64, 64, 28, 58
    layer_guid = str(uuid.uuid4())
    
    r4_cols = [(117, 152), (163, 200), (207, 257), (265, 314), (320, 367), (375, 420), (429, 472), (481, 520)]
    r5_cols = [(111, 155), (167, 215), (223, 267), (275, 324), (332, 377), (387, 429), (437, 478), (487, 531)]
    
    frame_guids = [str(uuid.uuid4()) for _ in range(16)]
    key_guids = [str(uuid.uuid4()) for _ in range(16)]
    
    for i in range(16):
        fg = frame_guids[i]
        if i < 8:
            cx1, cx2 = r4_cols[i]
            y1, y2 = 320, 369
        else:
            cx1, cx2 = r5_cols[i - 8]
            y1, y2 = 384, 433
            
        sub = sheet.crop((cx1, y1, cx2 + 1, y2 + 1))
        bb = sub.getbbox()
        sub_c = sub.crop(bb)
        
        # Find head_x in sub_c to ensure rock-solid stability
        head_x = -1
        for y in range(sub_c.height):
            for x in range(sub_c.width):
                r, g, b, a = sub_c.getpixel((x, y))
                if a > 200 and r > 180 and g < 60 and b < 60:
                    head_x = x
                    break
            if head_x != -1: break
            
        target_head_x = 32
        canvas_x = target_head_x - head_x
        canvas_y = oy - sub_c.height
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        canvas.paste(sub_c, (canvas_x, canvas_y))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 15.0, frame_guids, layer_guid, key_guids))
    print('sZero_Run generated cleanly.')

# =========================================================================
# 3. GENERATE sZero_Jump (11 frames from Row 03: 0..4 rise, 5..7 fall, 8..10 land)
# =========================================================================
def gen_jump():
    spr_name = 'sZero_Jump'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 64, 72, 28, 66
    layer_guid = str(uuid.uuid4())
    
    # In sheet:
    # Row 3a (y=164..230): F1, F2, F3, F5, F7
    # Row 3b (y=232..310): F1, F2, F5, F6, F7, F8
    r3a_y1, r3a_y2 = 164, 230
    r3b_y1, r3b_y2 = 232, 310
    
    selected_frames = [
        # (y1, y2, cx1, cx2, is_ground)
        (r3a_y1, r3a_y2, 121, 159, True),   # 0: Launch crouch (F1)
        (r3a_y1, r3a_y2, 167, 209, False),  # 1: Rise leap 1 (F2)
        (r3a_y1, r3a_y2, 219, 261, False),  # 2: Rise leap 2 (F3)
        (r3a_y1, r3a_y2, 319, 361, False),  # 3: Mid-rise (F5)
        (r3a_y1, r3a_y2, 425, 463, False),  # 4: Apex flip (F7)
        (r3b_y1, r3b_y2, 133, 168, False),  # 5: Apex high (F1)
        (r3b_y1, r3b_y2, 179, 212, False),  # 6: Airborne fall pose (F2)
        (r3b_y1, r3b_y2, 311, 350, False),  # 7: Touchdown prep (F5)
        (r3b_y1, r3b_y2, 362, 403, True),   # 8: Landing impact crouch (F6)
        (r3b_y1, r3b_y2, 411, 453, True),   # 9: Landing rising (F7)
        (r3b_y1, r3b_y2, 462, 504, True),   # 10: Landing ready stand (F8)
    ]
    
    frame_guids = [str(uuid.uuid4()) for _ in range(11)]
    key_guids = [str(uuid.uuid4()) for _ in range(11)]
    
    for i, (y1, y2, cx1, cx2, is_ground) in enumerate(selected_frames):
        fg = frame_guids[i]
        sub = sheet.crop((cx1, y1, cx2 + 1, y2 + 1))
        bb = sub.getbbox()
        sub_c = sub.crop(bb)
        sw, sh = sub_c.size
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        cx = ox - sw // 2
        cy = oy - sh
        canvas.paste(sub_c, (cx, cy))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 12.0, frame_guids, layer_guid, key_guids))
    print('sZero_Jump generated cleanly.')

# =========================================================================
# 4. GENERATE sZero_Dash (8 frames from Row 13)
# =========================================================================
def gen_dash():
    spr_name = 'sZero_Dash'
    spr_dir = os.path.join(sprites_dir, spr_name)
    if os.path.exists(spr_dir):
        shutil.rmtree(spr_dir)
    os.makedirs(os.path.join(spr_dir, 'layers'), exist_ok=True)
    
    w, h, ox, oy = 72, 64, 32, 58
    layer_guid = str(uuid.uuid4())
    
    # Row 13 in sheet: y=988..1035
    # Frames: F3 (111, 157), F4 (162, 217), F5 (227, 284), F6 (293, 350),
    #         F8 (422, 467), F9 (473, 514), F10 (522, 563), F11 (572, 613)
    dash_cols = [
        (111, 157), (162, 217), (227, 284), (293, 350),
        (422, 467), (473, 514), (522, 563), (572, 613)
    ]
    
    frame_guids = [str(uuid.uuid4()) for _ in range(8)]
    key_guids = [str(uuid.uuid4()) for _ in range(8)]
    
    for i, (cx1, cx2) in enumerate(dash_cols):
        fg = frame_guids[i]
        sub = sheet.crop((cx1, 988, cx2 + 1, 1036))
        bb = sub.getbbox()
        sub_c = sub.crop(bb)
        sw, sh = sub_c.size
        
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        cx = ox - sw // 2
        cy = oy - sh
        canvas.paste(sub_c, (cx, cy))
        
        canvas.save(os.path.join(spr_dir, f'{fg}.png'))
        if i == 0:
            canvas.save(os.path.join(spr_dir, f'{spr_name}.png'))
        ldir = os.path.join(spr_dir, 'layers', fg)
        os.makedirs(ldir, exist_ok=True)
        canvas.save(os.path.join(ldir, f'{layer_guid}.png'))
        
    with open(os.path.join(spr_dir, f'{spr_name}.yy'), 'w', encoding='utf-8') as f:
        f.write(build_yy(spr_name, w, h, ox, oy, 15.0, frame_guids, layer_guid, key_guids))
    print('sZero_Dash generated cleanly.')

if __name__ == '__main__':
    gen_idle()
    gen_run()
    gen_jump()
    gen_dash()
    print('ALL ZERO MOVEMENT SPRITES GENERATED SUCCESSFULLY!')
