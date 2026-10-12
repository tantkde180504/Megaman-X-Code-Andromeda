// 4 spinning grenade frames from KnotBeretB_Sheet Row 1
var _gf = [
    [285, 93, 12, 11], [300, 93, 12, 11], [315, 93, 12, 11], [330, 93, 12, 11]
];
var _idx = floor(timer / 4) % 4;
var _f = _gf[_idx];
enemy_draw_sprite(KnotBeretB_Sheet, _f[0], _f[1], _f[2], _f[3], 6, 6, x, y, 1, false);
