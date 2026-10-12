if (room_get_name(room) == "rTitle") return;

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
    global.checkpoint_y = 750;
    room_goto(rStage_WebSpider);
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
        _new_p.has_air_dash = global.has_air_dash;
        
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
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        _p.state = PLAYER_STATE.TELEPORT_OUT;
        _p.teleport_out_frame = 0.0;
    }
}
