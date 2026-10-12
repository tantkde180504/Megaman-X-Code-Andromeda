/// @desc Beam Damage & Lifetime
if (!hit_done && instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        player_take_damage(damage, (_p.x >= x) ? 1 : -1);
        instance_create_layer(_p.x, _p.y - 12, "Instances", oFX_HitSpark);
        hit_done = true;
    }
}

if (image_index >= image_number - 0.5) {
    instance_destroy();
}
