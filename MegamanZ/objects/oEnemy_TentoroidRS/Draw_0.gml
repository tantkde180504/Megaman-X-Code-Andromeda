var _flash = (flash_timer > 0);
if (state == 0) {
    var _crawl = [[5,8,39,57], [48,8,39,54], [92,8,39,65]];
    var _fi = floor(anim_timer / 6) % 3;
    var _f = _crawl[_fi];
    enemy_draw_part(TentoroidRS_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
} else if (state == 1) {
    var _wings = [[140,14,43,34], [189,14,56,34]];
    var _fi = floor(anim_timer / 3) % 2;
    var _f = _wings[_fi];
    enemy_draw_part(TentoroidRS_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
} else {
    // Pincer rush (Row 1)
    var _rush = [[29,84,54,34], [92,84,57,35], [156,84,63,35]];
    var _fi = floor(anim_timer / 4) % 3;
    var _f = _rush[_fi];
    enemy_draw_part(TentoroidRS_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
}
