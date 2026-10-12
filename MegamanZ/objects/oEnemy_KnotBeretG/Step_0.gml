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
        if (target != noone && abs(target.y - y) < 48 && (target.x - x) * facing > 0 && abs(target.x - x) < 220) {
            state = 1; // AIM_RIFLE
            state_timer = 0;
        }
        break;

    case 1: // AIM_RIFLE: Aims weapon directly at player
        hsp = 0;
        state_timer++;
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        if (state_timer > 18) {
            state = 2; // FIRE_RIFLE
            state_timer = 0;
        }
        break;

    case 2: // FIRE_RIFLE: Fires 2 horizontal rifle rounds with recoil
        hsp = 0;
        state_timer++;
        if (state_timer == 2 || state_timer == 14) {
            var _b = instance_create_layer(x + facing * 24, y - 26, "Instances", oEnemyBullet);
            _b.damage = projectile_damage;
            _b.hsp = facing * bullet_speed;
            _b.vsp = 0;
            camera_shake(1, 3);
        }
        if (state_timer > 32) {
            state = 3; // RECOVER
            state_timer = 0;
        }
        break;

    case 3: // RECOVER: Recovery delay before resuming patrol
        hsp = 0;
        state_timer++;
        if (state_timer > 28) {
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
