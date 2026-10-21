// Input suppression / movement lock during techniques
var _orig_left = global.input.left;
var _orig_right = global.input.right;
var _orig_up = global.input.up;
var _orig_down = global.input.down;
var _orig_jump = global.input.jump_pressed;
var _orig_dash = global.input.dash_pressed;
var _orig_shoot = global.input.shoot_pressed;
var _orig_special = global.input.special_pressed;

if (technique_state == TECHNIQUE.RAIJINGEKI) {
    global.input.left = 0;
    global.input.right = 0;
    global.input.jump_pressed = 0;
    global.input.dash_pressed = 0;
    global.input.shoot_pressed = 0;
    global.input.special_pressed = 0;
    hsp = 0;
} else if (technique_state == TECHNIQUE.RYUENJIN) {
    global.input.left = 0;
    global.input.right = 0;
    global.input.jump_pressed = 0;
    global.input.dash_pressed = 0;
    global.input.shoot_pressed = 0;
    global.input.special_pressed = 0;
} else if (technique_state == TECHNIQUE.HYOURETSUZAN) {
    global.input.left = 0;
    global.input.right = 0;
    global.input.jump_pressed = 0;
    global.input.dash_pressed = 0;
    global.input.shoot_pressed = 0;
    global.input.special_pressed = 0;
    hsp = 0;
}

event_inherited();

// Restore inputs
global.input.left = _orig_left;
global.input.right = _orig_right;
global.input.up = _orig_up;
global.input.down = _orig_down;
global.input.jump_pressed = _orig_jump;
global.input.dash_pressed = _orig_dash;
global.input.shoot_pressed = _orig_shoot;
global.input.special_pressed = _orig_special;

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
    technique_frame = 0.0;
    technique_phase = 0;
    if (instance_exists(current_saber_hitbox)) {
        instance_destroy(current_saber_hitbox);
        current_saber_hitbox = noone;
    }
}

// Techniques input (Special button)
if (global.input.special_pressed && technique_state == TECHNIQUE.NONE && slash_anim_timer <= 0 && state != PLAYER_STATE.HURT && state != PLAYER_STATE.DEATH && state != PLAYER_STATE.INTRO && state != PLAYER_STATE.TELEPORT_OUT) {
    if (instance_exists(current_saber_hitbox)) {
        instance_destroy(current_saber_hitbox);
        current_saber_hitbox = noone;
    }
    if (grounded && global.input.up) {
        // Ryuenjin: Flaming dragon uppercut
        technique_state = TECHNIQUE.RYUENJIN;
        technique_frame = 0.0;
        technique_timer = 36;
        hsp = 0;
        vsp = 0;
        if (audio_exists(snd_zero_ryuenjin)) audio_play_sound(snd_zero_ryuenjin, 90, false);
        if (audio_exists(snd_zero_voice_ryuenjin)) audio_play_sound(snd_zero_voice_ryuenjin, 85, false);
        var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
        _h.owner = id;
        _h.slash_type = "ryuenjin";
        _h.damage = 6.0;
        _h.element = "fire";
        current_saber_hitbox = _h;
        camera_shake(3, 8);
    } else if (!grounded && global.input.down) {
        // Hyouretsuzan: Giant ice plunge dive
        technique_state = TECHNIQUE.HYOURETSUZAN;
        technique_phase = 0;
        technique_frame = 0.0;
        technique_timer = 120;
        hsp = 0;
        vsp = 8.5;
        if (audio_exists(snd_zero_hyouretsuzan)) audio_play_sound(snd_zero_hyouretsuzan, 85, false);
        if (audio_exists(snd_zero_voice_hyouretsuzan)) audio_play_sound(snd_zero_voice_hyouretsuzan, 85, false);
        var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
        _h.owner = id;
        _h.slash_type = "hyouretsuzan";
        _h.damage = 5.0;
        _h.element = "ice";
        current_saber_hitbox = _h;
    } else if (!grounded) {
        // Kuuenbu: 360-degree somersault spin slash
        technique_state = TECHNIQUE.KUUENZAN;
        technique_frame = 0.0;
        technique_timer = 24;
        if (audio_exists(snd_zero_kuuenbu)) audio_play_sound(snd_zero_kuuenbu, 85, false);
        var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
        _h.owner = id;
        _h.slash_type = "kuuenzan";
        _h.damage = 3.5;
        _h.element = "slash";
        current_saber_hitbox = _h;
    } else {
        // Raijingeki: Lightning thrust
        technique_state = TECHNIQUE.RAIJINGEKI;
        technique_frame = 0.0;
        technique_timer = 50;
        hsp = 0;
        vsp = 0;
        if (audio_exists(snd_zero_raijingeki)) audio_play_sound(snd_zero_raijingeki, 85, false);
        if (audio_exists(snd_zero_voice_raijingeki)) audio_play_sound(snd_zero_voice_raijingeki, 90, false);
        var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
        _h.owner = id;
        _h.slash_type = "raijingeki";
        _h.damage = 2.0;
        _h.element = "electric";
        current_saber_hitbox = _h;
    }
}

