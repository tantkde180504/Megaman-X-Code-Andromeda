// Draw frame
draw_set_color(make_color_rgb(50, 60, 75));
draw_rectangle(x - 2, y, x + 18, y + 48, false);

// Draw door slider
draw_sprite(sprite_index, 0, x, y + door_y);
