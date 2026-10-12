// Hàng 5: Bom rơi xuống (Row 5, 3 frames)
var _bomb_frames = [
    [122, 126, 18, 32, 9, 16],
    [143, 126, 18, 32, 9, 16],
    [164, 126, 18, 32, 9, 16]
];
var _fi = floor(timer / 4) % 3;
var _f = _bomb_frames[_fi];
enemy_draw_sprite(Batton_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, 1, false);