// Saber Combos & Techniques (Attack button)
if (global.input.shoot_pressed && technique_state == TECHNIQUE.NONE && state != PLAYER_STATE.HURT && state != PLAYER_STATE.DEATH && state != PLAYER_STATE.INTRO && state != PLAYER_STATE.TELEPORT_OUT) {
    if (instance_exists(current_saber_hitbox)) {
        instance_destroy(current_saber_hitbox);
        current_saber_hitbox = noone;
    }
    if (state == PLAYER_STATE.WALL_SLIDE) {
        slash_anim_timer = 14;
        slash_anim_frame = 0.0;
        slash_total_frames = 9;
        is_wall_slashing = true;
        is_ladder_slashing = false;
        is_air_slashing = false;
        is_dash_slashing = false;
        if (audio_exists(snd_zero_saber_1)) audio_play_sound(snd_zero_saber_1, 80, false);
        var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
        _h.owner = id;
        _h.slash_type = "wall_slash";
        _h.damage = 3.0;
        current_saber_hitbox = _h;
    } else if (state == PLAYER_STATE.LADDER) {
        slash_anim_timer = 14;
        slash_anim_frame = 0.0;
        slash_total_frames = 9;
        is_ladder_slashing = true;
        is_wall_slashing = false;
        is_air_slashing = false;
        is_dash_slashing = false;
        if (audio_exists(snd_zero_saber_1)) audio_play_sound(snd_zero_saber_1, 80, false);
        var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
        _h.owner = id;
        _h.slash_type = "ladder_slash";
        _h.damage = 3.0;
        current_saber_hitbox = _h;
    } else if (!grounded) {
        if (global.input.down) {
            // Down + Attack in air -> Hyouretsuzan: Giant ice plunge dive
            technique_state = TECHNIQUE.HYOURETSUZAN;
            technique_phase = 0;
            technique_frame = 0.0;
            technique_timer = 120;
            hsp = 0;
            vsp = 8.5;
            if (audio_exists(snd_zero_hyouretsuzan)) audio_play_sound(snd_zero_hyouretsuzan, 85, false);
            if (audio_exists(snd_zero_voice_hyouretsuzan)) audio_play_sound(snd_zero_voice_hyouretsuzan, 85, false);
            var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
            _h.owner = id;
            _h.slash_type = "hyouretsuzan";
            _h.damage = 5.0;
            _h.element = "ice";
            current_saber_hitbox = _h;
        } else {
            // Neutral / Direction + Attack in air -> Kuuenbu: 360-degree somersault spin slash
            technique_state = TECHNIQUE.KUUENZAN;
            technique_frame = 0.0;
            technique_timer = 24;
            if (audio_exists(snd_zero_kuuenbu)) audio_play_sound(snd_zero_kuuenbu, 85, false);
            var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
            _h.owner = id;
            _h.slash_type = "kuuenzan";
            _h.damage = 3.5;
            _h.element = "slash";
            current_saber_hitbox = _h;
        }
    } else if (state == PLAYER_STATE.DASH) {
        slash_anim_timer = 14;
        slash_anim_frame = 0.0;
        slash_total_frames = 9;
        is_dash_slashing = true;
        is_air_slashing = false;
        is_wall_slashing = false;
        is_ladder_slashing = false;
        if (audio_exists(snd_zero_shippuuga)) audio_play_sound(snd_zero_shippuuga, 85, false);
        if (audio_exists(snd_zero_voice_shippuuga)) audio_play_sound(snd_zero_voice_shippuuga, 85, false);
        var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
        _h.owner = id;
        _h.slash_type = "dash_slash";
        _h.damage = 3.0;
        current_saber_hitbox = _h;
    } else {
        if (global.input.up) {
            // Up + Attack on ground -> Ryuenjin: Flaming dragon uppercut
            technique_state = TECHNIQUE.RYUENJIN;
            technique_frame = 0.0;
            technique_timer = 36;
            hsp = 0;
            vsp = 0;
            if (audio_exists(snd_zero_ryuenjin)) audio_play_sound(snd_zero_ryuenjin, 90, false);
            if (audio_exists(snd_zero_voice_ryuenjin)) audio_play_sound(snd_zero_voice_ryuenjin, 85, false);
            var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
            _h.owner = id;
            _h.slash_type = "ryuenjin";
            _h.damage = 6.0;
            _h.element = "fire";
            current_saber_hitbox = _h;
            camera_shake(3, 8);
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
                if (audio_exists(snd_zero_saber_1)) audio_play_sound(snd_zero_saber_1, 80, false);
                if (audio_exists(snd_zero_voice_slash1)) audio_play_sound(snd_zero_voice_slash1, 75, false);
                var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
                _h.owner = id;
                _h.slash_type = "slash1";
                _h.damage = 2.0;
                current_saber_hitbox = _h;
            } else if (combo_step == 1) {
                combo_step = 2;
                combo_timer = COMBO_RESET_FRAMES;
                slash_anim_timer = 12;
                slash_anim_frame = 0.0;
                slash_total_frames = 10;
                hsp = 0;
                if (audio_exists(snd_zero_saber_2)) audio_play_sound(snd_zero_saber_2, 85, false);
                if (audio_exists(snd_zero_voice_slash2)) audio_play_sound(snd_zero_voice_slash2, 75, false);
                var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
                _h.owner = id;
                _h.slash_type = "slash2";
                _h.damage = 2.0;
                current_saber_hitbox = _h;
            } else if (combo_step == 2) {
                combo_step = 3;
                combo_timer = 28;
                slash_anim_timer = 18;
                slash_anim_frame = 0.0;
                slash_total_frames = 14;
                hsp = 0;
                if (audio_exists(snd_zero_saber_3)) audio_play_sound(snd_zero_saber_3, 90, false);
                if (audio_exists(snd_zero_voice_slash3)) audio_play_sound(snd_zero_voice_slash3, 85, false);
                var _h = instance_create_layer(x, y, "Instances", oSaberHitbox);
                _h.owner = id;
                _h.slash_type = "slash3";
                _h.damage = 4.0;
                current_saber_hitbox = _h;
                camera_shake(3, 8);
            }
        }
    }
}

