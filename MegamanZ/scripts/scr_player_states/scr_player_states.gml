/// @desc Player State Machine Implementations

function player_state_execute() {
    switch (state) {
        case PLAYER_STATE.IDLE:
            player_state_idle();
            break;
            
        case PLAYER_STATE.RUN:
            player_state_run();
            break;
            
        case PLAYER_STATE.JUMP:
            player_state_jump();
            break;
            
        case PLAYER_STATE.FALL:
            player_state_fall();
            break;
            
        case PLAYER_STATE.DASH:
            player_state_dash();
            break;
            
        case PLAYER_STATE.WALL_SLIDE:
            player_state_wall_slide();
            break;
            
        case PLAYER_STATE.WALL_JUMP:
            player_state_wall_jump();
            break;
            
        case PLAYER_STATE.LADDER:
            player_state_ladder();
            break;
            
        case PLAYER_STATE.HURT:
            player_state_hurt();
            break;
            
        case PLAYER_STATE.DEATH:
            player_state_death();
            break;
            
        case PLAYER_STATE.INTRO:
            player_state_intro();
            break;
            
        case PLAYER_STATE.TELEPORT_OUT:
            player_state_teleport_out();
            break;
    }
}

// -------------------------------------------------------------------------
// IDLE STATE
// -------------------------------------------------------------------------
function player_state_idle() {
    // If auto-walking through boss gate, maintain run state
    if (variable_instance_exists(id, "is_auto_walking") && is_auto_walking) {
        state = PLAYER_STATE.RUN;
        facing = 1;
        return;
    }
    
    // Ice sliding friction
    if (on_ice) {
        hsp = lerp(hsp, 0, 0.08);
        if (abs(hsp) < 0.1) hsp = 0;
    } else {
        hsp = 0;
    }
    
    // Leaving ground
    if (!grounded) {
        state = PLAYER_STATE.FALL;
        return;
    }
    
    // Drop down through OneWay platform
    if (global.input.down && global.input.jump_pressed) {
        drop_through_timer = 14;
        vsp = 1.0;
        state = PLAYER_STATE.FALL;
        return;
    }
    
    // Check ladder grab
    if ((global.input.up || global.input.down) && place_meeting(x, y, oLadder)) {
        var _lad = instance_place(x, y, oLadder);
        if (_lad != noone) x = (_lad.bbox_left + _lad.bbox_right + 1) / 2;
        state = PLAYER_STATE.LADDER;
        return;
    }
    if (global.input.down && place_meeting(x, y + 4, oLadder)) {
        var _lad = instance_place(x, y + 4, oLadder);
        if (_lad != noone) x = (_lad.bbox_left + _lad.bbox_right + 1) / 2;
        y += 4;
        state = PLAYER_STATE.LADDER;
        return;
    }
    
    // Check Jump (buffered)
    if (global.input.jump_buffer > 0) {
        global.input.jump_buffer = 0;
        vsp = in_water ? WATER_JUMP_VELOCITY : JUMP_VELOCITY;
        state = PLAYER_STATE.JUMP;
        if (audio_exists(snd_player_jump)) audio_play_sound(snd_player_jump, 70, false);
        var _move = global.input.right - global.input.left;
        if ((global.input.dash || global.input.dash_buffer > 0) && !in_web) {
            is_dash_jumping = true;
            if (_move != 0) facing = _move;
            hsp = facing * DASH_JUMP_SPEED;
            if (object_exists(oFX_DashDust)) {
                instance_create_layer(x - (facing * 12), bbox_bottom, "Instances", oFX_DashDust);
            }
        } else {
            is_dash_jumping = false;
            if (_move != 0) {
                facing = _move;
                hsp = _move * RUN_SPEED;
            } else {
                hsp = 0;
            }
        }
        return;
    }
    
    // Check Dash (buffered)
    if (global.input.dash_buffer > 0 && !in_web) {
        global.input.dash_buffer = 0;
        dash_timer = DASH_DURATION;
        dash_dir = facing;
        hsp = dash_dir * DASH_SPEED;
        state = PLAYER_STATE.DASH;
        if (audio_exists(snd_player_dash)) audio_play_sound(snd_player_dash, 75, false);
        if (object_exists(oFX_DashDust)) {
            instance_create_layer(x - (facing * 12), bbox_bottom, "Instances", oFX_DashDust);
        }
        return;
    }
    
    // Check Run
    var _move = global.input.right - global.input.left;
    if (_move != 0) {
        facing = _move;
        var _spd = RUN_SPEED;
        if (in_web) _spd *= 0.5;
        if (in_water) _spd *= 0.8;
        hsp = _move * _spd;
        state = PLAYER_STATE.RUN;
        return;
    }
}

