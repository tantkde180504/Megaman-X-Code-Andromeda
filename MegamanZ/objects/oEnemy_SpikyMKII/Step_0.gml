event_inherited();
if (hp <= 0) return;

switch (state) {
    case 0: // PATROL
        hsp = facing * 1.4;
        
        // Turn around on wall or pit ledge
        if (place_meeting(x + hsp, y, oSolid) || !place_meeting(x + facing * 16, y + 8, oSolid)) {
            facing = -facing;
            hsp = facing * 1.4;
        }
        x += hsp;
        
        // Check player in sight to charge!
        if (instance_exists(oPlayer) && abs(oPlayer.y - y) < 32 && (oPlayer.x - x) * facing > 0 && abs(oPlayer.x - x) < 180) {
            state = 1;
            state_timer = 0;
            camera_shake(1, 4);
        }
        break;

    case 1: // HIGH SPEED CHARGE
        hsp = facing * 3.8;
        if (state_timer % 8 == 0) {
            instance_create_layer(x, y, "Instances", oFX_DashDust);
        }
        
        if (place_meeting(x + hsp, y, oSolid)) {
            facing = -facing;
            state = 0;
            state_timer = 0;
            camera_shake(2, 6);
        } else {
            x += hsp;
        }
        
        state_timer++;
        if (state_timer > 90) {
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
