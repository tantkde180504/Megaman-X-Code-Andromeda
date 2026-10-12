event_inherited();
if (hp <= 0) return;

switch (state) {
    case 0: // CRAWL
        hsp = facing * 1.2;
        if (place_meeting(x + hsp, y, oSolid) || !place_meeting(x + facing * 16, y + 8, oSolid)) {
            facing = -facing;
            hsp = facing * 1.2;
        }
        x += hsp;
        
        if (instance_exists(oPlayer) && point_distance(x, y, oPlayer.x, oPlayer.y) < 140) {
            state = 1;
            state_timer = 0;
        }
        break;

    case 1: // WING BUZZ & DASH
        hsp = facing * 2.8;
        if (place_meeting(x + hsp, y, oSolid)) {
            facing = -facing;
            state = 0;
            state_timer = 0;
        } else {
            x += hsp;
        }
        
        state_timer++;
        if (state_timer > 45) {
            state = 0;
            state_timer = 0;
            facing = -facing;
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
