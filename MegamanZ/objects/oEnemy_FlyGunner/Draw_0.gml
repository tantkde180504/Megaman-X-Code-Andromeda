var _flash = (flash_timer > 0);
if (state == 0 || state == 3) {
    var _hover_frames = [
        [3, 6, 28, 27], [30, 6, 28, 27], [57, 8, 28, 25], [82, 5, 28, 28], [107, 6, 25, 27]
    ];
    var _fi = floor(anim_timer / 4) % 5;
    var _f = _hover_frames[_fi];
    enemy_draw_part(FlyGunner_Sheet, _f[0], _f[1], _f[2], _f[3], x, y + 14, facing, _flash);
} else if (state == 1) {
    // Aim cannon
    enemy_draw_part(FlyGunner_Sheet, 4, 37, 31, 27, x, y + 14, facing, _flash);
} else if (state == 2) {
    // Fire muzzle flash
    enemy_draw_part(FlyGunner_Sheet, 134, 36, 32, 29, x, y + 14, facing, _flash);
}
