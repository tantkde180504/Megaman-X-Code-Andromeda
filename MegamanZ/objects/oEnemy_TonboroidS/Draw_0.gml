var _flash = (flash_timer > 0);

switch (state) {
    case 0: // FLY_PATROL: Rapid translucent wing flutter with claws forward (Row 0, 4 ping-pong frames)
        var _fly = [
            [1, 16, 66, 37, 33, 18],
            [72, 11, 66, 42, 33, 21],
            [143, 6, 64, 47, 32, 23],
            [72, 11, 66, 42, 33, 21]
        ];
        var _fi = floor(anim_timer / 3) % 4;
        var _f = _fly[_fi];
        enemy_draw_sprite(TonboroidS_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 1: // SWOOP_APPROACH: Aerodynamic horizontal glide with tucked claws (Row 1, 4 ping-pong frames)
        var _glide = [
            [1, 89, 66, 27, 33, 13],
            [72, 84, 66, 32, 33, 16],
            [143, 79, 64, 37, 32, 18],
            [72, 84, 66, 32, 33, 16]
        ];
        var _fi = floor(anim_timer / 3) % 4;
        var _f = _glide[_fi];
        enemy_draw_sprite(TonboroidS_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 2: // DROP_BOMB: Tail curved down release (Row 3, 3 frames)
        var _drop = [
            [105, 243, 81, 52, 40, 26],
            [191, 238, 81, 57, 40, 28],
            [277, 233, 81, 62, 40, 31]
        ];
        var _fi = min(floor(state_timer / 6), 2);
        var _f = _drop[_fi];
        enemy_draw_sprite(TonboroidS_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 3: // RETURN: Climbing back up (Row 2, 4 ping-pong frames)
        var _climb = [
            [1, 154, 74, 36, 37, 18],
            [80, 149, 74, 41, 37, 20],
            [159, 144, 74, 46, 37, 23],
            [80, 149, 74, 41, 37, 20]
        ];
        var _fi = floor(anim_timer / 3) % 4;
        var _f = _climb[_fi];
        enemy_draw_sprite(TonboroidS_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;
}
