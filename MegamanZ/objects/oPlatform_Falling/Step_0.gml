if (!falling) {
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        if (_p.grounded && place_meeting(x, y - 1, _p)) {
            fall_timer++;
            if (fall_timer >= 22) {
                falling = true;
            }
        }
    }
} else {
    vsp += 0.25;
    y += vsp;
    if (y > room_height + 32) {
        respawn_timer++;
        if (respawn_timer >= 120) {
            x = orig_x;
            y = orig_y;
            falling = false;
            vsp = 0;
            fall_timer = 0;
            respawn_timer = 0;
        }
    }
}
