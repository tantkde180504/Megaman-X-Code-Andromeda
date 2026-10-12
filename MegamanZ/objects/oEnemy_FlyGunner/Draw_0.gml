var _flash = (flash_timer > 0);

switch (state) {
    case 0: // Hover Patrol (Row 0, 4 hover frames)
        var _hover_frames = [
            [3, 6, 24, 27, 12, 14],
            [30, 6, 24, 27, 12, 14],
            [57, 8, 22, 25, 11, 13],
            [107, 6, 25, 27, 12, 14]
        ];
        var _fi = floor(anim_timer / 6) % 4;
        var _f = _hover_frames[_fi];
        enemy_draw_sprite(FlyGunner_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 1: // Aim Tracking: Adjusts cannon angle based on player altitude
        if (target != noone && target.y > y + 32) {
            // Aim downwards
            enemy_draw_sprite(FlyGunner_Sheet, 82, 5, 22, 28, 11, 14, x, y, facing, _flash);
        } else {
            // Aim level forward
            enemy_draw_sprite(FlyGunner_Sheet, 4, 37, 23, 27, 11, 14, x, y, facing, _flash);
        }
        break;

    case 2: // Fire: Cannon blast with muzzle flash
        enemy_draw_sprite(FlyGunner_Sheet, 134, 36, 32, 30, 16, 15, x, y, facing, _flash);
        break;

    case 3: // Recoil / Recover
        enemy_draw_sprite(FlyGunner_Sheet, 30, 38, 24, 26, 12, 13, x, y, facing, _flash);
        break;
}

