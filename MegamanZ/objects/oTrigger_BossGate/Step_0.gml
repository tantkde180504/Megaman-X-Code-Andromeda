// Step Event of oTrigger_BossGate

// Keep sprite frame in sync
image_speed = 0;
image_index = clamp(floor(anim_frame), 0, 13);

switch (gate_state) {
    case GATE_STATE.CLOSED:
        anim_frame = 0.0;
        if (instance_exists(oPlayer)) {
            var _p = instance_find(oPlayer, 0);
            // Player triggers door when approaching from the left
            if (_p.x >= x - 28 && _p.x <= x + 4 && abs(_p.y - (y + 32)) <= 48) {
                gate_state = GATE_STATE.OPENING;
                anim_frame = 0.0;
            }
        }
        break;
        
    case GATE_STATE.OPENING:
        // Lock player input during opening
        if (variable_global_exists("input") && is_struct(global.input)) {
            global.input.left = false;
            global.input.right = false;
            global.input.jump = false;
            global.input.jump_pressed = false;
            global.input.dash = false;
            global.input.dash_pressed = false;
            global.input.shoot = false;
            global.input.shoot_pressed = false;
            global.input.special = false;
            global.input.special_pressed = false;
        }
        if (instance_exists(oPlayer)) {
            var _p = instance_find(oPlayer, 0);
            _p.hsp = 0;
            _p.facing = 1;
            if (_p.grounded) {
                _p.state = PLAYER_STATE.IDLE;
            }
        }
        
        anim_frame += anim_spd;
        if (anim_frame >= 13.0) {
            anim_frame = 13.0;
            gate_state = GATE_STATE.WALKING;
            if (instance_exists(oPlayer)) {
                var _p = instance_find(oPlayer, 0);
                walk_target_x = max(x + 44, _p.x + 36);
            } else {
                walk_target_x = x + 44;
            }
        }
        break;
        
    case GATE_STATE.WALKING:
        anim_frame = 13.0;
        
        // Lock player input during auto-walk
        if (variable_global_exists("input") && is_struct(global.input)) {
            global.input.left = false;
            global.input.right = false;
            global.input.jump = false;
            global.input.jump_pressed = false;
            global.input.dash = false;
            global.input.dash_pressed = false;
            global.input.shoot = false;
            global.input.shoot_pressed = false;
            global.input.special = false;
            global.input.special_pressed = false;
        }
        
        if (instance_exists(oPlayer)) {
            var _p = instance_find(oPlayer, 0);
            _p.facing = 1;
            _p.state = PLAYER_STATE.RUN;
            _p.hsp = walk_spd;
            _p.vsp = 0;
            _p.x += walk_spd;
            
            // Check if player has stepped fully through the door
            if (_p.x >= walk_target_x) {
                _p.hsp = 0;
                _p.state = PLAYER_STATE.IDLE;
                gate_state = GATE_STATE.CLOSING;
            }
        } else {
            gate_state = GATE_STATE.CLOSING;
        }
        break;
        
    case GATE_STATE.CLOSING:
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
            }
            
            // If arena door, trigger boss intro & music
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
