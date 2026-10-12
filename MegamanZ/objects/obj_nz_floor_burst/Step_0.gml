/// @desc Shockwave Burst Collision & Lifetime
if (image_index >= 1 && image_index <= 3.5 && !hit_done) {
    if (instance_exists(oPlayer)) {
        var _p = instance_place(x, y, oPlayer);
        if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
            player_take_damage(damage, (_p.x >= x) ? 1 : -1);
            instance_create_layer(_p.x, _p.y - 10, "Instances", oFX_HitSpark);
            hit_done = true;
        }
    }
}

if (image_index >= 4.8) {
    instance_destroy();
}
