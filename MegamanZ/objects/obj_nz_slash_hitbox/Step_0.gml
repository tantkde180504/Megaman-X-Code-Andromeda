/// @desc Hitbox Lifetime & Collision
life--;
if (life <= 0) {
    instance_destroy();
    return;
}

if (!hit_done && instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        var _dir = 1;
        if (source_boss != noone && instance_exists(source_boss)) {
            _dir = source_boss.facing;
        } else {
            _dir = (_p.x >= x) ? 1 : -1;
        }
        player_take_damage(damage, _dir);
        instance_create_layer(_p.x, _p.y - 16, "Instances", oFX_HitSpark);
        hit_done = true;
    }
}
