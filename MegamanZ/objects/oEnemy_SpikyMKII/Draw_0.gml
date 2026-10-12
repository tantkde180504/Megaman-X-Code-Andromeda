var _flash = (flash_timer > 0);

switch (state) {
    case 0: // Normal Patrol Roll (Row 2, 6 frames)
        var _patrol_frames = [
            [66, 108, 48, 30, 24, 30],
            [123, 109, 45, 29, 22, 29],
            [178, 108, 48, 30, 24, 30],
            [235, 108, 48, 30, 24, 30],
            [290, 109, 47, 29, 23, 29],
            [347, 109, 46, 29, 23, 29]
        ];
        var _fi = floor(anim_timer / 4) % 6;
        var _f = _patrol_frames[_fi];
        enemy_draw_sprite(SpikyMKII_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 1: // Alert & Deploy Spikes Transition (Row 1, 4 frames)
        var _deploy_frames = [
            [9, 56, 39, 40, 20, 40],
            [61, 56, 33, 40, 16, 40],
            [170, 56, 42, 31, 21, 31],
            [226, 61, 48, 29, 24, 29]
        ];
        var _fi = clamp(floor(state_timer / 4), 0, 3);
        var _f = _deploy_frames[_fi];
        enemy_draw_sprite(SpikyMKII_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 2: // High-Speed Lethal Spike Charge (Row 0, 6 frames)
        var _charge_frames = [
            [66, 2, 48, 47, 24, 47],
            [122, 3, 47, 45, 23, 45],
            [178, 4, 47, 45, 23, 45],
            [234, 2, 47, 47, 23, 47],
            [291, 3, 46, 45, 23, 45],
            [346, 3, 47, 45, 23, 45]
        ];
        var _fi = floor(anim_timer / 2) % 6;
        var _f = _charge_frames[_fi];
        enemy_draw_sprite(SpikyMKII_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;

    case 3: // Retract Spikes & Recover (Row 1 reversed)
        var _retract_frames = [
            [226, 61, 48, 29, 24, 29],
            [170, 56, 42, 31, 21, 31],
            [61, 56, 33, 40, 16, 40],
            [9, 56, 39, 40, 20, 40]
        ];
        var _fi = clamp(floor(state_timer / 4), 0, 3);
        var _f = _retract_frames[_fi];
        enemy_draw_sprite(SpikyMKII_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, facing, _flash);
        break;
}

