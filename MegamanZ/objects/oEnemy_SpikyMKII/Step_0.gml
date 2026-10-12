event_inherited();
if (is_dead) return;

switch (state) {
    case 0: // PATROL_ROLL: Rolls along floor
        is_invulnerable = false;
        hsp = facing * 1.4;
        
        if (place_meeting(x + hsp, y, oSolid) || !place_meeting(x + facing * 16, y + 8, oSolid)) {
            facing = -facing;
            hsp = facing * 1.4;
        }
        x += hsp;
        
        // Spot player in front
        if (target != noone && abs(target.y - y) < 32 && (target.x - x) * facing > 0 && abs(target.x - x) < 180) {
            state = 1; // CHARGE
            state_timer = 0;
            camera_shake(1, 4);
        }
        break;

    case 1: // CHARGE: Rapid rolling charge
        is_invulnerable = false;
        hsp = facing * 3.8;
        if (state_timer % 8 == 0) instance_create_layer(x, y, "Instances", oFX_DashDust);
        
        if (place_meeting(x + hsp, y, oSolid)) {
            // Impact with wall transitions to DEFENSE_SPIKED!
            state = 2; // DEFENSE
            state_timer = 0;
            camera_shake(2, 6);
        } else {
            x += hsp;
        }
        
        state_timer++;
        if (state_timer > 80) {
            state = 2; // Transitions into DEFENSE
            state_timer = 0;
        }
        break;

    case 2: // DEFENSE_SPIKED: Deploys heavy defensive spikes! Incoming damage deflected
        is_invulnerable = true;
        shield_direction = 0;
        hsp = 0;
        state_timer++;
        if (state_timer > 60) {
            state = 3; // RECOVER
            state_timer = 0;
            is_invulnerable = false;
        }
        break;

    case 3: // RECOVER: Retracts spikes, vulnerable window before resuming patrol
        is_invulnerable = false;
        hsp = 0;
        state_timer++;
        if (state_timer > 20) {
            facing = -facing;
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
