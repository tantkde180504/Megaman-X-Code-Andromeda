draw_self();

// Glow when activated
if (activated) {
    draw_set_color(make_color_rgb(100, 220, 255));
    draw_set_alpha(0.5);
    draw_circle(x, y - 24, 16, true);
    draw_set_alpha(1.0);
}

// Dr. Light Dialogue Banner
if (text_timer > 0) {
    var _cx = camera_get_view_x(view_camera[0]);
    var _cy = camera_get_view_y(view_camera[0]);
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_cx + 20, _cy + 20, _cx + VIEW_WIDTH - 20, _cy + 70, false);
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(100, 220, 255));
    draw_rectangle(_cx + 20, _cy + 20, _cx + VIEW_WIDTH - 20, _cy + 70, true);
    draw_text(_cx + 28, _cy + 26, "DR. LIGHT CAPSULE:");
    draw_set_color(c_white);
    draw_text(_cx + 28, _cy + 42, "Take this Leg Parts upgrade! Press DASH in mid-air to AIR DASH!");
}
