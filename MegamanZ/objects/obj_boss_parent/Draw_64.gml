/// @desc Boss Health Bar HUD (Mega Man X Vertical Energy Bar)
if (is_dead) return;

var _bx = VIEW_WIDTH - 24;
var _by = 28;
var _bar_w = 8;
var _bar_h = 64;

// Hiệu ứng nạp máu lúc mở màn
if (!intro_done) {
    if (hp_display < hp) {
        hp_display += 1;
    } else {
        intro_done = true;
    }
} else {
    hp_display = hp;
}

// Viền đen và khung thanh máu bên ngoài
draw_set_color(c_black);
draw_rectangle(_bx - 2, _by - 2, _bx + _bar_w + 1, _by + _bar_h + 1, false);
draw_set_color(make_color_rgb(160, 170, 200));
draw_rectangle(_bx - 2, _by - 2, _bx + _bar_w + 1, _by + _bar_h + 1, true);

// Vẽ thanh năng lượng (Mega Man X style)
var _inner_h = _bar_h - 2;
var _fill_h = round((clamp(hp_display, 0, max_hp) / max(1, max_hp)) * _inner_h);

// Nền vạch đã mất
draw_set_color(make_color_rgb(35, 30, 45));
draw_rectangle(_bx, _by, _bx + _bar_w - 1, _by + _inner_h - 1, false);

// Phần máu còn lại với các đường sọc năng lượng
if (_fill_h > 0) {
    var _fill_top = _by + _inner_h - _fill_h;
    for (var _py = _by + _inner_h - 1; _py >= _fill_top; _py--) {
        if (flash_timer > 0) {
            draw_set_color(c_white);
        } else if (phase == 2) {
            draw_set_color((_py % 2 == 0) ? make_color_rgb(255, 40, 100) : make_color_rgb(180, 20, 160));
        } else {
            draw_set_color((_py % 2 == 0) ? make_color_rgb(170, 70, 230) : make_color_rgb(120, 40, 190));
        }
        draw_line(_bx, _py, _bx + _bar_w - 1, _py);
    }
}

// Biểu tượng Boss trên đầu thanh máu
draw_set_color(make_color_rgb(220, 40, 70));
draw_circle(_bx + 3, _by - 8, 6, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(_bx + 3, _by - 15, "NZ");
draw_set_halign(fa_left);
