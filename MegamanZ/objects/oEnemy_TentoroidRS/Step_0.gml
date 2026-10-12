event_inherited();
if (is_dead) return;

switch (state) {
    case 0: // CRAWL: Crawls on floor/platforms
        hsp = facing * 1.2;
        if (place_meeting(x + hsp, y, oSolid) || !place_meeting(x + facing * 16, y + 8, oSolid)) {
            facing = -facing;
            hsp = facing * 1.2;
        }
        x += hsp;
        
        if (target != noone && point_distance(x, y, target.x, target.y) < 140) {
            state = 1; // WINGS_OPEN
            state_timer = 0;
            facing = (target.x >= x) ? 1 : -1;
        }
        break;

    case 1: // WINGS_OPEN: Shell splits open, buzzing wings
        hsp = 0;
        state_timer++;
        if (state_timer > 20) {
            state = 2; // PINCER_RUSH
            state_timer = 0;
        }
        break;

    case 2: // PINCER_RUSH: Rapid rush forward with pincers
        hsp = facing * 2.8;
        if (place_meeting(x + hsp, y, oSolid)) {
            facing = -facing;
            state = 3; // RECOVER
            state_timer = 0;
        } else {
            x += hsp;
        }
        state_timer++;
        if (state_timer > 45) {
            state = 3;
            state_timer = 0;
        }
        break;

    case 3: // RECOVER: Retracts wings and resets
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
