var _flash = (flash_timer > 0);

switch (state) {
    case 0: // Vertical Jet Hover: Hovers in place with bottom thruster pulsing blue flame
        var _hover = [
            [5, 8, 39, 52, 20, 26],
            [48, 8, 39, 52, 20, 26],
            [92, 8, 39, 41, 20, 20]
        ];
        var _fi = floor(anim_timer / 4) % 3;
        var _f = _hover[_fi];
        enemy_draw_sprite(TentoroidRS_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 1: // Alert & Shell Open: Red elytra shell opens showing warning boost
        var _open = [
            [140, 14, 43, 34, 21, 17],
            [189, 14, 56, 34, 28, 17]
        ];
        var _fi = clamp(floor(state_timer / 6), 0, 1);
        var _f = _open[_fi];
        enemy_draw_sprite(TentoroidRS_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 2: // Horizontal Rocket Boost Charge: Rear blue flame jets rocket forward!
        var _boost = [
            [29, 84, 54, 34, 27, 17],
            [92, 84, 57, 35, 28, 17],
            [156, 84, 63, 35, 31, 17]
        ];
        var _fi = floor(anim_timer / 3) % 3;
        var _f = _boost[_fi];
        enemy_draw_sprite(TentoroidRS_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 3: // Recover / Brake: Closes shell, resumes vertical hover
        enemy_draw_sprite(TentoroidRS_Sheet, 140, 14, 43, 34, 21, 17, x, y, facing, _flash);
        break;
}

