var _flash = (flash_timer > 0);
switch (state) {
    case 0: // March patrol (Row 0, 7 frames)
        var _march = [
            [74,2,44,54], [124,2,44,54], [173,2,44,54], [229,2,44,54], [285,2,44,54], [343,1,41,55], [399,3,46,53]
        ];
        var _fi = floor(anim_timer / 5) % 7;
        var _f = _march[_fi];
        enemy_draw_part(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
        break;

    case 1: // Grenade Windup (Row 1, frame 2: [163,62,46,66])
        enemy_draw_part(KnotBeretB_Sheet, 163, 62, 46, 66, x, y, facing, _flash);
        break;

    case 2: // Grenade Throw follow-through (Row 1, frame 3: [219,62,43,66])
        enemy_draw_part(KnotBeretB_Sheet, 219, 62, 43, 66, x, y, facing, _flash);
        break;

    case 3: // Recover pose (Row 0, frame 0)
        enemy_draw_part(KnotBeretB_Sheet, 14, 9, 54, 48, x, y, facing, _flash);
        break;
}
