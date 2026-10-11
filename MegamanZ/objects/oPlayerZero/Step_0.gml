event_inherited();

// Damage interrupts attacks
if (state == PLAYER_STATE.HURT) {
    slash_anim_timer = 0;
    is_air_slashing = false;
    is_dash_slashing = false;
    is_wall_slashing = false;
    is_ladder_slashing = false;
    combo_step = 0;
    combo_timer = 0;
    technique_state = TECHNIQUE.NONE;
    technique_timer = 0;
}

// Techniques input (Special button)
if (global.input.special_pressed) {
    if (grounded && global.input.up) {
        technique_state = TECHNIQUE.RYUENJIN;
        technique_timer = 24;
        vsp = -6.5;
        hsp = facing * 1.0;
        var _h = instance_create_layer(x + (facing * 16), y - 24, "Instances", oSaberHitbox);
        _h.damage = 4;
        _h.element = "fire";
        camera_shake(3, 8);
    } else if (!grounded && global.input.down) {
        technique_state = TECHNIQUE.HYOURETSUZAN;
        technique_timer = 30;
        vsp = 8.0;
        hsp = 0;
        var _h = instance_create_layer(x, y + 8, "Instances", oSaberHitbox);
        _h.damage = 4;
        _h.element = "ice";
    } else if (!grounded) {
        technique_state = TECHNIQUE.KUUENZAN;
        technique_timer = 20;
        var _h = instance_create_layer(x, y - 16, "Instances", oSaberHitbox);
        _h.damage = 3;
        _h.element = "slash";
    } else {
        technique_state = TECHNIQUE.RAIJINGEKI;
        technique_timer = 22;
        hsp = 0;
        var _h = instance_create_layer(x + (facing * 20), y - 16, "Instances", oSaberHitbox);
        _h.damage = 5;
        _h.element = "electric";
        camera_shake(2, 8);
    }
}

// Saber Combos (Attack button)
if (global.input.shoot_pressed) {
    if (state == PLAYER_STATE.WALL_SLIDE) {
        slash_anim_timer = 14;
        slash_anim_frame = 0.0;
        slash_total_frames = 9;
        is_wall_slashing = true;
        is_ladder_slashing = false;
        is_air_slashing = false;
        is_dash_slashing = false;
        var _h = instance_create_layer(x + (facing * 24), y - 20, "Instances", oSaberHitbox);
        _h.damage = 3.0;
    } else if (state == PLAYER_STATE.LADDER) {
        slash_anim_timer = 14;
        slash_anim_frame = 0.0;
        slash_total_frames = 9;
        is_ladder_slashing = true;
        is_wall_slashing = false;
        is_air_slashing = false;
        is_dash_slashing = false;
        var _h = instance_create_layer(x + (facing * 24), y - 20, "Instances", oSaberHitbox);
        _h.damage = 3.0;
    } else if (!grounded) {
        slash_anim_timer = 14;
        slash_anim_frame = 0.0;
        slash_total_frames = 9;
        is_air_slashing = true;
        is_dash_slashing = false;
        is_wall_slashing = false;
        is_ladder_slashing = false;
        var _h = instance_create_layer(x + (facing * 16), y - 16, "Instances", oSaberHitbox);
        _h.damage = 2.5;
    } else if (state == PLAYER_STATE.DASH) {
        slash_anim_timer = 14;
        slash_anim_frame = 0.0;
        slash_total_frames = 9;
        is_dash_slashing = true;
        is_air_slashing = false;
        is_wall_slashing = false;
        is_ladder_slashing = false;
        var _h = instance_create_layer(x + (facing * 18), y - 16, "Instances", oSaberHitbox);
        _h.damage = 3.0;
    } else {
        is_air_slashing = false;
        is_dash_slashing = false;
        is_wall_slashing = false;
        is_ladder_slashing = false;
        if (combo_step == 0) {
            combo_step = 1;
            combo_timer = COMBO_RESET_FRAMES;
            slash_anim_timer = 12;
            slash_anim_frame = 0.0;
            slash_total_frames = 10;
            hsp = 0;
            var _h = instance_create_layer(x + (facing * 16), y - 16, "Instances", oSaberHitbox);
            _h.damage = 2.0;
        } else if (combo_step == 1) {
            combo_step = 2;
            combo_timer = COMBO_RESET_FRAMES;
            slash_anim_timer = 12;
            slash_anim_frame = 0.0;
            slash_total_frames = 10;
            hsp = 0;
            var _h = instance_create_layer(x + (facing * 16), y - 16, "Instances", oSaberHitbox);
            _h.damage = 2.0;
        } else if (combo_step == 2) {
            combo_step = 3;
            combo_timer = 28;
            slash_anim_timer = 18;
            slash_anim_frame = 0.0;
            slash_total_frames = 14;
            hsp = 0;
            var _h = instance_create_layer(x + (facing * 22), y - 16, "Instances", oSaberHitbox);
            _h.damage = 4.0;
            camera_shake(3, 8);
        }
    }
}