// -------------------------------------------------------------------------
// RUN STATE
// -------------------------------------------------------------------------
function player_state_run() {
    // If auto-walking through boss gate, maintain run state
    if (variable_instance_exists(id, "is_auto_walking") && is_auto_walking) {
        facing = 1;
        return;
    }
    
    var _move = global.input.right - global.input.left;
    
    // Drop off ledge
    if (!grounded) {
        coyote_timer = COYOTE_FRAMES;
        state = PLAYER_STATE.FALL;
        return;
    }
    
    // Drop through OneWay platform
    if (global.input.down && global.input.jump_pressed) {
        drop_through_timer = 14;
        vsp = 1.0;
        state = PLAYER_STATE.FALL;
        return;
    }
    
    // Check ladder grab
    if ((global.input.up || global.input.down) && place_meeting(x, y, oLadder)) {
        var _lad = instance_place(x, y, oLadder);
        if (_lad != noone) x = (_lad.bbox_left + _lad.bbox_right + 1) / 2;
        state = PLAYER_STATE.LADDER;
        return;
    }
    
    // Check Jump
    if (global.input.jump_buffer > 0) {
        global.input.jump_buffer = 0;
        vsp = in_water ? WATER_JUMP_VELOCITY : JUMP_VELOCITY;
        state = PLAYER_STATE.JUMP;
        if (audio_exists(snd_player_jump)) audio_play_sound(snd_player_jump, 70, false);
        if ((global.input.dash || global.input.dash_buffer > 0) && !in_web) {
            is_dash_jumping = true;
            hsp = facing * DASH_JUMP_SPEED;
            if (object_exists(oFX_DashDust)) {
                instance_create_layer(x - (facing * 12), bbox_bottom, "Instances", oFX_DashDust);
            }
        } else {
            is_dash_jumping = false;
        }
        return;
    }
    
    // Check Dash
    if (global.input.dash_buffer > 0 && !in_web) {
        global.input.dash_buffer = 0;
        dash_timer = DASH_DURATION;
        dash_dir = facing;
        hsp = dash_dir * DASH_SPEED;
        state = PLAYER_STATE.DASH;
        if (audio_exists(snd_player_dash)) audio_play_sound(snd_player_dash, 75, false);
        if (object_exists(oFX_DashDust)) {
            instance_create_layer(x - (facing * 12), bbox_bottom, "Instances", oFX_DashDust);
        }
        return;
    }
    
    // Movement update
    var _spd = RUN_SPEED;
    if (in_web) _spd *= 0.5;
    if (in_water) _spd *= 0.8;
    
    if (_move != 0) {
        facing = _move;
        if (on_ice) {
            hsp = lerp(hsp, _move * _spd, 0.1);
        } else {
            hsp = _move * _spd;
        }
    } else {
        if (on_ice) {
            hsp = lerp(hsp, 0, 0.08);
            if (abs(hsp) < 0.1) {
                hsp = 0;
                state = PLAYER_STATE.IDLE;
            }
        } else {
            hsp = 0;
            state = PLAYER_STATE.IDLE;
        }
    }
}

