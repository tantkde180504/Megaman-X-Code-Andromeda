event_inherited();
if (is_dead) return;

if (target != noone) {
    facing = (target.x >= x) ? 1 : -1;
}

switch (state) {
    case 0: // PATROL_HOVER: Drifts in patrol area, hovers with sinusoidal altitude
        hsp = sin(anim_timer * 0.03) * 0.8;
        x = start_x + sin(anim_timer * 0.03) * patrol_radius;
        y = start_y + sin(anim_timer * 0.08) * 8;
        
        state_timer++;
        if (state_timer > fire_interval && target != noone && point_distance(x, y, target.x, target.y) < 280) {
            state = 1; // AIM
            state_timer = 0;
        }
        break;

    case 1: // AIM: Halts drift, locks cannon on target position
        y = start_y + sin(anim_timer * 0.08) * 4;
        state_timer++;
        if (state_timer >= 18) {
            state = 2; // FIRE
            state_timer = 0;
        }
        break;

    case 2: // FIRE: Spawns energy projectile aimed at player position at moment of fire
        y = start_y + sin(anim_timer * 0.08) * 4;
        state_timer++;
        if (state_timer == 1 && target != noone) {
            var _dir = point_direction(x + facing * 14, y, target.x, target.y - 16);
            var _b = instance_create_layer(x + facing * 14, y, "Instances", oEnemyBullet);
            _b.damage = projectile_damage;
            _b.hsp = lengthdir_x(bullet_speed, _dir);
            _b.vsp = lengthdir_y(bullet_speed, _dir);
            camera_shake(1, 4);
        }
        if (state_timer >= 14) {
            state = 3; // RECOVER
            state_timer = 0;
        }
        break;

    case 3: // RECOVER: Brief recoil delay before resuming patrol
        y = start_y + sin(anim_timer * 0.08) * 6;
        state_timer++;
        if (state_timer >= 24) {
            state = 0;
            state_timer = 0;
        }
        break;
}