// Saber Dash Cancel (SDC)
if (combo_step == 1 && global.input.dash_pressed) {
    combo_step = 0;
    combo_timer = 0;
    slash_anim_timer = 0;
    slash_anim_frame = 0.0;
    state = PLAYER_STATE.DASH;
    dash_timer = DASH_DURATION;
    dash_dir = facing;
    hsp = dash_dir * DASH_SPEED;
}

if (combo_timer > 0) {
    combo_timer--;
    if (combo_timer <= 0) combo_step = 0;
}

if (technique_timer > 0) {
    technique_timer--;
    if (technique_timer <= 0) technique_state = TECHNIQUE.NONE;
}
if (technique_state == TECHNIQUE.HYOURETSUZAN && grounded) {
    technique_state = TECHNIQUE.NONE;
    camera_shake(4, 10);
}

// Saber animation progression & motion freeze
if (slash_anim_timer > 0) {
    slash_anim_timer--;
    var _anim_len = (combo_step == 3) ? 18.0 : ((state == PLAYER_STATE.DASH) ? 14.0 : 12.0);
    slash_anim_frame += (slash_total_frames / _anim_len);
    if (slash_anim_frame >= slash_total_frames) slash_anim_frame = slash_total_frames - 0.01;
    
    // Ground slash plants Zero firmly on the floor if not dashing
    if (grounded && state != PLAYER_STATE.DASH && !is_dash_slashing) {
        hsp = 0;
    }
    
    // Slashing cancels landing or dash recovery instantly
    is_landing = false;
    is_dash_recovering = false;
} else {
    slash_anim_frame = 0.0;
    is_air_slashing = false;
    is_dash_slashing = false;
    is_wall_slashing = false;
    is_ladder_slashing = false;
}

// -------------------------------------------------------------
// Wall Slide (Frames 1..3) & Wall Jump (Frames 4, 5)
// -------------------------------------------------------------
if (state == PLAYER_STATE.WALL_SLIDE) {
    if (prev_state != PLAYER_STATE.WALL_SLIDE) {
        wall_slide_anim_frame = 1.0;
        jump_frame = 0.0;
        is_landing = false;
        is_dash_recovering = false;
    }
    wall_slide_anim_frame += 0.2;
    if (wall_slide_anim_frame >= 4.0) wall_slide_anim_frame = 1.0;
} else if (state == PLAYER_STATE.WALL_JUMP) {
    if (prev_state != PLAYER_STATE.WALL_JUMP) {
        wall_jump_anim_frame = 0.0;
        jump_frame = 0.0;
        is_landing = false;
        is_dash_recovering = false;
    }
    wall_jump_anim_frame += 0.35;
}

