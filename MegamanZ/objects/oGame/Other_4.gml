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
}

// Spawn player at checkpoint (playable stages only)
if (room_get_name(room) != "rTitle" && !instance_exists(oPlayer)) {
    var _spawn_x = global.checkpoint_x;
    var _spawn_y = global.checkpoint_y;
    if (room_get_name(room) == "rBoss_NightmareZero") {
        _spawn_x = 80;
        _spawn_y = 240;
    }
    var _obj = (global.current_char == CHAR_TYPE.X) ? oPlayerX : oPlayerZero;
    var _p = instance_create_layer(_spawn_x, _spawn_y, "Instances", _obj);
    _p.has_air_dash = global.has_air_dash;
    _p.state = PLAYER_STATE.INTRO;
    _p.intro_phase = 0;
    _p.teleport_beam_y = _p.y - 240;
    _p.teleport_sphere_frame = 1.0;
    _p.intro_anim_frame = 0.0;
    _p.intro_hold_timer = 25;
}

