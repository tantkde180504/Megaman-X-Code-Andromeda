event_inherited();
if (is_dead) return;

switch (state) {
    case 0: // FLY_PATROL: Rapid rotor flight
        hsp = facing * 2.0;
        y = start_y + sin(anim_timer * 0.1) * 8;
        x += hsp;
        
        if (x < 24 || x > room_width - 24 || place_meeting(x + hsp * 2, y, oSolid)) {
            facing = -facing;
        }
        
        // Detect player within range
        if (target != noone && point_distance(x, y, target.x, target.y) < 220) {
            state = 1; // SWOOP_APPROACH
            state_timer = 0;
        }
        break;

    case 1: // SWOOP_APPROACH: Dips closer toward player's horizontal position
        hsp = (target != noone && target.x < x) ? -1.8 : 1.8;
        facing = sign(hsp);
        x += hsp;
        y = start_y + sin(anim_timer * 0.1) * 16;
        
        // When nearly directly overhead, drop bomb!
        if (target != noone && abs(target.x - x) < 32 && target.y > y) {
            state = 2; // DROP_BOMB
            state_timer = 0;
        }
        state_timer++;
        if (state_timer > 90) {
            state = 3;
            state_timer = 0;
        }
        break;

    case 2: // DROP_BOMB: Bends tail downward, spawns bomb projectile
        hsp = facing * 0.8;
        x += hsp;
        state_timer++;
        if (state_timer == 6) {
            var _bomb = instance_create_layer(x, y + 16, "Instances", oEnemy_BattonBomb);
            _bomb.damage = projectile_damage;
            _bomb.hsp = 0;
            _bomb.vsp = 2.4;
            camera_shake(1, 3);
        }
        if (state_timer > 24) {
            state = 3; // RETURN
            state_timer = 0;
        }
        break;

    case 3: // RETURN: Gains altitude back to start_y
        hsp = facing * 1.5;
        x += hsp;
        if (y > start_y) y -= 1.2;
        state_timer++;
        if (state_timer > 45) {
            state = 0;
            state_timer = 0;
        }
        break;
}
