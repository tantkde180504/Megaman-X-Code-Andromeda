/// @desc GUI-space READY animation, independent of camera position.
var _t = max(0, ready_frame);
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _cx = round(_gui_w * 0.5);
var _cy = round(_gui_h * 0.5);
if (auto_gui_scale) {
    gui_scale = max(1, floor(min(_gui_w / 320, _gui_h / 240)));
}
var _s = gui_scale;
var _filter = gpu_get_texfilter();
gpu_set_texfilter(false);
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);

// Phase 0 overlaps the incoming text. Bars remain until frame 40.
if (_t < 40) {
    var _open = clamp(_t / 15, 0, 1);
    var _ease = 1 - power(1 - _open, 3);
    var _bar_alpha = 0.55 * clamp(_t / 6, 0, 1);
    if (_t >= 25) _bar_alpha *= 1 - clamp((_t - 25) / 15, 0, 1);
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(ready_sprite, 4, _cx, _cy, _s, _s * lerp(0.04, 1, _ease), 0, c_white, _bar_alpha);

    // A travelling white core with a blue-violet halo.
    if (_t <= 15) {
        var _laser_x = lerp(-_gui_w * 0.5, _gui_w * 1.5, _open);
        var _half_w = 90 * _s;
        var _laser_alpha = sin(pi * _open);
        draw_set_alpha(_laser_alpha * 0.7);
        draw_rectangle_colour(round(_laser_x - _half_w), _cy - 3 * _s,
            round(_laser_x + _half_w), _cy + 3 * _s,
            make_color_rgb(70, 50, 240), c_white,
            c_white, make_color_rgb(70, 50, 240), false);
        draw_set_alpha(_laser_alpha);
        draw_line_width_colour(round(_laser_x - _half_w), _cy,
            round(_laser_x + _half_w), _cy, _s, c_white, c_white);
        draw_set_alpha(1);
    }
    gpu_set_blendmode(bm_normal);
}

if (_t >= 10) {
    var _frame = 0; // Frame 0: main READY
    var _sx = 1;
    var _sy = 1;
    var _alpha = 1;

    if (_t < 27) {
        // Phase 1: arrive by frame 20, then alternate flashes every 2 frames.
        var _arrive = clamp((_t - 10) / 10, 0, 1);
        var _ease_in = 1 - power(1 - _arrive, 3);
        _sx = lerp(1.5, 1, _ease_in);
        _sy = lerp(2.2, 1, _ease_in);
        if (_t >= 18) {
            _frame = (((_t - 18) div 2) mod 2 == 0) ? 1 : 2; // Frame 1: flash_1, Frame 2: flash_2
        }
    } else if (_t < 85) {
        // Phase 2: 10 main + 2 flash2 + 2 flash1 + 2 flash2.
        var _shine = (_t - 27) mod 16;
        if (_shine >= 10 && _shine < 12) _frame = 2;
        else if (_shine >= 12 && _shine < 14) _frame = 1;
        else if (_shine >= 14) _frame = 2;
        // Frame 3: Shadow offset
        draw_sprite_ext(ready_sprite, 3, _cx + 2 * _s, _cy + 2 * _s, _s, _s, 0, c_white, 0.75);
    } else {
        // Phase 3: collapse to a bright horizontal slit and disappear.
        var _close = clamp((_t - 85) / 15, 0, 1);
        _frame = 1; // Flash 1 for bright collapse slit
        _sx = lerp(1, 1.35, _close);
        _sy = 1 - _close;
        _alpha = 1 - _close;
    }
    draw_sprite_ext(ready_sprite, _frame, _cx, _cy, _sx * _s, _sy * _s, 0, c_white, _alpha);
}

gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
gpu_set_texfilter(_filter);
