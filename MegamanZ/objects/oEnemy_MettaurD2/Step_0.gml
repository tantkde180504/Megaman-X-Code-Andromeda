event_inherited();
if (is_dead) return;

switch (state) {
    case 0: // GUARD: Completely invulnerable under helmet
        is_invulnerable = true;
        shield_direction = 0;
        hsp = 0;
        if (target != noone && point_distance(x, y, target.x, target.y) < 160) {
            state_timer++;
            if (state_timer > 50) {
                state = 1;
                state_timer = 0;
                is_invulnerable = false;
                facing = (target.x >= x) ? 1 : -1;
            }
        }
        break;

    case 1: // PEEK: Reveals head, exposed and vulnerable
        is_invulnerable = false;
        hsp = 0;
        state_timer++;
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        if (state_timer > 20) {
            state = 2;
            state_timer = 0;
        }
        break;

    case 2: // ATTACK: Fires 3 spread energy pellets
        is_invulnerable = false;
        hsp = 0;
        state_timer++;
        if (state_timer == 2) {
            var _b1 = instance_create_layer(x + facing * 12, y - 12, "Instances", oEnemyBullet);
            _b1.damage = projectile_damage;
            _b1.hsp = facing * 2.8; _b1.vsp = 0;
            
            var _b2 = instance_create_layer(x + facing * 12, y - 12, "Instances", oEnemyBullet);
            _b2.damage = projectile_damage;
            _b2.hsp = facing * 2.5; _b2.vsp = -1.2;
            
            var _b3 = instance_create_layer(x + facing * 12, y - 12, "Instances", oEnemyBullet);
            _b3.damage = projectile_damage;
            _b3.hsp = facing * 2.5; _b3.vsp = 1.2;
        }
        if (state_timer > 25) {
            state = 3;
            state_timer = 0;
        }
        break;

    case 3: // WALK: Walks on feet, vulnerable
        is_invulnerable = false;
        hsp = facing * 1.1;
        if (place_meeting(x + hsp, y, oSolid) || !place_meeting(x + facing * 16, y + 8, oSolid)) {
            facing = -facing;
            hsp = facing * 1.1;
        }
        x += hsp;
        
        state_timer++;
        if (state_timer > 65) {
            state = 0;
            state_timer = 0;
            is_invulnerable = true;
        }
        break;
}

// Gravity & Ground collision
vsp += grav;
if (place_meeting(x, y + vsp, oSolid)) {
    while (!place_meeting(x, y + sign(vsp), oSolid)) y += sign(vsp);
    vsp = 0;
    grounded = true;
} else {
    grounded = false;
}
y += vsp;
