event_inherited();

// Buster Charging
if (global.input.shoot && state != PLAYER_STATE.HURT && state != PLAYER_STATE.DEATH && state != PLAYER_STATE.INTRO && state != PLAYER_STATE.TELEPORT_OUT) {
    charge_timer++;
    if (charge_timer == 15) {
        if (charge_sound == noone && audio_exists(snd_x_charge_loop)) {
            charge_sound = audio_play_sound(snd_x_charge_loop, 70, true);
        }
    }
    if (charge_timer == CHARGE_LV2_FRAMES) {
        if (audio_exists(snd_x_charge_max)) audio_play_sound(snd_x_charge_max, 75, false);
    }
    
    if (charge_timer >= CHARGE_LV2_FRAMES) {
        charge_level = 2;
    } else if (charge_timer >= CHARGE_LV1_FRAMES) {
        charge_level = 1;
    } else {
        charge_level = 0;
    }
    charge_anim_frame = (charge_anim_frame + 0.35) % 13.0;
} else {
    charge_anim_frame = 0.0;
    if (charge_sound != noone) {
        if (audio_is_playing(charge_sound)) audio_stop_sound(charge_sound);
        charge_sound = noone;
    }
}

// Muzzle Flash Animation Advance
if (muzzle_flash_sprite != noone) {
    muzzle_flash_frame += 0.45;
    if (muzzle_flash_frame >= muzzle_flash_max) {
        muzzle_flash_sprite = noone;
        muzzle_flash_frame = 0.0;
    }
}

// Firing
if (global.input.shoot_released || (global.input.shoot_pressed && charge_timer < 5)) {
    var _dx = 31;
    var _dy = -31;
    
    if (is_dash_recovering) {
        _dx = 22;
        _dy = -30;
    } else if (is_landing) {
        _dx = 20;
        _dy = -24;
    } else {
        switch (state) {
            case PLAYER_STATE.IDLE:
                _dx = 31;
                _dy = -31;
                break;
                
            case PLAYER_STATE.RUN:
                var _rf = floor((anim_timer * 0.3) % 16);
                if (_rf >= 6 && _rf <= 11) {
                    _dx = 35;
                } else if (_rf >= 12 && _rf <= 13) {
                    _dx = 31;
                } else if (_rf >= 14 || _rf <= 1) {
                    _dx = 28;
                } else {
                    _dx = 27;
                }
                _dy = -31;
                break;
                
            case PLAYER_STATE.JUMP:
            case PLAYER_STATE.FALL:
            case PLAYER_STATE.WALL_JUMP:
                _dx = 17;
                _dy = -40;
                break;
                
            case PLAYER_STATE.DASH:
                _dx = 32;
                _dy = -17;
                break;
                
            case PLAYER_STATE.WALL_SLIDE:
                _dx = 32;
                _dy = -39;
                break;
                
            case PLAYER_STATE.LADDER:
                _dx = 28;
                _dy = -40;
                break;
        }
    }
    
    var _bx = x + (facing * _dx);
    var _by = y + _dy;
    
    if (charge_sound != noone) {
        if (audio_is_playing(charge_sound)) audio_stop_sound(charge_sound);
        charge_sound = noone;
    }
    
    if (charge_level == 2) {
        var _b = instance_create_layer(_bx + (facing * 16), _by, "Instances", oBullet_FullCharge);
        _b.hspeed = facing * 9;
        _b.image_xscale = facing;
        camera_shake(2, 6);
        if (audio_exists(snd_x_buster_lv3)) audio_play_sound(snd_x_buster_lv3, 90, false);
        if (audio_exists(snd_x_voice_charged)) audio_play_sound(snd_x_voice_charged, 85, false);
        
        muzzle_flash_sprite = sFX_BusterMuzzle_Lv3;
        muzzle_flash_frame = 0.0;
        muzzle_flash_max = 3;
    } else if (charge_level == 1) {
        var _b = instance_create_layer(_bx + (facing * 10), _by, "Instances", oBullet_SemiCharge);
        _b.hspeed = facing * 8;
        _b.image_xscale = facing;
        if (audio_exists(snd_x_buster_lv2)) audio_play_sound(snd_x_buster_lv2, 85, false);
        
        muzzle_flash_sprite = sFX_BusterMuzzle_Lv2;
        muzzle_flash_frame = 0.0;
        muzzle_flash_max = 4;
    } else {
        if (instance_number(oBullet_Buster) < 3) {
            var _b = instance_create_layer(_bx + (facing * 6), _by, "Instances", oBullet_Buster);
            _b.hspeed = facing * 7;
            _b.image_xscale = facing;
            if (audio_exists(snd_x_buster_lv1)) audio_play_sound(snd_x_buster_lv1, 80, false);
            
            muzzle_flash_sprite = sFX_BusterMuzzle_Lv1;
            muzzle_flash_frame = 0.0;
            muzzle_flash_max = 4;
        }
    }
    
    charge_timer = 0;
    charge_level = 0;
    shoot_anim_timer = 14;
}

if (shoot_anim_timer > 0) shoot_anim_timer--;

