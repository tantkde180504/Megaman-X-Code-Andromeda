vsp += grav;
if (place_meeting(x, y + vsp, oSolid)) {
    while (!place_meeting(x, y + sign(vsp), oSolid)) y += sign(vsp);
    if (vsp > 1.0) vsp = -vsp * 0.45; else vsp = 0;
    grounded = true;
    hsp *= 0.8;
}
y += vsp;

if (place_meeting(x + hsp, y, oSolid)) {
    hsp = -hsp * 0.5;
}
x += hsp;

life--;
if (life <= 0) {
    instance_destroy();
    return;
}

if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.state != PLAYER_STATE.DEATH) {
        _p.hp_current = _p.hp_max;
        var _snd_1up = audio_exists(snd_pickup_1up) ? snd_pickup_1up : snd_pickup_life;
        if (audio_exists(_snd_1up)) audio_play_sound(_snd_1up, 90, false);
        camera_shake(2, 8);
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
        instance_destroy();
    }
}
