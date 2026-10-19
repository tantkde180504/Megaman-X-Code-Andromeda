var _is_menu_room = (room_get_name(room) == "rTitle" || room_get_name(room) == "rStageSelect");

if (_is_menu_room) {
    music_stop_all();
    if (instance_exists(oPlayer)) {
        with (oPlayer) instance_destroy();
    }
    if (instance_exists(oUI_HUD)) {
        with (oUI_HUD) instance_destroy();
    }
    if (instance_exists(oParallaxBackground)) {
        with (oParallaxBackground) instance_destroy();
    }
    return;
}

if (!instance_exists(oInput)) instance_create_layer(0, 0, "Instances", oInput);
if (!instance_exists(oCamera)) instance_create_layer(0, 0, "Instances", oCamera);
if (!instance_exists(oUI_HUD)) instance_create_layer(0, 0, "Instances", oUI_HUD);
if (!instance_exists(oParallaxBackground)) instance_create_layer(0, 0, "Instances", oParallaxBackground);

// Build appropriate stage layout
if (room == Room1) {
    scr_build_test_room();
} else if (room_get_name(room) == "rStage_Intro") {
    scr_build_stage_intro();
} else if (room_get_name(room) == "rStage_WebSpider") {
    scr_build_stage_web_spider();
} else if (room_get_name(room) == "rBoss_NightmareZero") {
    scr_build_boss_room_nightmare_zero();
    music_play_boss_nightmare_zero();
}

// Ensure boss and boss gates exist in Web Spider stage
if (room_get_name(room) == "rStage_WebSpider") {
    if (!instance_exists(obj_nightmare_zero)) {
        var _boss = instance_create_layer(5250, 2096, "Instances", obj_nightmare_zero);
        _boss.facing = -1;
    }
    
    // Cấu hình chuẩn xác 2 cửa trùm: Cửa 1 (4656, 1920) và Cửa 2 (4800, 1936)
    with (oTrigger_BossGate) {
        if (x < 4750) {
            door_index = 1;
            is_arena_door = false;
        } else {
            door_index = 2;
            is_arena_door = true;
        }
    }
    
    // Nếu thiếu cửa nào thì tự động tạo đầy đủ cả 2 cửa
    if (instance_number(oTrigger_BossGate) < 2) {
        with (oTrigger_BossGate) instance_destroy();
        var _d1 = instance_create_layer(4656, 1920, "Instances", oTrigger_BossGate);
        _d1.door_index = 1;
        _d1.is_arena_door = false;
        _d1.gate_state = GATE_STATE.CLOSED;
        
        var _d2 = instance_create_layer(4800, 1936, "Instances", oTrigger_BossGate);
        _d2.door_index = 2;
        _d2.is_arena_door = true;
        _d2.gate_state = GATE_STATE.CLOSED;
    }
}

// Ensure all collision markers (placed manually or generated) are completely invisible in game
with (oSolid) visible = false;
with (oOneWayPlatform) visible = false;
with (oLadder) visible = false;
with (oIceSurface) visible = false;

// Spawn player at checkpoint (playable stages only)
if (!instance_exists(oPlayer)) {
    var _spawn_x = global.checkpoint_x;
    var _spawn_y = global.checkpoint_y;
    if (room_get_name(room) == "rBoss_NightmareZero") {
        _spawn_x = 80;
        _spawn_y = 240;
    } else if (room_get_name(room) == "rStage_WebSpider") {
        if (_spawn_y == 440 || _spawn_y == 750 || _spawn_y == 480) {
            _spawn_x = 64;
            _spawn_y = 352;
            global.checkpoint_x = _spawn_x;
            global.checkpoint_y = _spawn_y;
        }
    }
    var _obj = (global.current_char == CHAR_TYPE.X) ? oPlayerX : oPlayerZero;
    var _p = instance_create_layer(_spawn_x, _spawn_y, "Instances", _obj);
    _p.has_air_dash = (global.current_char == CHAR_TYPE.ZERO) ? true : global.has_air_dash;
    _p.has_double_jump = (global.current_char == CHAR_TYPE.ZERO) ? true : false;
    _p.state = PLAYER_STATE.INTRO;
    _p.intro_phase = 0;
    _p.teleport_beam_y = _p.y - 240;
    _p.teleport_sphere_frame = 1.0;
    _p.intro_anim_frame = 0.0;
    _p.intro_hold_timer = 25;
}

