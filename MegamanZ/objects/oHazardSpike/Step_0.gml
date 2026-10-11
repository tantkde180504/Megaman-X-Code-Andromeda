if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone) {
        player_take_damage(4, -_p.facing);
    }
}
