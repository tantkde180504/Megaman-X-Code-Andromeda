/// @desc Vẽ hiệu ứng chuyển màn hình (Draw GUI Event)

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// 1. Chớp trắng toàn màn hình (dành cho tùy chọn kiểu cổ điển MMX1_SNES)
if (white_flash_alpha > 0.0) {
    draw_set_alpha(white_flash_alpha);
    draw_set_color(c_white);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);
}

// 2. Màn đen chuyển cảnh (Nếu oGame chưa vẽ thì tự động vẽ phủ toàn màn hình)
if (!instance_exists(oGame) && fade_alpha > 0.0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);
}
