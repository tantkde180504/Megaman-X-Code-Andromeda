var _sheet = (beret_type == 1) ? KnotBeretG_Sheet : KnotBeretB_Sheet;
var _flash = (flash_timer > 0);

switch (state) {
    case 0: // March (7 frames)
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
        enemy_draw_sprite(_sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 1: // Aim
        enemy_draw_sprite(_sheet, 16, 80, 60, 49, 30, 49, x, y, facing, _flash);
        break;

    case 2: // Shoot
        enemy_draw_sprite(_sheet, 5, 142, 48, 49, 24, 49, x, y, facing, _flash);
        break;
}