// -------------------------------------------------------------------------
// JUMP STATE
// -------------------------------------------------------------------------
function player_state_jump() {
    // Air Dash capability!
    var _can_air_dash = (has_air_dash || (variable_global_exists("has_air_dash") && global.has_air_dash));
    if (global.input.dash_pressed && _can_air_dash && !air_dash_used && !in_web) {
        air_dash_used = true;
        if (audio_exists(snd_player_air_dash)) audio_play_sound(snd_player_air_dash, 75, false);
        var _move = global.input.right - global.input.left;
        if (_move != 0) facing = _move;
        dash_timer = AIR_DASH_DURATION;
        dash_dir = facing;
        hsp = dash_dir * DASH_SPEED;
        vsp = 0;
        is_dash_jumping = true;
        state = PLAYER_STATE.DASH;
        if (audio_exists(snd_player_dash)) audio_play_sound(snd_player_dash, 75, false);
        if (object_exists(oFX_DashDust)) {
            instance_create_layer(x - (facing * 12), y, "Instances", oFX_DashDust);
        }
        return;
    }
    
    // Double Jump capability!
    var _can_double_jump = (has_double_jump || (variable_global_exists("has_double_jump") && global.has_double_jump));
    if (global.input.jump_pressed && _can_double_jump && !double_jump_used && !in_web) {
        double_jump_used = true;
        vsp = in_water ? WATER_JUMP_VELOCITY : JUMP_VELOCITY;
        var _move = global.input.right - global.input.left;
        if (_move != 0) facing = _move;
        var _dash_active = (is_dash_jumping || (global.input.dash && !in_web));
        if (_dash_active) {
            is_dash_jumping = true;
            hsp = facing * DASH_JUMP_SPEED;
        }
        if (variable_instance_exists(id, "jump_frame")) jump_frame = 0.0;
        if (object_exists(oFX_DashDust)) {
            instance_create_layer(x, bbox_bottom, "Instances", oFX_DashDust);
        }
        return;
    }
    
    // Variable jump height
    if (global.input.jump_released && vsp < -1.5) {
        vsp = -1.5;
    }
    
    // Apply gravity
    var _grav = in_water ? WATER_GRAVITY : GRAVITY;
    var _max_fall = in_water ? MAX_WATER_FALL_SPEED : MAX_FALL_SPEED;
    vsp = min(vsp + _grav, _max_fall);
    
    // Air steering
    if (wall_jump_timer > 0) {
        wall_jump_timer--;
    } else {
        var _move = global.input.right - global.input.left;
        var _dash_active = (is_dash_jumping || (global.input.dash && !in_web));
        var _spd = _dash_active ? DASH_JUMP_SPEED : RUN_SPEED;
        if (in_water) _spd *= 0.8;
        
        if (_move != 0) {
            facing = _move;
            hsp = _move * _spd;
            if (_dash_active) is_dash_jumping = true;
        } else {
            if (!_dash_active) {
                hsp = 0;
            }
        }
    }
    
    // Transition to Fall when apex reached
    if (vsp >= 0) {
        state = PLAYER_STATE.FALL;
        return;
    }
    
    // Grab ladder in mid-air
    if (global.input.up && place_meeting(x, y, oLadder)) {
        var _lad = instance_place(x, y, oLadder);
        if (_lad != noone) x = (_lad.bbox_left + _lad.bbox_right + 1) / 2;
        is_dash_jumping = false;
        state = PLAYER_STATE.LADDER;
        return;
    }
}

