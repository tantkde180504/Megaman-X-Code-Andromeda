var _flash = (flash_timer > 0);
var _draw_facing = -facing; // Sprite sheet natively faces LEFT, so negate facing

switch (state) {
    case 0: // WAIT (Row 1, 4 frame đầu: 0..3): Đang đợi trong khi giữ bom
        var _wait_frames = [
            [7, 4, 47, 34, 23, 17],
            [57, 5, 45, 33, 22, 16],
            [105, 6, 34, 31, 17, 15],
            [142, 4, 42, 33, 21, 16]
        ];
        var _fi = floor(anim_timer / 6) % 4;
        var _f = _wait_frames[_fi];
        enemy_draw_sprite(Batton_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 1: // DROP_BOMB (Row 1, frame 5, 6: 4..5): Mở móng thả bom và bắt đầu bay
        var _release_frames = [
            [203, 5, 42, 32, 21, 16],
            [247, 6, 48, 31, 24, 15]
        ];
        var _fi = clamp(floor(state_timer / 7), 0, 1);
        var _f = _release_frames[_fi];
        enemy_draw_sprite(Batton_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 2: // SWOOP_FLIGHT (Row 2, 6 frames): Bay tự do lượn quanh phát hiện địch
        var _fly_frames = [
            [33, 43, 35, 43, 17, 21],
            [71, 55, 40, 31, 20, 15],
            [114, 55, 43, 31, 21, 15],
            [160, 57, 31, 29, 15, 14],
            [194, 57, 34, 32, 17, 16],
            [231, 57, 40, 29, 20, 14]
        ];
        var _fi = floor(anim_timer / 4) % 6;
        var _f = _fly_frames[_fi];
        enemy_draw_sprite(Batton_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 3: // DESTROYED (Row 3: đầu rơi, Row 4: nổ tan xác): Khi bị tiêu diệt
        // Row 4: Vụ nổ tan xác (4 frames)
        var _exp_frames = [
            [114, 109, 14, 11, 7, 5],
            [130, 110, 14, 13, 7, 6],
            [149, 111, 8, 9, 4, 4],
            [161, 111, 20, 12, 10, 6]
        ];
        var _exp_fi = min(floor(state_timer / 5), 3);
        var _ef = _exp_frames[_exp_fi];
        enemy_draw_sprite(Batton_Sheet, _ef[0], _ef[1], _ef[2], _ef[3], _ef[4], _ef[5], x, y, 1, false);
        
        // Row 3: Đầu lâu robot rơi xuống (2 frames)
        var _skull_frames = [
            [136, 93, 13, 13, 6, 6],
            [153, 93, 13, 13, 6, 6]
        ];
        var _sk_fi = floor(state_timer / 4) % 2;
        var _sk = _skull_frames[_sk_fi];
        enemy_draw_sprite(Batton_Sheet, _sk[0], _sk[1], _sk[2], _sk[3], _sk[4], _sk[5], skull_x, skull_y, _draw_facing, false);
        break;
}
