var _colour = draw_get_colour();
var _alpha = draw_get_alpha();
draw_set_colour(c_black);
draw_set_alpha(fade_alpha);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
if (phase == 1) {
    draw_set_alpha(1);
    ps1_draw_centered(160, 96, "JUNGLE", 288, c_aqua);
    ps1_draw_centered(160, 120, "ZERO", 288, c_white);
    var _dots = string_repeat(".", 1 + (phase_tick div 15) mod 3);
    ps1_draw_centered(160, 200, "LOADING" + _dots, 288, c_white);
}
draw_set_colour(_colour);
draw_set_alpha(_alpha);
