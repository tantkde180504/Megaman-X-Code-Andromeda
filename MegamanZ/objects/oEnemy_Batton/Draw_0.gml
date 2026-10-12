var _flash = (flash_timer > 0);
switch (state) {
    case 0: // Perch (Row 4, frame 0)
        enemy_draw_part(Batton_Sheet, 122, 126, 18, 32, x, y, facing, _flash);
        break;

    case 1: // Wake (Row 1, frame 0)
        enemy_draw_part(Batton_Sheet, 33, 43, 35, 43, x, y, facing, _flash);
        break;

    case 2: // Flight
    case 4: // Return
        var _fly_frames = [
            [71,55,40,31], [114,55,43,31], [160,57,31,29], [194,57,34,32], [231,57,40,29]
        ];
        var _fi = floor(anim_timer / 4) % 5;
        var _f = _fly_frames[_fi];
        enemy_draw_part(Batton_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
        break;

    case 3: // Bomb Drop pose (Row 0: [105, 6, 34, 31])
        enemy_draw_part(Batton_Sheet, 105, 6, 34, 31, x, y, facing, _flash);
        break;
}
