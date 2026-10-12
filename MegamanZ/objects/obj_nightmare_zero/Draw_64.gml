/// @desc Nightmare Zero GUI - Health Bar & WARNING Screen
event_inherited(); // Kế thừa thanh máu từ obj_boss_parent

// Màn hình cảnh báo WARNING !! lúc vào phòng đấu trùm
if (state == NZ_STATE.INTRO && warning_timer > 0) {
    var _cx = VIEW_WIDTH * 0.5;
    var _cy = VIEW_HEIGHT * 0.5;
    var _flash = (warning_timer % 14 < 7);
    
    // Dải cảnh báo đen ngang màn hình
    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(0, _cy - 30, VIEW_WIDTH, _cy + 30, false);
    
    // Viền sọc đỏ
    draw_set_color(_flash ? make_color_rgb(255, 30, 30) : make_color_rgb(160, 0, 0));
    draw_rectangle(0, _cy - 30, VIEW_WIDTH, _cy - 26, false);
    draw_rectangle(0, _cy + 26, VIEW_WIDTH, _cy + 30, false);
    
    // Dải hazard stripes
    var _stripe_w = 16;
    for (var _sx = -32; _sx < VIEW_WIDTH + 32; _sx += _stripe_w * 2) {
        var _ox = (current_time * 0.06) % (_stripe_w * 2);
        draw_set_alpha(0.2);
        draw_set_color(_flash ? make_color_rgb(255, 230, 50) : make_color_rgb(200, 30, 30));
        draw_rectangle(_sx - _ox, _cy - 26, _sx - _ox + _stripe_w, _cy + 26, false);
    }
    
    // Chữ WARNING !! nhấp nháy lớn ở trung tâm
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Shadow
    draw_set_color(c_black);
    draw_text_transformed(_cx + 2, _cy + 1, "W A R N I N G  ! !", 1.6, 1.6, 0);
    
    // Text
    draw_set_color(_flash ? make_color_rgb(255, 240, 60) : make_color_rgb(255, 50, 50));
    draw_text_transformed(_cx, _cy - 1, "W A R N I N G  ! !", 1.6, 1.6, 0);
    
    // Sub-banner
    draw_set_color(c_white);
    draw_text(_cx, _cy + 17, "EMERGENCY - THREAT LEVEL MAX");
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
}
