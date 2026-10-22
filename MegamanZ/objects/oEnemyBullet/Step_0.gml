if (variable_global_exists("stage_ready") && !global.stage_ready) return;

x += hsp;
y += vsp;
life--;

if (life <= 0 || place_meeting(x, y, oSolid)) {
    instance_create_layer(x, y, "Instances", oFX_HitSpark);
    instance_destroy();
    return;
}

if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        player_take_damage(damage, (hsp >= 0) ? 1 : -1);
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
        instance_destroy();
        return;
    }
}
