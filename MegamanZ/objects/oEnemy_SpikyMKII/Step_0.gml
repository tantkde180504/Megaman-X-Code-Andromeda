event_inherited();
if (is_dead || stage_frozen) return;

switch (state) {
    case 0: // PATROL_ROLL: Smooth rolling along floor
        is_invulnerable = false;
        shield_direction = 0;
        hsp = facing * 1.4;
        
        if (place_meeting(x + hsp, y, oSolid) || !place_meeting(x + facing * 16, y + 8, oSolid)) {
            facing = -facing;
            hsp = facing * 1.4;
        }
        x += hsp;
        
        // Spot player in front
        if (target != noone && abs(target.y - y) < 32 && (target.x - x) * facing > 0 && abs(target.x - x) < 200) {
            state = 1; // ALERT_DEPLOY
            state_timer = 0;
            camera_shake(1, 4);
        }
        break;

    case 1: // ALERT_DEPLOY: Pauses and expands spikes outward
        is_invulnerable = false;
        hsp = 0;
        state_timer++;
        if (state_timer >= 16) {
            state = 2; // SPIKE_CHARGE
            state_timer = 0;
        }
        break;

    case 2: // SPIKE_CHARGE: Fast lethal rolling charge with spikes out (frontal deflection active!)
        is_invulnerable = false;
        shield_direction = 1; // Frontal spikes deflect buster shots!
        hsp = facing * 4.0;
        if (state_timer % 6 == 0) instance_create_layer(x, y, "Instances", oFX_DashDust);
        
        if (place_meeting(x + hsp, y, oSolid)) {
            // Impact with wall
            state = 3; // RECOVER
            state_timer = 0;
            camera_shake(2, 6);
        } else {
            x += hsp;
        }
        
        state_timer++;
        if (state_timer > 70) {
            state = 3; // RECOVER
            state_timer = 0;
        }
        break;

    case 3: // RECOVER: Retracts spikes back into shell, vulnerable window
        is_invulnerable = false;
        shield_direction = 0;
        hsp = 0;
        state_timer++;
        if (state_timer >= 16) {
            facing = -facing;
            state = 0; // Back to normal patrol
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
