/// @desc Lightning Web Projectile Step (Hitbox & Speed Matched to Animation)
anim_timer += 0.30;

if (!deployed) {
    // 1. Flight Phase: Small Seed Orb
    image_xscale = 0.6;
    image_yscale = 0.6;
    
    if (homing_timer > 0) {
        homing_timer--;
        if (instance_exists(oPlayer)) {
            var _p = instance_nearest(x, y, oPlayer);
            var _target_dir = point_direction(x, y, _p.x, _p.y - 14);
            var _diff = angle_difference(_target_dir, direction);
            direction += clamp(_diff, -2.6, 2.6); // Smooth organic homing arc
        }
    } else {
        homing_timer--;
        // Auto-deploy after flight duration expires (~44 frames total)
        if (homing_timer <= -8) {
            speed = 0;
            deployed = true;
            deploy_anim_timer = 0;
        }
    }
    
    // Check solid terrain collision to deploy against wall or floor
    var _next_x = x + lengthdir_x(speed, direction);
    var _next_y = y + lengthdir_y(speed, direction);
    if (collision_circle(_next_x, _next_y, 6, oSolid, true, false) != noone) {
        speed = 0;
        deployed = true;
        deploy_anim_timer = 0;
        camera_shake(1, 3);
    }
    
    // Hitbox in flight: precise circle radius 8 matching the flying seed orb (10x10)
    if (instance_exists(oPlayer)) {
        var _p = instance_nearest(x, y, oPlayer);
        if (collision_circle(x, y, 8, _p, true, false) != noone) {
            if (_p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
                var _kdir = (x >= _p.x) ? -1 : 1;
                player_take_damage(damage, _kdir);
                
                // Attach web bound state
                _p.is_web_bound = true;
                _p.web_bound_timer = 60;
                _p.web_bound_damage_timer = 30;
                
                // Deploy on impact
                deployed = true;
                deploy_anim_timer = 0;
                speed = 0;
            }
        }
    }
} else {
    // 2. Deployed Phase: Stationary Electrified Web Trap
    speed = 0;
    deploy_anim_timer++;
    deploy_timer--;
    
    // Scale mask up to match deployed octagon web
    image_xscale = 1.8;
    image_yscale = 1.8;
    
    if (deploy_timer <= 0) {
        instance_destroy();
        return;
    }
    
    // Hitbox when deployed: precise ellipse (radius X=22, radius Y=20) matching the 47x43 web
    if (instance_exists(oPlayer)) {
        var _p = instance_nearest(x, y, oPlayer);
        if (collision_ellipse(x - 22, y - 20, x + 22, y + 20, _p, true, false) != noone) {
            if (_p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
                var _kdir = (x >= _p.x) ? -1 : 1;
                player_take_damage(damage, _kdir);
                
                // Attach web bound state
                _p.is_web_bound = true;
                _p.web_bound_timer = 60;
                _p.web_bound_damage_timer = 30;
            }
        }
    }
}