// -------------------------------------------------------------
// Jump, Hover/Fall & Landing Animation State Control
// -------------------------------------------------------------
var _just_landed = (was_airborne && grounded);
if (_just_landed) {
    if (audio_exists(snd_player_land)) audio_play_sound(snd_player_land, 65, false);
    if (abs(hsp) <= 0.1 && (state == PLAYER_STATE.IDLE || state == PLAYER_STATE.FALL)) {
        is_landing = true;
        landing_frame = 8.0; // Frame 9 in 1-based indexing
    }
}

if (state == PLAYER_STATE.JUMP) {
    if (prev_state != PLAYER_STATE.JUMP) {
        jump_frame = 0.0;
        is_landing = false;
        is_dash_recovering = false;
    }
    jump_frame += 0.35;
    // Freeze/hold on frame 7 (1-indexed frame 8) when in air
    if (jump_frame >= 7.0) jump_frame = 7.0;
} else if (state == PLAYER_STATE.FALL) {
    if (prev_state != PLAYER_STATE.FALL && prev_state != PLAYER_STATE.JUMP && prev_state != PLAYER_STATE.WALL_JUMP) {
        // Walked off a ledge: instantly assume the airborne falling pose (frame 8)
        jump_frame = 7.0;
        is_landing = false;
        is_dash_recovering = false;
    } else {
        if (jump_frame < 7.0) jump_frame += 0.35;
        // Freeze/hold on frame 7 (1-indexed frame 8) while airborne
        if (jump_frame >= 7.0) jump_frame = 7.0;
    }
}

// Progress landing animation on ground
if (is_landing) {
    var _move = global.input.right - global.input.left;
    if (_move != 0 || global.input.jump_pressed || global.input.dash_pressed || !grounded || state != PLAYER_STATE.IDLE) {
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
// Dash Animation & Recovery Control (Row 9, 8 frames)
// -------------------------------------------------------------
if (state == PLAYER_STATE.DASH) {
    if (prev_state != PLAYER_STATE.DASH) {
        dash_anim_frame = 0.0;
        is_dash_recovering = false;
        is_landing = false;
    }
    dash_anim_frame += 0.35;
    // Hold/lock at frame index 3 (1-indexed frame 4: full extension with speed streaks) while dashing
    if (dash_anim_frame >= 3.0) dash_anim_frame = 3.0;
} else if (prev_state == PLAYER_STATE.DASH && grounded) {
    // When dash completes on ground, start deceleration/recovery through remaining frames (5..8)
    is_dash_recovering = true;
    dash_recovery_frame = 4.0; // Index 4 is 1-indexed Frame 5
}

if (is_dash_recovering) {
    var _move = global.input.right - global.input.left;
    if (global.input.jump_pressed || global.input.dash_pressed || !grounded || (_move != 0 && _move == -facing) || state == PLAYER_STATE.HURT) {
        is_dash_recovering = false;
    } else {
        dash_recovery_frame += 0.35;
        if (dash_recovery_frame >= 8.0) {
            is_dash_recovering = false;
            dash_recovery_frame = 4.0;
        }
    }
}

// -------------------------------------------------------------
// Wall Slide (Frames 2, 3, 4) & Wall Jump (Frames 1, 5, 6)
// -------------------------------------------------------------
if (state == PLAYER_STATE.WALL_SLIDE) {
    if (prev_state != PLAYER_STATE.WALL_SLIDE) {
        wall_slide_anim_frame = 1.0; // Start at index 1 (1-indexed Frame 2)
        is_landing = false;
        is_dash_recovering = false;
    } else {
        wall_slide_anim_frame += 0.20;
        // Loop sliding frames 2, 3, 4 (indexes 1, 2, 3)
        if (wall_slide_anim_frame >= 4.0) {
            wall_slide_anim_frame = 1.0 + ((wall_slide_anim_frame - 1.0) % 3.0);
        }
    }
} else if (state == PLAYER_STATE.WALL_JUMP) {
    if (prev_state != PLAYER_STATE.WALL_JUMP) {
        wall_jump_anim_frame = 0.0;
        jump_frame = 4.0;
        is_landing = false;
        is_dash_recovering = false;
    }
    wall_jump_anim_frame += 0.35;
    // When wall leap animation completes its 3-phase thrust (frames 1, 5, 6), progress jump frame
    if (wall_jump_anim_frame >= 3.0) {
        jump_frame += 0.35;
        if (jump_frame >= 7.0) jump_frame = 7.0;
    }
}

// -------------------------------------------------------------
// Ladder Animation State Control (Row 20, 15 frames)
// -------------------------------------------------------------
if (state == PLAYER_STATE.LADDER) {
    if (prev_state != PLAYER_STATE.LADDER) {
        ladder_anim_frame = 0.0; // Frame 1: cling / start ladder
        is_ladder_exiting = false;
        ladder_exit_frame = 0.0;
        is_landing = false;
        is_dash_recovering = false;
    }
    
    if (is_ladder_exiting) {
        ladder_exit_frame += 0.20;
        y -= 0.8;
        if (ladder_exit_frame >= 3.0) {
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
        if (vsp != 0) {
            ladder_anim_frame += 0.22;
            // Loop climbing cycle frames 1..8 (1-indexed frames 2..9)
            if (ladder_anim_frame >= 9.0 || ladder_anim_frame < 1.0) {
                ladder_anim_frame = 1.0;
            }
        }
    }
} else {
    is_ladder_exiting = false;
}

// Track previous frame states
was_airborne = !grounded;
prev_state = state;


