var _flash = (flash_timer > 0);
// Mettaur D2 faces LEFT natively in sprite sheet, so flip when facing == 1
var _draw_facing = -facing;

switch (state) {
    case 0: // Guard: tucked under hard hat
        enemy_draw_sprite(MettaurD2_Sheet, 159, 12, 24, 23, 12, 23, x, y, _draw_facing, _flash);
        break;

    case 1: // Peek / Pop-up
        var _peek_frames = [
            [129, 5, 27, 30, 13, 30],
            [99, 3, 26, 31, 13, 31]
        ];
        var _fi = clamp(floor(state_timer / 10), 0, 1);
        var _f = _peek_frames[_fi];
        enemy_draw_sprite(MettaurD2_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 2: // Full 7-frame Buster Attack Sequence
        var _shoot_frames = [
            [35, 91, 28, 28, 14, 28],
            [69, 89, 25, 34, 12, 34],
            [105, 92, 29, 31, 14, 31], // Fire muzzle flash
            [144, 92, 27, 31, 13, 31],
            [180, 91, 26, 31, 13, 31],
            [214, 90, 27, 31, 13, 31],
            [248, 89, 26, 31, 13, 31]
        ];
        var _fi = clamp(floor(state_timer / 4), 0, 6);
        var _f = _shoot_frames[_fi];
        enemy_draw_sprite(MettaurD2_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;

    case 3: // Walk Shuffle (Row 1, 10 frames)
        var _walk_frames = [
            [4, 48, 25, 32, 12, 32],
            [33, 49, 25, 31, 12, 31],
            [66, 46, 24, 34, 12, 34],
            [97, 46, 24, 34, 12, 34],
            [128, 47, 25, 32, 12, 32],
            [160, 48, 25, 29, 12, 29],
            [192, 46, 25, 31, 12, 31],
            [223, 45, 25, 32, 12, 32],
            [254, 44, 25, 33, 12, 33],
            [283, 43, 26, 32, 13, 32]
        ];
        var _fi = floor(anim_timer / 4) % 10;
        var _f = _walk_frames[_fi];
        enemy_draw_sprite(MettaurD2_Sheet, _f[0], _f[1], _f[2], _f[3], _f[4], _f[5], x, y, _draw_facing, _flash);
        break;
}

