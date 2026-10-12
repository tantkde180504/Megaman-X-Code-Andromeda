var _flash = (flash_timer > 0);
switch (state) {
    case 0: // March patrol (Row 0, 7 frames)
        var _march = [
            [71,5,44,54], [121,5,44,54], [170,5,44,54], [226,5,44,54], [282,5,44,54], [340,4,41,55], [396,6,46,53]
        ];
        var _fi = floor(anim_timer / 5) % 7;
        var _f = _march[_fi];
        enemy_draw_part(KnotBeretG_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
        break;

    case 1: // Aim Rifle (Row 1: [13, 83, 60, 49])
        enemy_draw_part(KnotBeretG_Sheet, 13, 83, 60, 49, x, y, facing, _flash);
        break;

    case 2: // Fire Rifle recoil (Row 2: [2, 145, 48, 49])
        enemy_draw_part(KnotBeretG_Sheet, 2, 145, 48, 49, x, y, facing, _flash);
        break;

    case 3: // Recover (Row 0, frame 0)
        enemy_draw_part(KnotBeretG_Sheet, 11, 12, 54, 48, x, y, facing, _flash);
        break;
}
