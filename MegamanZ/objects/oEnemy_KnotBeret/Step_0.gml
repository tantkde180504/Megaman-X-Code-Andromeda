event_inherited();
if (hp <= 0) return;

switch (state) {
    case 0: // PATROL MARCH
        hsp = facing * 1.0;
        if (place_meeting(x + hsp, y, oSolid) || !place_meeting(x + facing * 16, y + 8, oSolid)) {
            facing = -facing;
            hsp = facing * 1.0;
        }
        x += hsp;
        
        // Spot player in front
        if (instance_exists(oPlayer) && abs(oPlayer.y - y) < 48 && (oPlayer.x - x) * facing > 0 && abs(oPlayer.x - x) < 220) {
            state = 1;
            state_timer = 0;
        }
        break;

    case 1: // AIM RIFLE
        hsp = 0;
        state_timer++;
        if (state_timer > 18) {
            state = 2;
            state_timer = 0;
        }
        break;

    case 2: // FIRE RIFLE SHOTS
        hsp = 0;
        state_timer++;
        if (state_timer == 2 || state_timer == 14) {
            var _b = instance_create_layer(x + facing * 24, y - 26, "Instances", oEnemyBullet);
            _b.hsp = facing * 3.6;
            _b.vsp = 0;
            camera_shake(1, 3);
        }
        if (state_timer > 36) {
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
