var _flash = (flash_timer > 0);

switch (state) {
    case 0: // CEILING_PERCH: Hanging tight against ceiling, wings closed
        // If alert, eyes glow red (frame 20), else closed (frame 18)
        if (state_timer > 30) {
            enemy_draw_sprite(Batton_Sheet, 164, 126, 18, 32, 9, 0, x, y, facing, _flash);
        } else {
            enemy_draw_sprite(Batton_Sheet, 122, 126, 18, 32, 9, 0, x, y, facing, _flash);
        }
        break;

    case 1: // WAKE: Eyes open and wings spread downwards
        var _wake_frames = [
            [164, 126, 18, 32, 9, 0],
            [33, 43, 35, 43, 17, 15]
        ];
        var _fi = clamp(floor(state_timer / 10), 0, 1);
        var _f = _wake_frames[_fi];
        enemy_draw_sprite(Batton_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 2: // SWOOP_FLIGHT: 5-frame smooth wing flapping flight
    case 4: // RETURN_CEILING
        var _fly_frames = [
            [71, 55, 40, 31, 20, 15],
            [114, 55, 43, 31, 21, 15],
            [160, 57, 31, 29, 15, 14],
            [194, 57, 34, 32, 17, 16],
            [231, 57, 40, 29, 20, 14]
        ];
        var _fi = floor(anim_timer / 4) % 5;
        var _f = _fly_frames[_fi];
        enemy_draw_sprite(Batton_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 3: // BOMB_DROP: Claws open to release falling bomb
        enemy_draw_sprite(Batton_Sheet, 105, 6, 34, 31, 17, 15, x, y, facing, _flash);
        break;
}

