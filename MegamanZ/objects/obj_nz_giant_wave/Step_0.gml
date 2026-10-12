/// @desc Giant Wave Movement & Damage
x += hsp;
life--;
image_xscale = (hsp >= 0) ? -1 : 1;

if (life <= 0 || x < -100 || x > room_width + 100) {
    instance_destroy();
    return;
}

if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        player_take_damage(damage, (hsp >= 0) ? 1 : -1);
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
    }
}
