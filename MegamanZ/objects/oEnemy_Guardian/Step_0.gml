event_inherited();
if (is_dead) return;

if (target != noone) {
    facing = (target.x >= x) ? 1 : -1;
}

switch (state) {
    case 0: // SHIELD_PATROL: Shield faces player. Frontal attacks blocked!
        is_invulnerable = true;
        shield_direction = 1;
        x = start_x + sin(anim_timer * 0.04) * 24;
        y = start_y + cos(anim_timer * 0.06) * 10;
        
        if (target != noone && point_distance(x, y, target.x, target.y) < 220) {
            state_timer++;
            if (state_timer > 60) {
                state = 1; // LOCK_CHARGE
                state_timer = 0;
            }
        }
        break;

    case 1: // LOCK_CHARGE: Satellites rotate rapidly, eye charges energy
        is_invulnerable = true;
        shield_direction = 1;
        state_timer++;
        if (state_timer > 30) {
            state = 2; // OPEN_ATTACK
            state_timer = 0;
            is_invulnerable = false; // SHIELD OPENS! Fully vulnerable!
        }
        break;

    case 2: // OPEN_ATTACK: Shield parted, fires 2 angled laser projectiles
        is_invulnerable = false;
        state_timer++;
        if (state_timer == 2 && target != noone) {
            var _base_dir = point_direction(x, y, target.x, target.y);
            
            var _b1 = instance_create_layer(x + facing * 12, y, "Instances", oEnemyBullet);
            _b1.damage = projectile_damage;
            _b1.hsp = lengthdir_x(3.2, _base_dir - 12);
            _b1.vsp = lengthdir_y(3.2, _base_dir - 12);
            
            var _b2 = instance_create_layer(x + facing * 12, y, "Instances", oEnemyBullet);
            _b2.damage = projectile_damage;
            _b2.hsp = lengthdir_x(3.2, _base_dir + 12);
            _b2.vsp = lengthdir_y(3.2, _base_dir + 12);
            
            camera_shake(2, 6);
        }
        if (state_timer >= 32) {
            state = 3; // RECOVER
            state_timer = 0;
            is_invulnerable = false; // Remains vulnerable during recovery window
        }
        break;

    case 3: // RECOVER: Closes shield back up
        is_invulnerable = false;
        state_timer++;
        if (state_timer >= 18) {
            state = 0; // Back to SHIELD_PATROL
            state_timer = 0;
            is_invulnerable = true;
            shield_direction = 1;
        }
        break;
}
