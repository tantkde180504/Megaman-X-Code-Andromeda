var _flash = (flash_timer > 0);
if (state == 0) {
    // Normal roll (Row 2, 6 frames)
    var _patrol_frames = [
        [66,108,48,30], [123,109,45,29], [178,108,48,30], [235,108,48,30], [290,109,47,29], [347,109,46,29]
    ];
    var _fi = floor(anim_timer / 4) % 6;
    var _f = _patrol_frames[_fi];
    enemy_draw_part(SpikyMKII_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
} else if (state == 1) {
    // Fast high speed roll (Row 0, 6 frames)
    var _charge_frames = [
        [66,2,48,47], [122,3,47,45], [178,4,47,45], [234,2,47,47], [291,3,46,45], [346,3,47,45]
    ];
    var _fi = floor(anim_timer / 2) % 6;
    var _f = _charge_frames[_fi];
    enemy_draw_part(SpikyMKII_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
} else {
    // Spiked Defense / Recover (Row 1 frames)
    var _def_frames = [
        [226,61,48,29], [294,63,48,27], [354,63,48,27]
    ];
    var _fi = floor(anim_timer / 5) % 3;
    var _f = _def_frames[_fi];
    enemy_draw_part(SpikyMKII_Sheet, _f[0], _f[1], _f[2], _f[3], x, y, facing, _flash);
}
