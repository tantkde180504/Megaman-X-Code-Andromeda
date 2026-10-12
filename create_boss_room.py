import os
import json

base_dir = r'd:\MZ4\MegamanZ'
rooms_dir = os.path.join(base_dir, 'rooms')
room_name = 'rBoss_NightmareZero'
room_folder = os.path.join(rooms_dir, room_name)
os.makedirs(room_folder, exist_ok=True)

# Build rBoss_NightmareZero.yy
room_yy_content = '''{
  "$GMRoom":"v1",
  "%Name":"rBoss_NightmareZero",
  "creationCodeFile":"",
  "inheritCode":false,
  "inheritCreationOrder":false,
  "inheritLayers":false,
  "instanceCreationOrder":[
    {"name":"inst_oGame","path":"rooms/rBoss_NightmareZero/rBoss_NightmareZero.yy",},
  ],
  "isDnd":false,
  "layers":[
    {"$GMRInstanceLayer":"","%Name":"Instances","depth":0,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"$GMRInstance":"v4","%Name":"inst_oGame","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"name":"inst_oGame","objectId":{"name":"oGame","path":"objects/oGame/oGame.yy",},"properties":[],"resourceType":"GMRInstance","resourceVersion":"2.0","rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":0.0,"y":0.0,},
      ],"layers":[],"name":"Instances","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
    {"$GMRBackgroundLayer":"","%Name":"Background","animationFPS":15.0,"animationSpeedType":0,"colour":4281345820,"depth":100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"hspeed":0.0,"htiled":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Background","properties":[],"resourceType":"GMRBackgroundLayer","resourceVersion":"2.0","spriteId":null,"stretch":false,"userdefinedAnimFPS":false,"userdefinedDepth":false,"visible":true,"vspeed":0.0,"vtiled":false,"x":0,"y":0,},
  ],
  "name":"rBoss_NightmareZero",
  "parent":{
    "name":"MegamanZ",
    "path":"MegamanZ.yyp",
  },
  "parentRoom":null,
  "physicsSettings":{
    "inheritPhysicsSettings":false,
    "PhysicsWorld":false,
    "PhysicsWorldGravityX":0.0,
    "PhysicsWorldGravityY":10.0,
    "PhysicsWorldPixToMetres":0.1,
  },
  "resourceType":"GMRoom",
  "resourceVersion":"2.0",
  "roomSettings":{
    "Height":270,
    "inheritRoomSettings":false,
    "persistent":false,
    "Width":480,
  },
  "sequenceId":null,
  "views":[
    {"hborder":32,"hport":540,"hspeed":-1,"hview":270,"inherit":false,"objectId":null,"vborder":32,"visible":true,"vspeed":-1,"wport":960,"wview":480,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
  ],
  "viewSettings":{
    "clearDisplayBuffer":true,
    "clearViewBackground":false,
    "enableViews":true,
    "inheritViewSettings":false,
  },
  "volume":1.0,
}
'''

with open(os.path.join(room_folder, f"{room_name}.yy"), 'w', encoding='utf-8') as f:
    f.write(room_yy_content)
print(f"Created room: {room_name}")

# Now register in MegamanZ.yyp
yyp_path = os.path.join(base_dir, 'MegamanZ.yyp')
with open(yyp_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

yyp_content = "".join(lines)

# 1. Add to resources if not already present
resource_entry = f'    {{"id":{{"name":"{room_name}","path":"rooms/{room_name}/{room_name}.yy",}},}},\n'
if f'"{room_name}"' not in yyp_content:
    new_lines = []
    for i, line in enumerate(lines):
        if line.strip() == '],' and i + 1 < len(lines) and 'resourceType' in lines[i + 1]:
            new_lines.append(resource_entry)
        new_lines.append(line)
    lines = new_lines

# 2. Add to RoomOrderNodes if not already present
room_order_entry = f'    {{"roomId":{{"name":"{room_name}","path":"rooms/{room_name}/{room_name}.yy",}},}},\n'
room_order_lines = []
in_room_order = False
for line in lines:
    if '"RoomOrderNodes":[' in line:
        in_room_order = True
        room_order_lines.append(line)
        continue
    if in_room_order and ']' in line:
        if f'"roomId":{{"name":"{room_name}"' not in "".join(lines):
            room_order_lines.append(room_order_entry)
        in_room_order = False
    room_order_lines.append(line)

with open(yyp_path, 'w', encoding='utf-8') as f:
    f.writelines(room_order_lines)

print("rBoss_NightmareZero successfully registered in MegamanZ.yyp!")
