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

// Vẽ từng vạch năng lượng (64 vạch tương ứng max_hp)
var _ticks = max_hp;
var _tick_h = (_bar_h - 2) / max(1, _ticks);

for (var _i = 0; _i < _ticks; _i++) {
    var _ty = _by + _bar_h - 2 - ((_i + 1) * _tick_h);
    
    if (_i < hp_display) {
        if (flash_timer > 0) {
            draw_set_color(c_white); // Nháy trắng khi trúng đòn
        } else if (phase == 2) {
            // Phase 2: Thanh máu màu đỏ thẫm / tím ác mộng
            draw_set_color((_i % 2 == 0) ? make_color_rgb(255, 40, 100) : make_color_rgb(180, 20, 160));
        } else {
            // Phase 1: Màu tím Nightmare đặc trưng
            draw_set_color((_i % 2 == 0) ? make_color_rgb(170, 70, 230) : make_color_rgb(120, 40, 190));
        }
    } else {
        // Phần vạch đã mất
        draw_set_color(make_color_rgb(35, 30, 45));
    }
    
    draw_rectangle(_bx, _ty, _bx + _bar_w - 1, _ty + _tick_h - 1, false);
}

// Biểu tượng Boss trên đầu thanh máu
draw_set_color(make_color_rgb(220, 40, 70));
draw_circle(_bx + 3, _by - 8, 6, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(_bx + 3, _by - 15, "NZ");
draw_set_halign(fa_left);