// -------------------------------------------------------------------------
// FALL STATE
// -------------------------------------------------------------------------
function player_state_fall() {
    // Bottomless pit death
    if (y > room_height + 16 && state != PLAYER_STATE.DEATH) {
        player_trigger_death(id);
        return;
    }
    // Air Dash capability!
    var _can_air_dash = (has_air_dash || (variable_global_exists("has_air_dash") && global.has_air_dash));
    if (global.input.dash_pressed && _can_air_dash && !air_dash_used && !in_web) {
        air_dash_used = true;
        if (audio_exists(snd_player_air_dash)) audio_play_sound(snd_player_air_dash, 75, false);
        var _move = global.input.right - global.input.left;
        if (_move != 0) facing = _move;
        dash_timer = AIR_DASH_DURATION;
        dash_dir = facing;
        hsp = dash_dir * DASH_SPEED;
        vsp = 0;
        is_dash_jumping = true;
        state = PLAYER_STATE.DASH;
        if (audio_exists(snd_player_dash)) audio_play_sound(snd_player_dash, 75, false);
        if (object_exists(oFX_DashDust)) {
            instance_create_layer(x - (facing * 12), y, "Instances", oFX_DashDust);
        }
        return;
    }
    
    // Coyote jump check
    if (coyote_timer > 0) {
        coyote_timer--;
        if (global.input.jump_buffer > 0) {
            global.input.jump_buffer = 0;
            vsp = in_water ? WATER_JUMP_VELOCITY : JUMP_VELOCITY;
            if ((global.input.dash || global.input.dash_buffer > 0) && !in_web) {
                is_dash_jumping = true;
                hsp = facing * DASH_JUMP_SPEED;
            }
            state = PLAYER_STATE.JUMP;
            return;
        }
    }
    
    // Double Jump capability!
    var _can_double_jump = (has_double_jump || (variable_global_exists("has_double_jump") && global.has_double_jump));
    if (global.input.jump_pressed && _can_double_jump && !double_jump_used && !in_web) {
        double_jump_used = true;
        vsp = in_water ? WATER_JUMP_VELOCITY : JUMP_VELOCITY;
        var _move = global.input.right - global.input.left;
        if (_move != 0) facing = _move;
        var _dash_active = (is_dash_jumping || (global.input.dash && !in_web));
        if (_dash_active) {
            is_dash_jumping = true;
            hsp = facing * DASH_JUMP_SPEED;
        }
        if (variable_instance_exists(id, "jump_frame")) jump_frame = 0.0;
        if (object_exists(oFX_DashDust)) {
            instance_create_layer(x, bbox_bottom, "Instances", oFX_DashDust);
        }
        state = PLAYER_STATE.JUMP;
        return;
    }
    
    // Apply gravity
    var _grav = in_water ? WATER_GRAVITY : GRAVITY;
    var _max_fall = in_water ? MAX_WATER_FALL_SPEED : MAX_FALL_SPEED;
    vsp = min(vsp + _grav, _max_fall);
    
    // Air steering
    if (wall_jump_timer > 0) {
        wall_jump_timer--;
    } else {
        var _move = global.input.right - global.input.left;
        var _dash_active = (is_dash_jumping || (global.input.dash && !in_web));
        var _spd = _dash_active ? DASH_JUMP_SPEED : RUN_SPEED;
        if (in_water) _spd *= 0.8;
        
        if (_move != 0) {
            facing = _move;
            hsp = _move * _spd;
            if (_dash_active) is_dash_jumping = true;
        } else {
            if (!_dash_active) {
                hsp = 0;
            }
        }
    }
    
    // Wall Slide Check
    var _move = global.input.right - global.input.left;
    if (touching_wall != 0 && (_move == touching_wall || touching_wall == facing)) {
        if (vsp > 0) {
            is_dash_jumping = false;
            state = PLAYER_STATE.WALL_SLIDE;
            return;
        }
    }
    
    // Grab ladder
    if (global.input.up && place_meeting(x, y, oLadder)) {
        var _lad = instance_place(x, y, oLadder);
        if (_lad != noone) x = (_lad.bbox_left + _lad.bbox_right + 1) / 2;
        is_dash_jumping = false;
        state = PLAYER_STATE.LADDER;
        return;
    }
    
    // Land on ground
    if (grounded) {
        is_dash_jumping = false;
        vsp = 0;
        if (abs(hsp) > 0.1) {
            state = PLAYER_STATE.RUN;
        } else {
            state = PLAYER_STATE.IDLE;
        }
        return;
    }
}

// -------------------------------------------------------------------------
// DASH STATE
// -------------------------------------------------------------------------
function player_state_dash() {
    hsp = dash_dir * DASH_SPEED;
    dash_timer--;
    
    // Fall off ledge during ground dash
    if (!grounded) {
        is_dash_jumping = true;
    }
    
    // Dash Jump!
    if (global.input.jump_buffer > 0 && grounded) {
        global.input.jump_buffer = 0;
        vsp = in_water ? WATER_JUMP_VELOCITY : JUMP_VELOCITY;
        is_dash_jumping = true;
        hsp = dash_dir * DASH_JUMP_SPEED;
        state = PLAYER_STATE.JUMP;
        if (audio_exists(snd_player_jump)) audio_play_sound(snd_player_jump, 70, false);
        if (object_exists(oFX_DashDust)) {
            instance_create_layer(x - (facing * 12), bbox_bottom, "Instances", oFX_DashDust);
        }
        return;
    }
    
    // Air Dash into Double Jump!
    if (!grounded) {
        var _can_double_jump = (has_double_jump || (variable_global_exists("has_double_jump") && global.has_double_jump));
        if (global.input.jump_pressed && _can_double_jump && !double_jump_used && !in_web) {
            double_jump_used = true;
            dash_timer = 0;
            vsp = in_water ? WATER_JUMP_VELOCITY : JUMP_VELOCITY;
            is_dash_jumping = true;
            var _move = global.input.right - global.input.left;
            if (_move != 0) facing = _move;
            hsp = facing * DASH_JUMP_SPEED;
            if (variable_instance_exists(id, "jump_frame")) jump_frame = 0.0;
            if (object_exists(oFX_DashDust)) {
                instance_create_layer(x, bbox_bottom, "Instances", oFX_DashDust);
            }
            state = PLAYER_STATE.JUMP;
            return;
        }
    }
    
    // Turn around cancels dash
    var _move = global.input.right - global.input.left;
    if (_move != 0 && _move != dash_dir) {
        dash_timer = 0;
        facing = _move;
        hsp = _move * RUN_SPEED;
        state = grounded ? PLAYER_STATE.RUN : PLAYER_STATE.FALL;
        return;
    }
    
    // Dash timeout
    if (dash_timer <= 0) {
        if (grounded) {
            state = (_move != 0) ? PLAYER_STATE.RUN : PLAYER_STATE.IDLE;
        } else {
            state = PLAYER_STATE.FALL;
        }
    }
}