// Saber Dash Cancel (SDC)
if (combo_step == 1 && global.input.dash_pressed) {
    combo_step = 0;
    combo_timer = 0;
    slash_anim_timer = 0;
    slash_anim_frame = 0.0;
    if (instance_exists(current_saber_hitbox)) {
        instance_destroy(current_saber_hitbox);
        current_saber_hitbox = noone;
    }
    state = PLAYER_STATE.DASH;
    dash_timer = DASH_DURATION;
    dash_dir = facing;
    hsp = dash_dir * DASH_SPEED;
}

if (combo_timer > 0) {
    combo_timer--;
    if (combo_timer <= 0) combo_step = 0;
}

// -------------------------------------------------------------
// Technique Updates
// -------------------------------------------------------------
if (technique_state != TECHNIQUE.NONE) {
    if (technique_timer > 0) technique_timer--;
    
    switch (technique_state) {
        case TECHNIQUE.RAIJINGEKI:
            hsp = 0;
            state = PLAYER_STATE.IDLE;
            if (technique_frame < 12.0) {
                technique_frame += 0.55;
            } else if (technique_frame < 20.0) {
                technique_frame += 0.40;
                if (floor(technique_frame) % 2 == 0) camera_shake(1, 2);
            } else {
                technique_frame += 0.40;
            }
            if (technique_frame >= 24.0 || technique_timer <= 0) {
                technique_state = TECHNIQUE.NONE;
                technique_frame = 0.0;
                if (instance_exists(current_saber_hitbox)) {
                    instance_destroy(current_saber_hitbox);
                    current_saber_hitbox = noone;
                }
            }
            break;

        case TECHNIQUE.RYUENJIN:
            if (technique_frame < 2.0) {
                hsp = 0;
                vsp = 0;
                technique_frame += 0.40;
                if (technique_frame >= 2.0) {
                    vsp = -7.5;
                    hsp = facing * 1.5;
                    state = PLAYER_STATE.JUMP;
                    camera_shake(3, 8);
                }
            } else if (technique_frame < 8.0) {
                technique_frame += 0.35;
                state = PLAYER_STATE.JUMP;
            } else if (technique_frame < 14.0) {
                technique_frame += 0.35;
                if (vsp < 0) vsp += 0.15;
            } else {
                technique_frame += 0.35;
            }
            if (technique_frame >= 16.0 || technique_timer <= 0) {
                technique_state = TECHNIQUE.NONE;
                technique_frame = 0.0;
                state = PLAYER_STATE.FALL;
                if (instance_exists(current_saber_hitbox)) {
                    instance_destroy(current_saber_hitbox);
                    current_saber_hitbox = noone;
                }
            }
            break;

        case TECHNIQUE.HYOURETSUZAN:
            if (technique_phase == 0) {
                // In air: plunge dive
                if (technique_frame < 2.0) {
                    technique_frame += 0.35;
                    hsp = 0;
                    vsp = min(vsp, 1.0);
                } else {
                    hsp = 0;
                    vsp = 8.5;
                    technique_frame = 2.0 + ((anim_timer div 4) % 2);
                }
                
                // Ground collision triggers impact
                if (grounded) {
                    technique_phase = 1;
                    technique_frame = 4.0;
                    technique_timer = 25;
                    vsp = 0;
                    hsp = 0;
                    state = PLAYER_STATE.IDLE;
                    camera_shake(4, 10);
                    if (instance_exists(current_saber_hitbox)) {
                        ds_list_clear(current_saber_hitbox.hit_list);
                    }
                }
            } else {
                // On ground: impact shockwave and recovery (frames 4..8)
                hsp = 0;
                vsp = 0;
                state = PLAYER_STATE.IDLE;
                technique_frame += 0.30;
                if (technique_frame >= 9.0 || technique_timer <= 0) {
                    technique_state = TECHNIQUE.NONE;
                    technique_phase = 0;
                    technique_frame = 0.0;
                    if (instance_exists(current_saber_hitbox)) {
                        instance_destroy(current_saber_hitbox);
                        current_saber_hitbox = noone;
                    }
                }
            }
            break;

        case TECHNIQUE.KUUENZAN:
            technique_frame += 0.35;
            // Air dash cancel allowed
            var _can_air_dash = (has_air_dash || (variable_global_exists("has_air_dash") && global.has_air_dash));
            if (!grounded && _can_air_dash && !air_dash_used && !in_web && global.input.dash_pressed) {
                technique_state = TECHNIQUE.NONE;
                technique_frame = 0.0;
                if (instance_exists(current_saber_hitbox)) {
                    instance_destroy(current_saber_hitbox);
                    current_saber_hitbox = noone;
                }
                state = PLAYER_STATE.DASH;
                dash_timer = AIR_DASH_DURATION;
                air_dash_used = true;
                var _move = global.input.right - global.input.left;
                dash_dir = (_move != 0) ? _move : facing;
                facing = dash_dir;
                hsp = dash_dir * DASH_SPEED;
                vsp = 0;
            } else if (grounded) {
                if (abs(hsp) > 0.5) hsp = lerp(hsp, 0, 0.2);
            }
            if (technique_frame >= 8.0 || technique_timer <= 0) {
                technique_state = TECHNIQUE.NONE;
                technique_frame = 0.0;
                if (instance_exists(current_saber_hitbox)) {
                    instance_destroy(current_saber_hitbox);
                    current_saber_hitbox = noone;
                }
            }
            break;
    }
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
    if (technique_state == TECHNIQUE.NONE && instance_exists(current_saber_hitbox)) {
        instance_destroy(current_saber_hitbox);
        current_saber_hitbox = noone;
    }
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
    if (audio_exists(snd_player_land)) audio_play_sound(snd_player_land, 65, false);
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
