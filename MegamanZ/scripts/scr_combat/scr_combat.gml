/// @desc Combat & Damage System

function player_take_damage(_amount, _knockback_dir) {
    if (!instance_exists(oPlayer)) return;
    var _p = instance_find(oPlayer, 0);
    if (_p == noone) return;
    
    // Ignore damage during iframes, hurt state or death
    if (_p.iframes > 0 || _p.state == PLAYER_STATE.HURT || _p.state == PLAYER_STATE.DEATH) {
        return;
    }
    
    _p.hp_current = max(0, _p.hp_current - _amount);
    camera_shake(4, 12);
    
    if (_p.hp_current <= 0) {
        _p.state = PLAYER_STATE.DEATH;
        _p.hsp = 0;
        _p.vsp = 0;
        _p.death_timer = 90;
        _p.death_phase = 0;
        music_stop_boss_nightmare_zero(1000);
    } else {
        _p.state = PLAYER_STATE.HURT;
        _p.hurt_timer = 18;
        _p.iframes = 60;
        if (_knockback_dir != 0) _p.facing = -_knockback_dir;
        _p.hsp = _knockback_dir * 1.8;
        _p.vsp = -2.5;
        _p.grounded = false;
        if (variable_instance_exists(_p, "is_ladder_exiting")) _p.is_ladder_exiting = false;
    }
}

function deal_damage_to_target(_target, _damage, _hit_x = x, _hit_y = y) {
    if (instance_exists(_target)) {
        // Check invulnerability and directional shield (e.g. Guardian, Mettaur, Batton)
        if (variable_instance_exists(_target, "is_invulnerable") && _target.is_invulnerable) {
            var _blocked = true;
            if (variable_instance_exists(_target, "shield_direction") && _target.shield_direction == 1) {
                // Directional frontal shield: blocks if incoming attack hits the front
                var _tfacing = variable_instance_exists(_target, "facing") ? _target.facing : 1;
                _blocked = ((_tfacing == 1 && _hit_x >= _target.x - 6) || (_tfacing == -1 && _hit_x <= _target.x + 6));
            }
            if (_blocked) {
                if (object_exists(oFX_HitSpark)) {
                    instance_create_layer(_hit_x, _hit_y, "Instances", oFX_HitSpark);
                }
                camera_shake(1, 4);
                return; // Attack bounced off with zero damage!
            }
        }
        
        if (variable_instance_exists(_target, "hp")) {
            _target.hp = max(0, _target.hp - _damage);
        }
        if (variable_instance_exists(_target, "flash_timer")) {
            _target.flash_timer = 8;
        }
        if (variable_instance_exists(_target, "invulnerability_timer")) {
            _target.invulnerability_timer = 8;
        }
        
        // Spawn hit spark FX
        if (object_exists(oFX_HitSpark)) {
            instance_create_layer(_hit_x, _hit_y, "Instances", oFX_HitSpark);
        }
    }
}

/// @desc Reset Boss Room and Doors upon player death & respawn
function scr_reset_boss_room() {
    // 1. Reset Door 2 (inner arena door) so it can be approached and entered again
    with (oTrigger_BossGate) {
        if (is_arena_door) {
            gate_state = GATE_STATE.CLOSED;
            anim_frame = 0.0;
            image_index = 0;
        } else {
            // Door 1 remains locked! Player cannot backtrack out into the stage
            gate_state = GATE_STATE.LOCKED;
            anim_frame = 0.0;
            image_index = 0;
        }
    }
    
    // 2. Reset Boss Nightmare Zero
    if (instance_exists(obj_nightmare_zero)) {
        with (obj_nightmare_zero) {
            state = NZ_STATE.SLEEP;
            visible = false;
            hp = max_hp;
            prev_hp = max_hp;
            hp_display = 0;
            intro_done = false;
            messenkou_done = false;
            warning_timer = 90;
            x = 5280;
            y = 2080;
            facing = -1;
            hsp = 0;
            vsp = 0;
            image_alpha = 1;
            flash_timer = 0;
            invulnerability_timer = 0;
        }
    }
    
    // 3. Clean up any leftover boss projectiles or hazards in arena
    if (instance_exists(obj_nz_slash_hitbox)) with (obj_nz_slash_hitbox) instance_destroy();
    if (instance_exists(obj_nz_crescent)) with (obj_nz_crescent) instance_destroy();
    if (instance_exists(obj_nz_giant_wave)) with (obj_nz_giant_wave) instance_destroy();
    if (instance_exists(obj_nz_drill)) with (obj_nz_drill) instance_destroy();
    if (instance_exists(obj_nz_ring_fx)) with (obj_nz_ring_fx) instance_destroy();
    if (instance_exists(obj_nz_messenkou_beam)) with (obj_nz_messenkou_beam) instance_destroy();
    if (instance_exists(obj_nz_messenkou_vent)) with (obj_nz_messenkou_vent) instance_destroy();
    if (instance_exists(obj_nz_floor_burst)) with (obj_nz_floor_burst) instance_destroy();
    if (instance_exists(obj_nz_skull_wave)) with (obj_nz_skull_wave) instance_destroy();
    if (instance_exists(obj_nz_spike)) with (obj_nz_spike) instance_destroy();
    
    // 4. Mark dialogue as already seen so it doesn't replay when re-entering!
    global.nz_dialogue_seen = true;
    
    // 5. Stop boss music
    music_stop_boss_nightmare_zero(500);
}
