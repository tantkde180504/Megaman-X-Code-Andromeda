var _flash = (flash_timer > 0);
switch (state) {
    case 0: // Guard
        enemy_draw_part(MettaurD2_Sheet, 159, 12, 24, 23, x, y, facing, _flash);
        break;
    case 1: // Peek
        enemy_draw_part(MettaurD2_Sheet, 129, 5, 27, 30, x, y, facing, _flash);
        break;
    case 2: // Shoot
        enemy_draw_part(MettaurD2_Sheet, 105, 92, 29, 31, x, y, facing, _flash);
        break;
    case 3: // Walk (10 frames)
        var _walk_frames = [
            [4,48,25,32], [33,49,25,31], [66,46,24,34], [97,46,24,34], [128,47,25,32],
            [160,48,25,29], [192,46,25,31], [223,45,25,32], [254,44,25,33], [283,43,26,32]
        ];
        var _fi = floor(anim_timer / 4) % 10;
        var _f = _walk_frames[_fi];
        enemy_draw_part(MettaurD2_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
        break;
}
