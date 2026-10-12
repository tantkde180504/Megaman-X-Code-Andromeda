var _flash = (flash_timer > 0);
switch (state) {
    case 0: // Scan / Shield (Row 0, frames 0..2)
        var _scan = [[35,5,29,26], [75,5,29,26], [115,5,29,26]];
        var _fi = floor(anim_timer / 6) % 3;
        var _f = _scan[_fi];
        enemy_draw_part(Guardian_Sheet, _f[0], _f[1], _f[2], _f[3], x, y + 14, facing, _flash);
        break;

    case 1: // Charge (Row 0, frames 8..10)
        var _charge = [[310,8,32,26], [351,11,31,23], [394,13,20,20]];
        var _fi = floor(anim_timer / 3) % 3;
        var _f = _charge[_fi];
        enemy_draw_part(Guardian_Sheet, _f[0], _f[1], _f[2], _f[3], x, y + 14, facing, _flash);
        break;

    case 2: // Open Attack
    case 3: // Recover
        enemy_draw_part(Guardian_Sheet, 138, 46, 49, 37, x, y + 14, facing, _flash);
        break;
}
