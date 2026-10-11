import os
import shutil
import uuid
from PIL import Image

sheet_path = r'd:\MZ4\MegamanZ\sprites\sSheet_Goc\d39637a4-0e02-4a7e-961d-6aa3225312b5.png'
sheet = Image.open(sheet_path).convert('RGBA')

sprites_dir = r'd:\MZ4\MegamanZ\sprites'

def build_yy(spr_name, w, h, ox, oy, speed, frame_guids, layer_guids, key_guids):
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
    
    first_layer_guid = layer_guids[0]
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
    {{"$GMImageLayer":"","%Name":"{first_layer_guid}","blendMode":0,"displayName":"default","isLocked":false,"name":"{first_layer_guid}","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,}},
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
# 1. GENERATE sX_Idle (5 frames)
# =========================================================================
idle_name = 'sX_Idle'
idle_dir = os.path.join(sprites_dir, idle_name)
if os.path.exists(idle_dir):
    shutil.rmtree(idle_dir)
os.makedirs(os.path.join(idle_dir, 'layers'), exist_ok=True)

idle_w, idle_h = 56, 52
idle_ox, idle_oy = 28, 50

idle_boxes = [
    (189, 174, 223, 219),
    (231, 175, 265, 219),
    (274, 176, 308, 219),
    (317, 176, 351, 219),
    (359, 176, 393, 219)
]

idle_frame_guids = [str(uuid.uuid4()) for _ in range(5)]
idle_layer_guids = [str(uuid.uuid4()) for _ in range(5)]
idle_key_guids = [str(uuid.uuid4()) for _ in range(5)]

for i, (x1, y1, x2, y2) in enumerate(idle_boxes):
    fg = idle_frame_guids[i]
    lg = idle_layer_guids[i]
    sub = sheet.crop((x1, y1, x2 + 1, y2 + 1))
    sw, sh = sub.size
    
    canvas = Image.new('RGBA', (idle_w, idle_h), (0, 0, 0, 0))
    cx = idle_ox - sw // 2
    cy = idle_oy - sh + 1
    canvas.paste(sub, (cx, cy))
    
    # Save frame image
    frame_path = os.path.join(idle_dir, f'{fg}.png')
    canvas.save(frame_path)
    
    # If first frame, save composite
    if i == 0:
        canvas.save(os.path.join(idle_dir, f'{idle_name}.png'))
        
    # Save layer image
    layer_dir = os.path.join(idle_dir, 'layers', fg)
    os.makedirs(layer_dir, exist_ok=True)
    canvas.save(os.path.join(layer_dir, f'{lg}.png'))

with open(os.path.join(idle_dir, f'{idle_name}.yy'), 'w', encoding='utf-8') as f:
    f.write(build_yy(idle_name, idle_w, idle_h, idle_ox, idle_oy, 6.0, idle_frame_guids, idle_layer_guids, idle_key_guids))
print('sX_Idle generated cleanly.')

# =========================================================================
# 2. GENERATE sX_Jump (11 frames)
# =========================================================================
jump_name = 'sX_Jump'
jump_dir = os.path.join(sprites_dir, jump_name)
if os.path.exists(jump_dir):
    shutil.rmtree(jump_dir)
os.makedirs(os.path.join(jump_dir, 'layers'), exist_ok=True)

jump_w, jump_h = 56, 64
jump_ox, jump_oy = 28, 58

jump_cols = [
    (98, 122), (131, 153), (163, 185), (203, 225), (236, 262),
    (272, 305), (312, 343), (353, 381), (391, 421), (429, 457), (464, 495)
]

jump_frame_guids = [str(uuid.uuid4()) for _ in range(11)]
jump_layer_guids = [str(uuid.uuid4()) for _ in range(11)]
jump_key_guids = [str(uuid.uuid4()) for _ in range(11)]

for i, (cx1, cx2) in enumerate(jump_cols):
    fg = jump_frame_guids[i]
    lg = jump_layer_guids[i]
    
    # Calculate exact non-transparent bounding box in Row 4 (Y=[229..285])
    min_x, max_x = cx1, cx2
    min_y, max_y = 285, 229
    for y in range(229, 286):
        for x in range(cx1, cx2 + 1):
            if sheet.getpixel((x, y))[3] > 0:
                if y < min_y: min_y = y
                if y > max_y: max_y = y
                
    sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
    sw, sh = sub.size
    
    base_y = 284
    if i == 10:  # Frame 11 recovery
        base_y = 280
        
    canvas = Image.new('RGBA', (jump_w, jump_h), (0, 0, 0, 0))
    cx = jump_ox - sw // 2
    cy = jump_oy - (base_y - min_y)
    canvas.paste(sub, (cx, cy))
    
    frame_path = os.path.join(jump_dir, f'{fg}.png')
    canvas.save(frame_path)
    
    if i == 0:
        canvas.save(os.path.join(jump_dir, f'{jump_name}.png'))
        
    layer_dir = os.path.join(jump_dir, 'layers', fg)
    os.makedirs(layer_dir, exist_ok=True)
    canvas.save(os.path.join(layer_dir, f'{lg}.png'))

with open(os.path.join(jump_dir, f'{jump_name}.yy'), 'w', encoding='utf-8') as f:
    f.write(build_yy(jump_name, jump_w, jump_h, jump_ox, jump_oy, 12.0, jump_frame_guids, jump_layer_guids, jump_key_guids))
print('sX_Jump generated cleanly.')