// -------------------------------------------------------------------------
// WALL SLIDE STATE
// -------------------------------------------------------------------------
function player_state_wall_slide() {
    hsp = 0;
    vsp = min(vsp + (GRAVITY * 0.5), WALL_SLIDE_SPEED);
    if (anim_timer % 14 == 0 && audio_exists(snd_player_wall_slide)) {
        audio_play_sound(snd_player_wall_slide, 60, false);
    }
    facing = -touching_wall;
    
    if (grounded) {
        state = PLAYER_STATE.IDLE;
        return;
    }
    
    if (touching_wall == 0) {
        state = PLAYER_STATE.FALL;
        return;
    }
    
    // Wall Jump!
    if (global.input.jump_buffer > 0) {
        global.input.jump_buffer = 0;
        var _kick_dir = -touching_wall;
        facing = _kick_dir;
        var _is_dash_wall = (global.input.dash || global.input.dash_buffer > 0);
        var _wall_spd = _is_dash_wall ? DASH_JUMP_SPEED : WALL_JUMP_X_SPEED;
        hsp = _kick_dir * _wall_spd;
        vsp = WALL_JUMP_Y_SPEED;
        wall_jump_timer = WALL_JUMP_LOCK_FRAMES;
        is_dash_jumping = _is_dash_wall;
        air_dash_used = false;
        double_jump_used = false;
        state = PLAYER_STATE.WALL_JUMP;
        if (audio_exists(snd_player_jump)) audio_play_sound(snd_player_jump, 70, false);
        
        if (object_exists(oFX_DashDust)) {
            instance_create_layer(x + (touching_wall * 10), y, "Instances", oFX_DashDust);
        }
        return;
    }
    
    var _move = global.input.right - global.input.left;
    if (_move == -touching_wall) {
        state = PLAYER_STATE.FALL;
        return;
    }
}

