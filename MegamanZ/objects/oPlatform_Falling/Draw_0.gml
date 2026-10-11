if (fall_timer > 0 && !falling) {
    var _shk = (fall_timer % 4 < 2) ? -1 : 1;
    draw_sprite(sprite_index, 0, x + _shk, y);
} else {
    draw_self();
}
