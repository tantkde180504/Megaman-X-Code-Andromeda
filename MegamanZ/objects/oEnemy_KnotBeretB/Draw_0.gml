var _flash = (flash_timer > 0);
var _draw_facing = -facing; // Sprite sheet natively faces LEFT, so negate facing

switch (state) {
    case 0: // IDLE (Row 1, 1 frame): Wait when player is not in range
        enemy_draw_sprite(KnotBeretB_Sheet, 14, 9, 54, 48, 27, 47, x, y, _draw_facing, _flash);
        break;

    case 1: // RUN (Row 3, 7 frames): Running towards player
        var _run_frames = [
            [5, 142, 48, 49, 24, 48],
            [69, 140, 41, 51, 20, 50],
            [120, 137, 50, 54, 25, 53],
            [182, 143, 45, 48, 22, 47],
            [254, 131, 46, 60, 23, 59],
            [317, 131, 48, 60, 24, 59],
            [384, 132, 46, 59, 23, 58]
        ];
        var _fi = floor(anim_timer / 4) % 7;
        var _f = _run_frames[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 2: // SHOOT_STRAIGHT (Row 2, first 2 frames): Shoot straight
        var _straight_frames = [
            [16, 80, 60, 49, 30, 48],
            [90, 80, 59, 48, 29, 48]
        ];
        var _fi = clamp(floor(state_timer / 10), 0, 1);
        var _f = _straight_frames[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 3: // SHOOT_DIAGONAL (Row 2, next 2 frames): Shoot diagonal
        var _diag_frames = [
            [163, 62, 46, 66, 23, 66],
            [219, 62, 43, 66, 21, 66]
        ];
        var _fi = clamp(floor(state_timer / 10), 0, 1);
        var _f = _diag_frames[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 4: // BOMB_THROW (Row 4, 7 frames): Bomb throw animation
        var _bomb_frames = [
            [10, 209, 44, 54, 22, 53],
            [66, 202, 46, 61, 23, 60],
            [125, 201, 47, 62, 23, 61],
            [183, 207, 59, 56, 29, 55],
            [256, 218, 63, 45, 31, 44],
            [334, 220, 55, 43, 27, 42],
            [401, 220, 55, 43, 27, 42]
        ];
        var _fi = clamp(floor(state_timer / 5), 0, 6);
        var _f = _bomb_frames[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 5: // CLIFF_PEEK (Row 5, first 2 frames): Ledge peek
        var _peek_frames = [
            [9, 276, 61, 50, 30, 49],
            [77, 276, 61, 50, 30, 49]
        ];
        var _fi = clamp(floor(state_timer / 12), 0, 1);
        var _f = _peek_frames[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 6: // CLIFF_JUMP (Row 5, next 2 frames): Ledge jump
        var _jump_frames = [
            [225, 271, 43, 55, 21, 54],
            [281, 285, 67, 41, 33, 40]
        ];
        var _fi = clamp(floor(state_timer / 6), 0, 1);
        var _f = _jump_frames[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 7: // FALL (Row 6, first 2 frames): Falling through air
        var _fall_frames = [
            [11, 334, 35, 59, 17, 58],
            [55, 331, 61, 62, 30, 61]
        ];
        var _fi = floor(anim_timer / 6) % 2;
        var _f = _fall_frames[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 8: // LAND (Row 6, next 3 frames): Landing impact crouch & rise
        var _land_frames = [
            [140, 347, 67, 46, 33, 45],
            [221, 342, 67, 51, 33, 50],
            [307, 345, 50, 48, 25, 47]
        ];
        var _fi = clamp(floor(state_timer / 5), 0, 2);
        var _f = _land_frames[_fi];
        enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;
}
