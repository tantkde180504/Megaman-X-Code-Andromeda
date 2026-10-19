/// @desc Lightning Web Projectile Step
anim_timer += 0.25;

if (!deployed) {
    if (homing_timer > 0) {
        homing_timer--;
        if (instance_exists(oPlayer)) {
            var _p = instance_nearest(x, y, oPlayer);
            var _target_dir = point_direction(x, y, _p.x, _p.y - 14);
            var _diff = angle_difference(_target_dir, direction);
            direction += clamp(_diff, -4.5, 4.5);
        }
    } else {
        homing_timer--;
        // Auto deploy after 50 frames total
        if (homing_timer <= -20) {
            speed = 0;
            deployed = true;
        }
    }
    
    // Check solid terrain collision to deploy early
    var _next_x = x + lengthdir_x(speed, direction);
    var _next_y = y + lengthdir_y(speed, direction);
    if (place_meeting(_next_x, _next_y, oSolid)) {
        speed = 0;
        deployed = true;
        camera_shake(1, 3);
    }
} else {
    speed = 0;
    deploy_timer--;
    if (deploy_timer <= 0) {
        instance_destroy();
        return;
    }
}

// Player collision & bind
if (instance_exists(oPlayer)) {
    var _p = instance_nearest(x, y, oPlayer);
    if (place_meeting(x, y, _p)) {
        if (_p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
            var _kdir = (x >= _p.x) ? -1 : 1;
            player_take_damage(damage, _kdir);
            
            // Attach web bound state
            _p.is_web_bound = true;
            _p.web_bound_timer = 60;
            _p.web_bound_damage_timer = 30;
            
            if (!deployed) {
                deployed = true;
                speed = 0;
            }
        }
    }
}
