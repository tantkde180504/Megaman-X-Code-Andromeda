import os
import json

base_dir = r'd:\MZ4\MegamanZ'
scripts_dir = os.path.join(base_dir, 'scripts')
script_name = 'scr_build_boss_room_nightmare_zero'
script_folder = os.path.join(scripts_dir, script_name)
os.makedirs(script_folder, exist_ok=True)

script_code = '''/// @desc Build Dedicated Mega Man X6 Nightmare Zero Boss Arena
function scr_build_boss_room_nightmare_zero() {
    // Tránh sinh trùng lặp nếu địa hình đã tồn tại
    if (instance_exists(oSolid)) return;
    
    var _block_sz = 16;
    
    // -------------------------------------------------------------
    // 1. SÀN ĐẤU (Floor: y = 240 .. 270, độ dày 2 block)
    // -------------------------------------------------------------
    for (var _bx = 0; _bx < room_width; _bx += _block_sz) {
        for (var _by = 240; _by < room_height; _by += _block_sz) {
            instance_create_layer(_bx, _by, "Instances", oSolid);
        }
    }
    
    // -------------------------------------------------------------
    // 2. TRẦN PHÒNG ĐẤU (Ceiling: y = 0 .. 16)
    // -------------------------------------------------------------
    for (var _bx = 0; _bx < room_width; _bx += _block_sz) {
        instance_create_layer(_bx, 0, "Instances", oSolid);
    }
    
    // -------------------------------------------------------------
    // 3. TƯỜNG TRÁI (Left Wall: x = 0 .. 16) - Hỗ trợ Wall Slide & Wall Kick
    // -------------------------------------------------------------
    for (var _by = 0; _by < room_height; _by += _block_sz) {
        instance_create_layer(0, _by, "Instances", oSolid);
    }
    
    // -------------------------------------------------------------
    // 4. TƯỜNG PHẢI (Right Wall: x = 464 .. 480) - Hỗ trợ Wall Slide & Wall Kick
    // -------------------------------------------------------------
    for (var _by = 0; _by < room_height; _by += _block_sz) {
        instance_create_layer(room_width - _block_sz, _by, "Instances", oSolid);
    }
    
    // -------------------------------------------------------------
    // 5. CỔNG TRÙM (Boss Gate) bên trái (đã khóa lúc chiến đấu)
    // -------------------------------------------------------------
    var _gate = instance_create_layer(16, 240 - 48, "Instances", oTrigger_BossGate);
    _gate.gate_state = GATE_STATE.LOCKED;
    _gate.door_y = 0;
    
    // -------------------------------------------------------------
    // 6. KHỞI TẠO BOSS NIGHTMARE ZERO TẠI ĐẤU TRƯỜNG (x = 360, y = 240)
    // -------------------------------------------------------------
    if (!instance_exists(obj_nightmare_zero)) {
        var _boss = instance_create_layer(360, 240, "Instances", obj_nightmare_zero);
        _boss.facing = -1;
    }
}
'''

with open(os.path.join(script_folder, f"{script_name}.gml"), 'w', encoding='utf-8') as f:
    f.write(script_code)

yy_content = f'''{{
  "$GMScript":"v1",
  "%Name":"{script_name}",
  "isCompatibility":false,
  "isDnD":false,
  "name":"{script_name}",
  "parent":{{
    "name":"Scripts",
    "path":"folders/Scripts.yy",
  }},
  "resourceType":"GMScript",
  "resourceVersion":"2.0",
}}
'''

with open(os.path.join(script_folder, f"{script_name}.yy"), 'w', encoding='utf-8') as f:
    f.write(yy_content)

print(f"Created script: {script_name}")

# Register script in MegamanZ.yyp
yyp_path = os.path.join(base_dir, 'MegamanZ.yyp')
with open(yyp_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

script_entry = f'    {{"id":{{"name":"{script_name}","path":"scripts/{script_name}/{script_name}.yy",}},}},\n'
if f'"{script_name}"' not in "".join(lines):
    new_lines = []
    for i, line in enumerate(lines):
        if line.strip() == '],' and i + 1 < len(lines) and 'resourceType' in lines[i + 1]:
            new_lines.append(script_entry)
        new_lines.append(line)
    with open(yyp_path, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    print(f"Registered {script_name} in MegamanZ.yyp!")
else:
    print(f"{script_name} already in yyp.")
