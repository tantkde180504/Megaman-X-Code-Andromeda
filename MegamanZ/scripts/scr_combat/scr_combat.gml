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
        _p.death_timer = 60;
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
