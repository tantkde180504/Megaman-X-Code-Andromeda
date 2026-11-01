/// @desc Sky Lagoon-style READY: horizontal light, converging bands, split exit.
var _t = max(0, ready_frame);
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _cx = round(_gui_w * 0.5);
var _cy = round(_gui_h * 0.5);
if (auto_gui_scale) gui_scale = max(1, floor(min(_gui_w / 320, _gui_h / 240)));
var _s = gui_scale;
var _filter = gpu_get_texfilter();
var _alpha = draw_get_alpha();
var _colour = draw_get_colour();
gpu_set_texfilter(false);
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);

// Blue-violet columns arrive from the upper/lower edges and converge behind READY.
if (_t >= 14 && _t < 42) {
    var _progress = clamp((_t - 14) / 18, 0, 1);
    var _ease = 1 - power(1 - _progress, 3);
    var _half_h = lerp(_gui_h * 0.65, 26 * _s, _ease);
    var _band_alpha = min(1, (_t - 14) / 6) * (1 - clamp((_t - 30) / 12, 0, 1)) * 0.6;
    var _blue = make_colour_rgb(55, 35, 240);
    gpu_set_blendmode(bm_add);
    for (var _i = 0; _i < 4; _i++) {
        var _x = _cx - 116 * _s + _i * 58 * _s;
        var _width = 50 * _s;
        var _slant = 18 * _s;
        draw_primitive_begin(pr_trianglestrip);
        draw_vertex_colour(_x + _slant, _cy - _half_h, _blue, _band_alpha);
        draw_vertex_colour(_x + _width + _slant, _cy - _half_h, _blue, _band_alpha);
        draw_vertex_colour(_x, _cy, c_white, _band_alpha * 0.85);
        draw_vertex_colour(_x + _width, _cy, c_white, _band_alpha * 0.85);
        draw_vertex_colour(_x + _slant, _cy + _half_h, _blue, _band_alpha);
        draw_vertex_colour(_x + _width + _slant, _cy + _half_h, _blue, _band_alpha);
        draw_primitive_end();
    }
    gpu_set_blendmode(bm_normal);
}

// A thin horizontal glint leads the lettering and returns for the split exit.
if (_t < 18 || _t >= teleport_start_frame) {
    var _phase = _t < 18 ? _t / 18 : (_t - teleport_start_frame) / (ready_duration - teleport_start_frame);
    var _light = max(0, sin(pi * clamp(_phase, 0, 1)));
    draw_set_alpha(_light * 0.7);
    draw_line_width_colour(0, _cy, _gui_w, _cy, _s, c_aqua, c_white);
    draw_set_alpha(1);
}

if (_t >= 6) {
    var _frame = 0;
    if (_t < 24) {
        _frame = ((_t div 2) mod 3 == 0) ? 1 : 2;
    } else {
        var _shine = (_t - 24) mod 24;
        if (_shine == 20 || _shine >= 22) _frame = 2;
        else if (_shine == 21) _frame = 1;
    }
    if (_t < teleport_start_frame) {
        var _appear = clamp((_t - 6) / 8, 0, 1);
        draw_sprite_ext(ready_sprite, 3, _cx + _s, _cy + _s, _s, _s, 0, c_white, _appear);
        draw_sprite_ext(ready_sprite, _frame, _cx, _cy, _s, _s, 0, c_white, _appear);
    } else {
        var _exit = clamp((_t - teleport_start_frame) / (ready_duration - teleport_start_frame), 0, 1);
        var _offset = round(_gui_w * power(_exit, 0.8));
        // Two complete copies separate horizontally, as in the reference.
        draw_sprite_ext(ready_sprite, _frame, _cx - _offset, _cy, _s, _s, 0, c_white, 1 - _exit);
        draw_sprite_ext(ready_sprite, _frame, _cx + _offset, _cy, _s, _s, 0, c_white, 1 - _exit);
    }
}

gpu_set_blendmode(bm_normal);
draw_set_alpha(_alpha);
draw_set_colour(_colour);
gpu_set_texfilter(_filter);
