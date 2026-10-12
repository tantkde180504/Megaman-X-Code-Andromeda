var _flash = (flash_timer > 0);
if (state == 0 || state == 3) {
    var _fly = [[1,16,66,37], [72,11,66,42], [143,6,64,47]];
    var _fi = floor(anim_timer / 3) % 3;
    var _f = _fly[_fi];
    enemy_draw_part(TonboroidS_Sheet, _f[0], _f[1], _f[2], _f[3], x, y + 16, facing, _flash);
} else if (state == 1) {
    var _swoop = [[1,89,66,27], [72,84,66,32], [143,79,64,37]];
    var _fi = floor(anim_timer / 3) % 3;
    var _f = _swoop[_fi];
    enemy_draw_part(TonboroidS_Sheet, _f[0], _f[1], _f[2], _f[3], x, y + 16, facing, _flash);
} else {
    // Tail drop frame
    var _drop = [[105,243,81,52], [191,238,81,57], [277,233,81,62]];
    var _fi = floor(state_timer / 8) % 3;
    var _f = _drop[_fi];
    enemy_draw_part(TonboroidS_Sheet, _f[0], _f[1], _f[2], _f[3], x, y + 16, facing, _flash);
}
