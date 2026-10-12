event_inherited();
if (is_dead) return;

switch (state) {
    case 0: // PATROL: Marches along platform
        hsp = facing * 1.0;
        if (place_meeting(x + hsp, y, oSolid) || !place_meeting(x + facing * 16, y + 8, oSolid)) {
            facing = -facing;
            hsp = facing * 1.0;
        }
        x += hsp;
        
        // Spot player in front
        if (target != noone && abs(target.y - y) < 64 && (target.x - x) * facing > 0 && abs(target.x - x) < 220) {
            state = 1; // GRENADE_WINDUP
            state_timer = 0;
        }
        break;

    case 1: // GRENADE_WINDUP: Prepares throw pose
        hsp = 0;
        state_timer++;
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        if (state_timer > 22) {
            state = 2; // GRENADE_THROW
            state_timer = 0;
        }
        break;

    case 2: // GRENADE_THROW: Spawns arcing grenade projectile on throw release!
        hsp = 0;
        state_timer++;
        if (state_timer == 8) {
            var _g = instance_create_layer(x + facing * 16, y - 36, "Instances", oEnemy_Grenade);
            _g.damage = projectile_damage;
            _g.hsp = facing * grenade_speed_x;
            _g.vsp = grenade_speed_y;
            camera_shake(1, 3);
        }
        if (state_timer > 24) {
            state = 3; // RECOVER
            state_timer = 0;
        }
        break;

    case 3: // RECOVER: Recovery delay before resuming patrol
        hsp = 0;
        state_timer++;
        if (state_timer > 30) {
            state = 0;
            state_timer = 0;
        }
        break;
}

// Gravity
vsp += grav;
if (place_meeting(x, y + vsp, oSolid)) {
    while (!place_meeting(x, y + sign(vsp), oSolid)) y += sign(vsp);
    vsp = 0;
    grounded = true;
} else {
    grounded = false;
}
y += vsp;
