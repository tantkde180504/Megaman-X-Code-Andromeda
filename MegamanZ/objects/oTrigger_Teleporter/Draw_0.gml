var _pulse = 0.65 + 0.2 * sin(current_time * 0.004);
draw_set_color(make_color_rgb(35, 65, 100));
draw_ellipse(x - 20, y - 6, x + 20, y + 2, false);
draw_set_color(c_aqua);
draw_set_alpha(_pulse);
draw_ellipse(x - 14, y - 60, x + 14, y - 4, true);
draw_ellipse(x - 11, y - 57, x + 11, y - 7, true);
draw_set_alpha(0.18);
draw_ellipse(x - 10, y - 56, x + 10, y - 8, false);
draw_set_alpha(1);
draw_set_color(c_white);

if (instance_exists(oPlayer)) {
    var _p = instance_find(oPlayer, 0);
    if (abs(_p.x - x) < 64 && abs(_p.y - y) < 64 && destination_room == noone) {
        ps1_draw_centered(x, y - 76, "INACTIVE", 96, c_aqua);
    }
}
