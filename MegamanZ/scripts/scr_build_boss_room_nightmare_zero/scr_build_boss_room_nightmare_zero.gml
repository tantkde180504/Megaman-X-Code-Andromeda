/// @desc Build Dedicated Mega Man X6 Nightmare Zero Boss Arena
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
