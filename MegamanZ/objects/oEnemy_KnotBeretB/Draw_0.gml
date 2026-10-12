var _flash = (flash_timer > 0);

switch (state) {
    case 0: // March patrol (Row 0, 7 frames)
        var _march = [
            [74, 2, 44, 54, 22, 54],
            [124, 2, 44, 54, 22, 54],
            [173, 2, 44, 54, 22, 54],
            [229, 2, 44, 54, 22, 54],
            [285, 2, 44, 54, 22, 54],
            [343, 1, 41, 55, 20, 55],
            [399, 3, 46, 53, 23, 53]
        ];
        var _fi = floor(anim_timer / 5) % 7;
        var _f = _march[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 1: // Grenade Windup: Reaching into pouch and raising grenade (4 frames)
        var _windup = [
            [16, 80, 60, 49, 30, 49],
            [90, 80, 59, 48, 29, 48],
            [163, 62, 46, 66, 23, 66],
            [219, 62, 43, 66, 21, 66]
        ];
        var _fi = min(floor(state_timer / 6), 3);
        var _f = _windup[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 2: // Grenade Throw: Full arm swing follow-through (3 frames)
        var _throw = [
            [5, 142, 48, 49, 24, 49],
            [69, 140, 41, 51, 20, 51],
            [120, 137, 50, 54, 25, 54]
        ];
        var _fi = min(floor(state_timer / 8), 2);
        var _f = _throw[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 3: // Recover pose: Standing idle (Row 0, frame 0)
        enemy_draw_sprite(KnotBeretB_Sheet, 14, 9, 54, 48, 27, 48, x, y, facing, _flash);
        break;
}
