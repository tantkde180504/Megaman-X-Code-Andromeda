if (room_get_name(room) == "rTitle" || room_get_name(room) == "rStageSelect") return;

// Boss defeat and the preview key share the actual stage-clear sequence.
if (global.boss_defeated && !global.stage_clear_active) {
    player_begin_stage_clear();
}
if (global.stage_clear_active) {
    if (global.stage_clear_complete) room_goto(rStageSelect);
    return;
}

// Return to Stage Select (Hunter Base)
if (keyboard_check_pressed(ord("9"))) {
    if (instance_exists(oPlayer)) {
        with (oPlayer) instance_destroy();
    }
    room_goto(rStageSelect);
    return;
}

// Return to Title Screen
if (keyboard_check_pressed(ord("0"))) {
    if (instance_exists(oPlayer)) {
        with (oPlayer) instance_destroy();
    }
    room_goto(rTitle);
    return;
}

// Stage quick selection keys (1: Playground, 2: Intro Stage, 3: Web Spider Stage)
if (keyboard_check_pressed(ord("1"))) {
    global.checkpoint_x = 64;
    global.checkpoint_y = 440;
    room_goto(Room1);
}
if (keyboard_check_pressed(ord("2"))) {
    global.checkpoint_x = 64;
    global.checkpoint_y = 480;
    room_goto(rStage_Intro);
}
if (keyboard_check_pressed(ord("3"))) {
    global.checkpoint_x = 64;
    global.checkpoint_y = 352;
    room_goto(rStage_WebSpider);
}
if (keyboard_check_pressed(ord("4"))) {
    // Jump directly to Jungle Stage Boss Arena
    global.checkpoint_x = 4820;
    global.checkpoint_y = 1984;
    if (room_get_name(room) == "rStage_WebSpider") {
        if (instance_exists(oPlayer)) {
            var _p = instance_find(oPlayer, 0);
            _p.x = 4820;
            _p.y = 1984;
            _p.hsp = 0;
            _p.vsp = 0;
            _p.state = PLAYER_STATE.IDLE;
        }
    } else {
        room_goto(rStage_WebSpider);
    }
}
if (keyboard_check_pressed(ord("5"))) {
    global.checkpoint_x = 80;
    global.checkpoint_y = 240;
    room_goto(rBoss_NightmareZero);
}

// Phím B: Triệu hồi Boss Nightmare Zero ngay tại vị trí người chơi
if (keyboard_check_pressed(ord("B"))) {
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        if (instance_exists(obj_nightmare_zero)) {
            var _b = instance_find(obj_nightmare_zero, 0);
            _b.x = clamp(_p.x + _p.facing * 160, 64, room_width - 64);
            _b.y = _p.y;
            while (!place_meeting(_b.x, _b.y + 1, oSolid) && _b.y < room_height - 16) _b.y++;
            while (place_meeting(_b.x, _b.y, oSolid) && _b.y > 16) _b.y--;
            _b.facing = -_p.facing;
            _b.visible = true;
            _b.arena_left = max(32, _p.x - 240);
            _b.arena_right = min(room_width - 32, _p.x + 240);
            _b.arena_center = (_b.arena_left + _b.arena_right) * 0.5;
            with (_b) {
                nz_change_state(NZ_STATE.INTRO);
                warning_timer = 60;
            }
        } else {
            var _bx = clamp(_p.x + _p.facing * 160, 64, room_width - 64);
            var _by = _p.y;
            while (!place_meeting(_bx, _by + 1, oSolid) && _by < room_height - 16) _by++;
            while (place_meeting(_bx, _by, oSolid) && _by > 16) _by--;
            var _new_b = instance_create_layer(_bx, _by, "Instances", obj_nightmare_zero);
            _new_b.facing = -_p.facing;
            _new_b.arena_left = max(32, _p.x - 240);
            _new_b.arena_right = min(room_width - 32, _p.x + 240);
            _new_b.arena_center = (_new_b.arena_left + _new_b.arena_right) * 0.5;
        }
    }
}


// Tab toggles character
if (global.input.tab_pressed) {
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        var _px = _p.x;
        var _py = _p.y;
        var _pfacing = _p.facing;
        var _php = _p.hp_current;
        var _pmaxhp = _p.hp_max;
        var _pstate = _p.state;
        var _phsp = _p.hsp;
        var _pvsp = _p.vsp;
        
        with (_p) { instance_destroy(); }
        
        var _new_obj = (global.current_char == CHAR_TYPE.X) ? oPlayerZero : oPlayerX;
        global.current_char = (global.current_char == CHAR_TYPE.X) ? CHAR_TYPE.ZERO : CHAR_TYPE.X;
        
        var _new_p = instance_create_layer(_px, _py, "Instances", _new_obj);
        _new_p.facing = _pfacing;
        _new_p.hp_max = _pmaxhp;
        _new_p.hp_current = _php;
        _new_p.state = _pstate;
        _new_p.hsp = _phsp;
        _new_p.vsp = _pvsp;
        _new_p.has_air_dash = (global.current_char == CHAR_TYPE.ZERO) ? true : global.has_air_dash;
        _new_p.has_double_jump = (global.current_char == CHAR_TYPE.ZERO) ? true : false;
        
        camera_shake(2, 6);
    }
}

if (global.input.restart_pressed) {
    room_restart();
}

if (global.input.debug_pressed) {
    global.debug_overlay = !global.debug_overlay;
}

// Debug Shortcuts: [I] trigger Intro Teleport-In, [O] trigger Teleport-Out
if (keyboard_check_pressed(ord("I"))) {
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        _p.state = PLAYER_STATE.INTRO;
        _p.intro_phase = 0;
        _p.teleport_beam_y = _p.y - 240;
        _p.teleport_sphere_frame = 1.0;
        _p.intro_anim_frame = 0.0;
        _p.intro_hold_timer = 25;
    }
}
if (keyboard_check_pressed(ord("O"))) {
    player_begin_stage_clear();
    return;
}

// Debug Shortcut: [K] Trigger Mega Man X4 Player Death Effect
if (keyboard_check_pressed(ord("K"))) {
    if (instance_exists(oPlayer)) {
        player_trigger_death();
    }
}

// Boss Shortcut: [B] Summon / Reset Nightmare Zero Boss
if (keyboard_check_pressed(ord("B"))) {
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        if (instance_exists(obj_nightmare_zero)) {
            with (obj_nightmare_zero) instance_destroy();
        }
        var _spawn_x = _p.x + ((_p.facing != 0) ? _p.facing * 140 : 140);
        _spawn_x = clamp(_spawn_x, 64, room_width - 64);
        var _nz = instance_create_layer(_spawn_x, _p.y, "Instances", obj_nightmare_zero);
        _nz.facing = (_p.x >= _nz.x) ? 1 : -1;
        camera_shake(4, 10);
    }
}

