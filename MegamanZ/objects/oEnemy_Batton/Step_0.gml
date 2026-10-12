event_inherited();
if (hp <= 0) return;

switch (state) {
    case 0: // HANG on ceiling
        is_deflecting = true;
        hsp = 0; vsp = 0;
        if (instance_exists(oPlayer) && abs(oPlayer.x - x) < 140 && oPlayer.y > y) {
            state = 1;
            state_timer = 0;
            is_deflecting = false;
        }
        break;

    case 1: // WAKE / unfurl
        is_deflecting = false;
        state_timer++;
        if (state_timer > 20) {
            state = 2;
            state_timer = 0;
            start_y = y;
            if (instance_exists(oPlayer)) facing = (oPlayer.x >= x) ? 1 : -1;
        }
        break;

    case 2: // SWOOP flight
        is_deflecting = false;
        if (instance_exists(oPlayer)) facing = (oPlayer.x >= x) ? 1 : -1;
        hsp = facing * 1.8;
        vsp = sin(anim_timer * 0.12) * 2.2;
        x += hsp;
        y += vsp;
        state_timer++;
        if (state_timer > 140) {
            state = 3;
            state_timer = 0;
        }
        break;

    case 3: // RETURN up to ceiling
        is_deflecting = false;
        vsp = -1.6;
        y += vsp;
        if (place_meeting(x, y - 6, oSolid) || y <= start_y) {
            state = 0;
            state_timer = 0;
            is_deflecting = true;
        }
        break;
}
