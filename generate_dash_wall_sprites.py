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
# 1. GENERATE sX_Dash (8 frames from Row 9)
# =========================================================================
dash_name = 'sX_Dash'
dash_dir = os.path.join(sprites_dir, dash_name)
if os.path.exists(dash_dir):
    shutil.rmtree(dash_dir)
os.makedirs(os.path.join(dash_dir, 'layers'), exist_ok=True)

dash_w, dash_h = 64, 52
dash_ox, dash_oy = 32, 50

r9_cols = [
    (94, 129), (136, 181), (188, 240), (246, 302),
    (309, 346), (353, 382), (386, 430), (437, 470)
]

dash_frame_guids = [str(uuid.uuid4()) for _ in range(8)]
dash_layer_guids = [str(uuid.uuid4()) for _ in range(8)]
dash_key_guids = [str(uuid.uuid4()) for _ in range(8)]

for i, (cx1, cx2) in enumerate(r9_cols):
    fg = dash_frame_guids[i]
    lg = dash_layer_guids[i]
    
    min_x, max_x = cx1, cx2
    min_y, max_y = 583, 540
    for y in range(540, 584):
        for x in range(cx1, cx2 + 1):
            if sheet.getpixel((x, y))[3] > 0:
                if y < min_y: min_y = y
                if y > max_y: max_y = y
                
    sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
    sw, sh = sub.size
    
    canvas = Image.new('RGBA', (dash_w, dash_h), (0, 0, 0, 0))
    cx = dash_ox - sw // 2
    cy = dash_oy - (583 - min_y)
    canvas.paste(sub, (cx, cy))
    
    frame_path = os.path.join(dash_dir, f'{fg}.png')
    canvas.save(frame_path)
    
    if i == 0:
        canvas.save(os.path.join(dash_dir, f'{dash_name}.png'))
        
    layer_dir = os.path.join(dash_dir, 'layers', fg)
    os.makedirs(layer_dir, exist_ok=True)
    canvas.save(os.path.join(layer_dir, f'{lg}.png'))

with open(os.path.join(dash_dir, f'{dash_name}.yy'), 'w', encoding='utf-8') as f:
    f.write(build_yy(dash_name, dash_w, dash_h, dash_ox, dash_oy, 15.0, dash_frame_guids, dash_layer_guids, dash_key_guids))
print('sX_Dash generated cleanly.')

# =========================================================================
# 2. GENERATE sX_WallSlide (6 frames from Row 18) - FLIPPED HORIZONTALLY
# In original spritesheet, X was drawn facing Left (wall on Right).
# Standard GameMaker convention is facing Right (image_xscale = 1).
# We flip horizontally so:
# Base sprite (facing = 1): X faces Right, wall is on Left (cx = 0).
# Flipped sprite (facing = -1): X faces Left, wall is on Right.
# =========================================================================
wall_name = 'sX_WallSlide'
wall_dir = os.path.join(sprites_dir, wall_name)
if os.path.exists(wall_dir):
    shutil.rmtree(wall_dir)
os.makedirs(os.path.join(wall_dir, 'layers'), exist_ok=True)

wall_w, wall_h = 56, 64
wall_ox, wall_oy = 10, 58

r18_cols = [
    (67, 98), (104, 137), (147, 180),
    (189, 220), (230, 260), (272, 299)
]

wall_frame_guids = [str(uuid.uuid4()) for _ in range(6)]
wall_layer_guids = [str(uuid.uuid4()) for _ in range(6)]
wall_key_guids = [str(uuid.uuid4()) for _ in range(6)]

for i, (cx1, cx2) in enumerate(r18_cols):
    fg = wall_frame_guids[i]
    lg = wall_layer_guids[i]
    
    min_x, max_x = cx1, cx2
    min_y, max_y = 1099, 1038
    for y in range(1038, 1100):
        for x in range(cx1, cx2 + 1):
            if sheet.getpixel((x, y))[3] > 0:
                if y < min_y: min_y = y
                if y > max_y: max_y = y
                
    sub = sheet.crop((min_x, min_y, max_x + 1, max_y + 1))
    # Flip horizontally so wall contact is on LEFT and X faces RIGHT by default!
    sub_flipped = sub.transpose(Image.FLIP_LEFT_RIGHT)
    sw, sh = sub_flipped.size
    
    canvas = Image.new('RGBA', (wall_w, wall_h), (0, 0, 0, 0))
    # Wall contact is on the left edge (cx = 0)
    cx = 0
    base_y = 1096
    cy = wall_oy - (base_y - min_y)
    canvas.paste(sub_flipped, (cx, cy))
    
    frame_path = os.path.join(wall_dir, f'{fg}.png')
    canvas.save(frame_path)
    
    if i == 0:
        canvas.save(os.path.join(wall_dir, f'{wall_name}.png'))
        
    layer_dir = os.path.join(wall_dir, 'layers', fg)
    os.makedirs(layer_dir, exist_ok=True)
    canvas.save(os.path.join(layer_dir, f'{lg}.png'))

with open(os.path.join(wall_dir, f'{wall_name}.yy'), 'w', encoding='utf-8') as f:
    f.write(build_yy(wall_name, wall_w, wall_h, wall_ox, wall_oy, 12.0, wall_frame_guids, wall_layer_guids, wall_key_guids))
print('sX_WallSlide generated cleanly with corrected horizontal orientation.')
