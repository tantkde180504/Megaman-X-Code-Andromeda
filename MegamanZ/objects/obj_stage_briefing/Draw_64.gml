/// @desc Native 320x240 dialogue panel with X's idle/talking portrait.
if (!active) exit;
var _colour = draw_get_colour();
var _alpha = draw_get_alpha();
ps1_draw_panel(4, 112, 312, 124);
ps1_draw_panel(8, 116, 98, 116);
var _typing = visible_chars < string_length(pages[page_index]);
var _portrait_x = 196 + (_typing && (anim_timer div 6) mod 2 == 1 ? 98 : 0);
draw_sprite_part(Mugshots, 0, _portrait_x, 0, 94, 112, 10, 118);
ps1_draw_text(114, 118, "X", 194, 16, c_aqua);
ps1_draw_text(114, 142, pages[page_index], 194, 64, c_white, floor(visible_chars));
if (anim_timer mod 60 < 40) {
    ps1_draw_text(114, 218, _typing ? "ENTER: SHOW ALL" : "ENTER: NEXT", 194, 16, c_yellow);
}
draw_set_colour(_colour);
draw_set_alpha(_alpha);
