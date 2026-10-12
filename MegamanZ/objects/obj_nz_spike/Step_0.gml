/// @desc Spike Animation & Damage Check
// Gây sát thương khi gai nhô cao (frame 2 đến 4)
if (image_index >= 2 && image_index <= 4.5 && !hit_done) {
    if (instance_exists(oPlayer)) {
        var _p = instance_place(x, y, oPlayer);
        if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
            player_take_damage(damage, (_p.x >= x) ? 1 : -1);
            instance_create_layer(_p.x, _p.y - 12, "Instances", oFX_HitSpark);
            hit_done = true;
        }
    }
}

// Tự hủy khi diễn hoạt hết 6 frame
if (image_index >= 5.8) {
    instance_destroy();
}