// -------------------------------------------------------------------------
// WALL JUMP STATE
// -------------------------------------------------------------------------
function player_state_wall_jump() {
    if (global.input.jump_released && vsp < -1.5) {
        vsp = -1.5;
    }
    
    var _grav = in_water ? WATER_GRAVITY : GRAVITY;
    var _max_fall = in_water ? MAX_WATER_FALL_SPEED : MAX_FALL_SPEED;
    vsp = min(vsp + _grav, _max_fall);
    
    if (wall_jump_timer > 0) {
        wall_jump_timer--;
    } else {
        // Air Dash capability!
        var _can_air_dash = (has_air_dash || (variable_global_exists("has_air_dash") && global.has_air_dash));
        if (global.input.dash_pressed && _can_air_dash && !air_dash_used && !in_web) {
            air_dash_used = true;
        if (audio_exists(snd_player_air_dash)) audio_play_sound(snd_player_air_dash, 75, false);
            var _move = global.input.right - global.input.left;
            if (_move != 0) facing = _move;
            dash_timer = AIR_DASH_DURATION;
            dash_dir = facing;
            hsp = dash_dir * DASH_SPEED;
            vsp = 0;
            is_dash_jumping = true;
            state = PLAYER_STATE.DASH;
            if (object_exists(oFX_DashDust)) {
                instance_create_layer(x - (facing * 12), y, "Instances", oFX_DashDust);
            }
            return;
        }
        
        // Double Jump capability!
        var _can_double_jump = (has_double_jump || (variable_global_exists("has_double_jump") && global.has_double_jump));
        if (global.input.jump_pressed && _can_double_jump && !double_jump_used && !in_web) {
            double_jump_used = true;
            vsp = in_water ? WATER_JUMP_VELOCITY : JUMP_VELOCITY;
            if (audio_exists(snd_player_jump)) audio_play_sound(snd_player_jump, 70, false);
            var _move = global.input.right - global.input.left;
            if (_move != 0) facing = _move;
            var _dash_active = (is_dash_jumping || (global.input.dash && !in_web));
            if (_dash_active) {
                is_dash_jumping = true;
                hsp = facing * DASH_JUMP_SPEED;
            }
            if (variable_instance_exists(id, "jump_frame")) jump_frame = 0.0;
            if (object_exists(oFX_DashDust)) {
                instance_create_layer(x, bbox_bottom, "Instances", oFX_DashDust);
            }
            state = PLAYER_STATE.JUMP;
            return;
        }
        
        var _move = global.input.right - global.input.left;
        if (_move != 0) {
            facing = _move;
            var _dash_active = (is_dash_jumping || (global.input.dash && !in_web));
            var _spd = _dash_active ? DASH_JUMP_SPEED : RUN_SPEED;
            if (in_water) _spd *= 0.8;
            hsp = _move * _spd;
            if (_dash_active) is_dash_jumping = true;
        }
    }
    
    if (vsp >= 0) {
        state = PLAYER_STATE.FALL;
        return;
    }
    
    if (grounded) {
        state = PLAYER_STATE.IDLE;
        return;
    }
}

// -------------------------------------------------------------------------
// LADDER STATE
// -------------------------------------------------------------------------
function player_state_ladder() {
    hsp = 0;
    vsp = 0;
    
    // If currently performing top exit animation, don't interrupt
    if (is_ladder_exiting) {
        return;
    }
    
    if (!place_meeting(x, y, oLadder)) {
        state = PLAYER_STATE.FALL;
        return;
    }
    
    // Turn facing on ladder
    var _move = global.input.right - global.input.left;
    if (_move != 0) {
        facing = _move;
    }
    
    var _climb_speed = 1.5;
    var _shooting = (variable_instance_exists(id, "shoot_anim_timer") && shoot_anim_timer > 0);
    if (!_shooting) {
        if (global.input.up) {
            // Check top of ladder exit
            if (!place_meeting(x, y - 8, oLadder)) {
                is_ladder_exiting = true;
                ladder_exit_frame = 0.0;
                return;
            } else {
                vsp = -_climb_speed;
            }
        } else if (global.input.down) {
            vsp = _climb_speed;
        }
    }
    
    if (global.input.jump_pressed) {
        var _jump_dir = global.input.right - global.input.left;
        if (_jump_dir != 0) facing = _jump_dir;
        var _dash_active = (global.input.dash && !in_web);
        is_dash_jumping = _dash_active;
        var _spd = _dash_active ? DASH_JUMP_SPEED : RUN_SPEED;
        hsp = facing * _spd;
        vsp = JUMP_VELOCITY * 0.8;
        state = PLAYER_STATE.JUMP;
        return;
    }
    
    if (grounded && global.input.down) {
        state = PLAYER_STATE.IDLE;
        return;
    }
}

// -------------------------------------------------------------------------
// HURT STATE
// -------------------------------------------------------------------------
function player_state_hurt() {
    vsp = min(vsp + GRAVITY, MAX_FALL_SPEED);
    
    if (hurt_timer > 0) {
        hurt_timer--;
    } else {
        hsp = 0;
        state = grounded ? PLAYER_STATE.IDLE : PLAYER_STATE.FALL;
    }
}

// -------------------------------------------------------------------------
// DEATH STATE
// -------------------------------------------------------------------------
function player_state_death() {
    hsp = 0;
    vsp = 0;
    
    // Nếu chưa khởi tạo đối tượng hiệu ứng hạ gục obj_x_death_effect thì kích hoạt
    if (!instance_exists(obj_x_death_effect)) {
        player_trigger_death(id);
    }
}

