event_inherited();
if (is_dead) return;

switch (state) {
    case 0: // JET_HOVER: Airborne hovering with bottom thruster
        hsp = facing * 0.8;
        vsp = sin(anim_timer * 0.08) * 0.8;
        
        if (place_meeting(x + hsp, y, oSolid)) {
            facing = -facing;
            hsp = facing * 0.8;
        }
        x += hsp;
        y += vsp;
        
        // Target detection in aerial patrol range
        if (target != noone && point_distance(x, y, target.x, target.y) < 180) {
            state = 1; // SHELL_OPEN
            state_timer = 0;
            facing = (target.x >= x) ? 1 : -1;
        }
        break;

    case 1: // SHELL_OPEN: Prepares horizontal rocket booster
        hsp = 0;
        vsp = sin(anim_timer * 0.1) * 0.4;
        y += vsp;
        state_timer++;
        if (state_timer >= 14) {
            state = 2; // ROCKET_CHARGE
            state_timer = 0;
            camera_shake(1, 4);
        }
        break;

    case 2: // ROCKET_CHARGE: High-speed horizontal jet boost with rear blue flame!
        hsp = facing * 3.6;
        vsp = 0;
        if (state_timer % 6 == 0) instance_create_layer(x - facing * 16, y, "Instances", oFX_DashDust);
        
        if (place_meeting(x + hsp, y, oSolid)) {
            state = 3; // BRAKE
            state_timer = 0;
            camera_shake(2, 6);
        } else {
            x += hsp;
        }
        state_timer++;
        if (state_timer > 50) {
            state = 3; // BRAKE
            state_timer = 0;
        }
        break;

    case 3: // BRAKE / RECOVER: Decelerates, shell closes, resets hover
        hsp = lerp(hsp, 0, 0.2);
        x += hsp;
        state_timer++;
        if (state_timer >= 16) {
            facing = -facing;
            state = 0; // Back to hover
            state_timer = 0;
        }
        break;
}

