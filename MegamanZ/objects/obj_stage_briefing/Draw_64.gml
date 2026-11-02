/// @desc X4 dialogue: centered portrait above a blue, silver-edged two-line box.
if (!active) exit;
var _colour = draw_get_colour();
var _alpha = draw_get_alpha();
var _open = closing ? 1 - clamp(close_frame / 10, 0, 1) : clamp(panel_frame / 12, 0, 1);
_open = 1 - power(1 - _open, 2);
draw_set_alpha(1);

var _half_h = max(1, round(34 * _open));
var _top = 172 - _half_h;
var _bottom = 172 + _half_h;
draw_set_colour(make_colour_rgb(222, 246, 255));
draw_rectangle(30, _top, 282, _bottom, false);
draw_set_colour(make_colour_rgb(72, 132, 176));
draw_rectangle(31, _top + 1, 281, _bottom - 1, false);
if (_half_h > 2) {
    draw_rectangle_colour(32, _top + 2, 280, _bottom - 2,
        make_colour_rgb(0, 46, 80), make_colour_rgb(0, 46, 80),
        make_colour_rgb(0, 12, 38), make_colour_rgb(0, 12, 38), false);
}

var _typing = !closing && panel_frame >= 12 && visible_chars < string_length(pages[page_index]);
// Use the isolated large portrait, avoiding the neighboring faces in the atlas.
var _portrait_h = max(1, round(94 * _open));
var _portrait_top = 26 + round((94 - _portrait_h) * 0.5);
var _face_sx = 112 / 98;
var _face_sy = _portrait_h / 94;
draw_set_alpha(_open);
draw_rectangle_colour(104, _portrait_top, 216, _portrait_top + _portrait_h,
    make_colour_rgb(68, 24, 6), make_colour_rgb(116, 38, 0),
    make_colour_rgb(190, 70, 0), make_colour_rgb(96, 26, 0), false);
if (speaker_is_zero) {
    // Zero's two 94x112 portraits occupy the top row of the shared atlas.
    var _zero_src = (_typing && (anim_timer div 6) mod 2 == 1) ? 490 : 392;
    var _zero_scale = _portrait_h / 112;
    draw_sprite_part_ext(Mugshots, 0, _zero_src, 0, 94, 112,
        160 - 47 * _zero_scale, _portrait_top, _zero_scale, _zero_scale, c_white, _open);
} else {
    draw_sprite_part_ext(Mugshots, 0, 136, 128, 98, 94,
        104, _portrait_top, _face_sx, _face_sy, c_white, _open);
}
if (!speaker_is_zero && _typing && (anim_timer div 6) mod 2 == 1) {
    // The separate open mouth aligns with the unchanged nose pixels at (180,171).
    draw_sprite_part_ext(Mugshots, 0, 168, 220, 43, 28,
        104 + 44 * _face_sx, _portrait_top + 43 * _face_sy,
        _face_sx, _face_sy, c_white, _open);
}
draw_set_alpha(1);

if (!closing && panel_frame >= 12) {
    draw_mmx_text(40, 142, speaker_name, MMX_FONT.MEDIUM);
    ps1_draw_text(40, 160, pages[page_index], 240, 32, c_white, floor(visible_chars), 1, MMX_FONT.MEDIUM);
    if (!_typing && anim_timer mod 40 < 24) {
        draw_set_colour(c_white);
        draw_triangle(270, 198, 276, 198, 273, 202, false);
    }
}
draw_set_colour(_colour);
draw_set_alpha(_alpha);
