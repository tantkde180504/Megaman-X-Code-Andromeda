/// @desc Web Net Step
if (!stuck) {
    vsp = min(vsp + 0.15, 3.0);
    x += hsp;
    y += vsp;
    if (place_meeting(x, y + 1, oSolid) || place_meeting(x + sign(hsp), y, oSolid)) {
        stuck = true;
        hsp = 0;
        vsp = 0;
    }
}

scale = min(1.0, scale + 0.05);
timer--;
if (timer <= 0) {
    instance_destroy();
    return;
}

// Slow down and damage player if caught in web net
if (instance_exists(oPlayer)) {
    var _p = instance_nearest(x, y, oPlayer);
    if (place_meeting(x, y, _p)) {
        _p.hsp *= 0.7;
        if (_p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
            player_take_damage(damage, 0);
        }
    }
}
