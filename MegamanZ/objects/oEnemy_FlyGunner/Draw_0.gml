var _flash = (flash_timer > 0);
if (state == 0) {
    var _hover_frames = [
        [3, 6, 28, 27], [30, 6, 28, 27], [57, 8, 28, 25], [82, 5, 28, 28], [107, 6, 25, 27]
    ];
    var _fi = floor(anim_timer / 4) % 5;
    var _f = _hover_frames[_fi];
    enemy_draw_part(FlyGunner_Sheet, _f[0], _f[1], _f[2], _f[3], x, y + 14, facing, _flash);
} else {
    // Aim / firing frame from lower row
    var _f = (state_timer > 16 && state_timer < 26) ? [134, 36, 32, 29] : [4, 37, 31, 27];
    enemy_draw_part(FlyGunner_Sheet, _f[0], _f[1], _f[2], _f[3], x, y + 14, facing, _flash);
}
