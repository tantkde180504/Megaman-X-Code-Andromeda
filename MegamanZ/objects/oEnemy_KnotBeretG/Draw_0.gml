var _flash = (flash_timer > 0);

switch (state) {
    case 0: // March patrol (Row 0, 7 frames)
        var _march = [
            [71, 5, 44, 54, 22, 54],
            [121, 5, 44, 54, 22, 54],
            [170, 5, 44, 54, 22, 54],
            [226, 5, 44, 54, 22, 54],
            [282, 5, 44, 54, 22, 54],
            [340, 4, 41, 55, 20, 55],
            [396, 6, 46, 53, 23, 53]
        ];
        var _fi = floor(anim_timer / 5) % 7;
        var _f = _march[_fi];
        enemy_draw_sprite(KnotBeretG_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 1: // Aim Rifle: Raise and level weapon (Row 1, 2 frames)
        var _aim = [
            [13, 83, 60, 49, 30, 49],
            [87, 83, 59, 48, 29, 48]
        ];
        var _fi = min(floor(state_timer / 9), 1);
        var _f = _aim[_fi];
        enemy_draw_sprite(KnotBeretG_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 2: // Fire Rifle recoil kickback (Row 2, 3 frames)
        var _recoil = [
            [2, 145, 48, 49, 24, 49],
            [66, 143, 41, 51, 20, 51],
            [117, 140, 50, 54, 25, 54]
        ];
        var _t = (state_timer < 16) ? state_timer : (state_timer - 16);
        var _fi = min(floor(_t / 5), 2);
        var _f = _recoil[_fi];
        enemy_draw_sprite(KnotBeretG_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 3: // Recover (Row 0, frame 0)
        enemy_draw_sprite(KnotBeretG_Sheet, 11, 12, 54, 48, 27, 48, x, y, facing, _flash);
        break;
}
