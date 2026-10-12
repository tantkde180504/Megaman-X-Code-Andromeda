event_inherited();
if (is_dead) return;

switch (state) {
    case 0: // CEILING_PERCH: Hanging from ceiling, wings wrapped, fully invulnerable
        is_invulnerable = true;
        shield_direction = 0;
        hsp = 0;
        vsp = 0;
        if (target != noone && abs(target.x - x) < 140 && target.y > y) {
            state = 1; // WAKE
            state_timer = 0;
            is_invulnerable = false;
        }
        break;

    case 1: // WAKE: Opens eyes and unfurls wings
        is_invulnerable = false;
        state_timer++;
        if (state_timer > 20) {
            state = 2; // SWOOP_FLIGHT
            state_timer = 0;
            start_y = y;
            if (target != noone) facing = (target.x >= x) ? 1 : -1;
        }
        break;

    case 2: // SWOOP_FLIGHT: Smooth flight towards player
        is_invulnerable = false;
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        hsp = facing * 1.8;
        vsp = sin(anim_timer * 0.12) * 2.2;
        x += hsp;
        y += vsp;
        
        // When overhead or close, drop bomb!
        if (target != noone && abs(target.x - x) < 28 && target.y > y) {
            state = 3; // DROP_BOMB
            state_timer = 0;
        }
        
        state_timer++;
        if (state_timer > 140) {
            state = 4; // RETURN_CEILING
            state_timer = 0;
        }
        break;

    case 3: // DROP_BOMB: Drops aerial bomb!
        is_invulnerable = false;
        hsp = facing * 1.0;
        x += hsp;
        state_timer++;
        if (state_timer == 4) {
            var _bomb = instance_create_layer(x, y + 16, "Instances", oEnemy_BattonBomb);
            _bomb.damage = projectile_damage;
            _bomb.hsp = 0;
            _bomb.vsp = 2.2;
            camera_shake(1, 3);
        }
        if (state_timer > 20) {
            state = 4; // RETURN_CEILING
            state_timer = 0;
        }
        break;

    case 4: // RETURN_CEILING: Ascends back up to ceiling
        is_invulnerable = false;
        vsp = -1.6;
        y += vsp;
        if (place_meeting(x, y - 6, oSolid) || y <= start_y) {
            state = 0; // Back to perching
            state_timer = 0;
            is_invulnerable = true;
            shield_direction = 0;
        }
        break;
}
