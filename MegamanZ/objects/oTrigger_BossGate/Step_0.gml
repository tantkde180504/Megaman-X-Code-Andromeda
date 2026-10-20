// Step Event of oTrigger_BossGate

// Keep sprite frame in sync
image_speed = 0;
image_index = clamp(floor(anim_frame), 0, 13);

switch (gate_state) {
    case GATE_STATE.CLOSED:
        anim_frame = 0.0;
        if (instance_exists(oPlayer)) {
            var _p = instance_find(oPlayer, 0);
            // Player triggers door when touching it from the left
            var _touching = place_meeting(x - 4, y, _p) || place_meeting(x, y, _p) ||
                (_p.bbox_right >= bbox_left - 4 && _p.bbox_left <= bbox_right + 4 &&
                 _p.bbox_bottom >= bbox_top - 8 && _p.bbox_top <= bbox_bottom + 8);
                 
            if (_touching) {
                gate_state = GATE_STATE.OPENING;
                if (audio_exists(snd_boss_gate)) audio_play_sound(snd_boss_gate, 85, false);
                anim_frame = 0.0;
                global.input_locked = true;
                _p.hsp = 0;
                _p.facing = 1;
                if (_p.grounded && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
                    _p.state = PLAYER_STATE.IDLE;
                }
                if (variable_instance_exists(_p, "slash_anim_timer")) _p.slash_anim_timer = 0;
                if (variable_instance_exists(_p, "technique_state")) _p.technique_state = TECHNIQUE.NONE;
            }
        }
        break;
        
    case GATE_STATE.OPENING:
        // Lock player input during opening
        global.input_locked = true;
        if (instance_exists(oPlayer)) {
            var _p = instance_find(oPlayer, 0);
            _p.hsp = 0;
            _p.facing = 1;
            if (_p.grounded && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
                _p.state = PLAYER_STATE.IDLE;
            }
        }
        
        anim_frame += anim_spd;
        if (anim_frame >= 13.0) {
            anim_frame = 13.0;
            gate_state = GATE_STATE.WALKING;
            walk_target_x = x + 40;
            if (instance_exists(oPlayer)) {
                var _p = instance_find(oPlayer, 0);
                _p.is_auto_walking = true;
                _p.facing = 1;
                _p.state = PLAYER_STATE.RUN;
            }
        }
        break;
        
    case GATE_STATE.WALKING:
        anim_frame = 13.0; // Keep door fully open
        global.input_locked = true;
        
        if (instance_exists(oPlayer)) {
            var _p = instance_find(oPlayer, 0);
            _p.facing = 1;
            _p.is_auto_walking = true;
            _p.state = PLAYER_STATE.RUN;
            _p.hsp = walk_spd;
            _p.x += walk_spd;
            
            // Allow floor snapping if floor drops slightly
            if (!place_meeting(_p.x, _p.y + 1, oSolid) && place_meeting(_p.x, _p.y + 4, oSolid)) {
                _p.y += 2;
            }
            
            // Check if player has stepped fully through the door
            if (_p.x >= walk_target_x) {
                _p.x = walk_target_x;
                _p.hsp = 0;
                _p.is_auto_walking = false;
                _p.state = PLAYER_STATE.IDLE;
                gate_state = GATE_STATE.WAIT_CLOSE;
                close_wait_timer = 60; // Wait 1 second (60 frames at 60 fps) before door starts closing
            }
        } else {
            gate_state = GATE_STATE.WAIT_CLOSE;
            close_wait_timer = 60;
        }
        break;
        
    case GATE_STATE.WAIT_CLOSE:
        // Door remains fully open for 1s after character has completely passed through
        anim_frame = 13.0;
        global.input_locked = true;
        
        if (instance_exists(oPlayer)) {
            var _p = instance_find(oPlayer, 0);
            _p.is_auto_walking = false;
            _p.hsp = 0;
            _p.facing = 1;
            if (_p.grounded && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
                _p.state = PLAYER_STATE.IDLE;
            }
        }
        
        if (close_wait_timer > 0) {
            close_wait_timer--;
        } else {
            gate_state = GATE_STATE.CLOSING;
            if (audio_exists(snd_boss_gate)) audio_play_sound(snd_boss_gate, 85, false);
        }
        break;
        
    case GATE_STATE.CLOSING:
        global.input_locked = true;
        if (instance_exists(oPlayer)) {
            var _p = instance_find(oPlayer, 0);
            _p.is_auto_walking = false;
            _p.hsp = 0;
            _p.facing = 1;
            if (_p.grounded && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
                _p.state = PLAYER_STATE.IDLE;
            }
        }
        
        // Reverse animation: 13 down to 0
        anim_frame -= anim_spd;
        if (anim_frame <= 0.0) {
            anim_frame = 0.0;
            gate_state = GATE_STATE.LOCKED;
            camera_shake(3, 8);
            
            // Cửa 1 (Cửa ngoài vào đường hầm): Tạo điểm Save (Checkpoint) an toàn trong hành lang trước Cửa 2
            if (!is_arena_door) {
                global.checkpoint_x = 4950;
                global.checkpoint_y = 2032;
                global.input_locked = false; // Restore player controls to explore corridor
            }
            
            // Cửa 2 (Cửa trong vào đấu trường): Bắt đầu màn đấu trùm!
            if (is_arena_door) {
                music_play_boss_nightmare_zero();
                if (room_get_name(room) == "rStage_WebSpider") {
                    if (instance_exists(obj_nightmare_zero)) {
                        with (obj_nightmare_zero) {
                            if (state == NZ_STATE.SLEEP) {
                                visible = true;
                                nz_change_state(NZ_STATE.INTRO);
                            }
                        }
                    } else {
                        var _boss = instance_create_layer(5250, 2096, "Instances", obj_nightmare_zero);
                        _boss.facing = -1;
                    }
                }
            }
        }
        break;
        
    case GATE_STATE.LOCKED:
        // Permanently shut! Solid collision remains active, cannot be opened again.
        anim_frame = 0.0;
        break;
}