// -------------------------------------------------------------------------
// INTRO STATE (Teleport Beam & Ready Stance)
// -------------------------------------------------------------------------
function player_state_intro() {
    hsp = 0;
    vsp = 0;
    
    // Play Teleport In SFX at the start of beam descent
    if (!variable_instance_exists(id, "intro_sound_played") || !intro_sound_played) {
        intro_sound_played = true;
        if (audio_exists(snd_teleport_in)) audio_play_sound(snd_teleport_in, 85, false);
    }
    
    // Fallback if intro sprites do not exist
    var _has_intro = (global.current_char == CHAR_TYPE.ZERO) ? (sprite_exists(sZero_Teleport_In) || sprite_exists(sZero_Intro)) : (sprite_exists(sX_Teleport_In) || sprite_exists(sX_Intro));
    if (!_has_intro) {
        state = PLAYER_STATE.IDLE;
        intro_sound_played = false;
        return;
    }
    
    if (intro_phase == 0) {
        // Phase 0: Beam descending from above
        teleport_beam_y += 18;
        if (teleport_beam_y >= y) {
            teleport_beam_y = y;
            intro_phase = 1;
            teleport_sphere_frame = 1.0;
        }
    } else if (intro_phase == 1) {
        // Phase 1: Energy sphere impact & burst (frames 1..7)
        teleport_sphere_frame += 0.35;
        if (teleport_sphere_frame >= 7.0) {
            intro_phase = 2;
            intro_anim_frame = 0.0;
            intro_hold_timer = 25; // Hold final battle stance
        }
    } else if (intro_phase == 2) {
        // Phase 2: Character materializes and poses (frames 0..8)
        if (intro_anim_frame < 8.0) {
            intro_anim_frame += 0.20;
            if (intro_anim_frame >= 8.0) {
                intro_anim_frame = 8.0;
            }
        } else {
            // Held at final battle stance (frame 8), waits until READY intro completes
            if (intro_hold_timer > 0) {
                intro_hold_timer--;
            } else if (!variable_global_exists("stage_ready") || global.stage_ready) {
                state = PLAYER_STATE.IDLE;
                intro_sound_played = false;
            }
        }
    }
}

// -------------------------------------------------------------------------
// TELEPORT OUT STATE (Stage Clear / Warp Away)
// -------------------------------------------------------------------------
function player_state_teleport_out() {
    hsp = 0;
    
    var _has_tout = (global.current_char == CHAR_TYPE.ZERO) ? sprite_exists(sZero_Teleport_Out) : sprite_exists(sX_Teleport_Out);
    if (!_has_tout) {
        state = PLAYER_STATE.IDLE;
        return;
    }
    
    if (global.current_char == CHAR_TYPE.ZERO) {
        if (teleport_out_frame < 12.0) {
            teleport_out_frame += 0.20;
            vsp = 0;
        } else {
            // Frames 12 & 13: Vertical beam shooting into the sky
            teleport_out_frame += 0.30;
            if (teleport_out_frame >= 14.0) teleport_out_frame = 12.0;
            vsp = -14;
            y += vsp;
        }
    } else {
        if (teleport_out_frame < 4.0) {
            teleport_out_frame += 0.20;
            vsp = 0;
        } else {
            // Frame 4: vertical beam shooting into the sky
            teleport_out_frame = 4.0;
            vsp = -14;
            y += vsp;
        }
    }
}

// -------------------------------------------------------------------------
// AFTERIMAGE RENDERING
// -------------------------------------------------------------------------
/// @desc Draw afterimages / ghost trail for dashing player
function player_draw_afterimages() {
    if (!variable_instance_exists(id, "afterimages") || array_length(afterimages) == 0) return;
    
    gpu_set_blendmode(bm_add);
    var _len = array_length(afterimages);
    for (var i = 0; i < _len; i++) {
        var _img = afterimages[i];
        if (sprite_exists(_img.sprite)) {
            gpu_set_fog(true, _img.color, 0, 0);
            draw_sprite_ext(_img.sprite, _img.frame, _img.x, _img.y, _img.facing, 1, 0, c_white, _img.alpha);
        }
    }
    gpu_set_fog(false, c_white, 0, 0);
    gpu_set_blendmode(bm_normal);
}