// -------------------------------------------------------------
// Jump, Fall & Landing Animation Control
// -------------------------------------------------------------
var _just_landed = (was_airborne && grounded);
if (_just_landed) {
    if (abs(hsp) <= 0.1 && (state == PLAYER_STATE.IDLE || state == PLAYER_STATE.FALL) && slash_anim_timer <= 0) {
        is_landing = true;
        landing_frame = 8.0;
    }
}

if (state == PLAYER_STATE.JUMP) {
    if (prev_state != PLAYER_STATE.JUMP) {
        jump_frame = 0.0;
        is_landing = false;
        is_dash_recovering = false;
    }
    jump_frame += 0.35;
    if (jump_frame >= 6.0) jump_frame = 6.0;
} else if (state == PLAYER_STATE.FALL) {
    if (prev_state != PLAYER_STATE.FALL && prev_state != PLAYER_STATE.JUMP && prev_state != PLAYER_STATE.WALL_JUMP) {
        jump_frame = 6.0;
        is_landing = false;
        is_dash_recovering = false;
    } else {
        if (jump_frame < 6.0) jump_frame += 0.35;
        if (jump_frame >= 6.0) jump_frame = 6.0;
    }
}

// Progress landing animation on ground
if (is_landing) {
    var _move = global.input.right - global.input.left;
    if (_move != 0 || global.input.jump_pressed || global.input.dash_pressed || global.input.shoot_pressed || !grounded || state != PLAYER_STATE.IDLE) {
        is_landing = false;
    } else {
        landing_frame += 0.25;
        if (landing_frame >= 11.0) {
            is_landing = false;
            landing_frame = 8.0;
        }
    }
}

// -------------------------------------------------------------
// Dash Animation & Recovery Control (6 frames, all with hair)
// -------------------------------------------------------------
if (state == PLAYER_STATE.DASH) {
    if (prev_state != PLAYER_STATE.DASH) {
        dash_anim_frame = 0.0;
        is_dash_recovering = false;
        is_landing = false;
    }
    dash_anim_frame += 0.35;
    if (dash_anim_frame >= 3.0) dash_anim_frame = 3.0;
} else if (prev_state == PLAYER_STATE.DASH && grounded) {
    if (slash_anim_timer <= 0) {
        is_dash_recovering = true;
        dash_recovery_frame = 4.0;
    }
}

if (is_dash_recovering) {
    var _move = global.input.right - global.input.left;
    if (global.input.jump_pressed || global.input.dash_pressed || global.input.shoot_pressed || !grounded || (_move != 0 && _move == -facing) || state == PLAYER_STATE.HURT) {
        is_dash_recovering = false;
    } else {
        dash_recovery_frame += 0.35;
        if (dash_recovery_frame >= 6.0) {
            is_dash_recovering = false;
            dash_recovery_frame = 4.0;
        }
    }
}

// -------------------------------------------------------------
// Ladder Animation & Top Exit Control (Hàng 18: 14 frames)
// -------------------------------------------------------------
if (state == PLAYER_STATE.LADDER) {
    if (prev_state != PLAYER_STATE.LADDER) {
        ladder_anim_frame = 2.0; // Start climbing cycle
        is_ladder_exiting = false;
        ladder_exit_frame = 0.0;
        is_landing = false;
        is_dash_recovering = false;
    }
    
    if (is_ladder_exiting) {
        ladder_exit_frame += 0.20;
        y -= 0.8;
        if (ladder_exit_frame >= 4.0) {
            is_ladder_exiting = false;
            ladder_exit_frame = 0.0;
            state = PLAYER_STATE.IDLE;
            vsp = 0;
            hsp = 0;
            while (place_meeting(x, y, oSolid)) {
                y -= 1;
            }
        }
    } else {
        if (vsp != 0 && slash_anim_timer <= 0) {
            ladder_anim_frame += 0.22;
            if (ladder_anim_frame >= 10.0 || ladder_anim_frame < 2.0) {
                ladder_anim_frame = 2.0;
            }
        }
    }
} else {
    is_ladder_exiting = false;
}

// Track previous state and airborne status
was_airborne = !grounded;
prev_state = state;
