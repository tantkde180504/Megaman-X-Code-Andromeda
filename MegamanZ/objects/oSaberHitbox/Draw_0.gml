// In normal gameplay, do not draw the mask sprite over Zero's animation
// Only render debug hitbox visualization when F1 debug overlay is active
if (variable_global_exists("debug_overlay") && global.debug_overlay && is_active) {
    draw_set_color(make_color_rgb(40, 255, 120)); // Saber Green
    draw_set_alpha(0.35);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_color(c_white);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_alpha(1.0);
}
