if (flash_timer > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_self();
    gpu_set_fog(false, c_white, 0, 0);
} else {
    draw_self();
}

var _bw = 24;
var _bh = 4;
var _bx = x - (_bw / 2);
var _by = bbox_top - 8;
draw_set_color(c_black);
draw_rectangle(_bx - 1, _by - 1, _bx + _bw + 1, _by + _bh + 1, false);
draw_set_color(c_red);
var _fill = max(0, (_bw * (hp / hp_max)));
draw_rectangle(_bx, _by, _bx + _fill, _by + _bh, false);
