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

// Hộp thoại DIALOGUE trước khi đánh trùm (sử dụng Capcom fonts)
if (state == NZ_STATE.DIALOGUE && dialogue_box_alpha > 0.0) {
    if (dialogue_index < array_length(dialogue_list)) {
        var _item = dialogue_list[dialogue_index];
        var _box_w = VIEW_WIDTH - 16;
        var _box_h = 80;
        var _box_x = floor((VIEW_WIDTH - _box_w) * 0.5);
        var _box_y = VIEW_HEIGHT - _box_h - 10;
        
        // Nền đen hộp thoại mờ
        draw_set_alpha(0.85 * dialogue_box_alpha);
        draw_set_color(c_black);
        draw_roundrect_ext(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, 6, 6, false);
        
        // Viền hộp thoại theo màu nhân vật nói
        draw_set_color(_item.color);
        draw_set_alpha(dialogue_box_alpha);
        draw_roundrect_ext(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, 6, 6, true);
        draw_roundrect_ext(_box_x + 1, _box_y + 1, _box_x + _box_w - 1, _box_y + _box_h - 1, 6, 6, true);
        
        // Huy hiệu tên người nói
        draw_set_alpha(0.95 * dialogue_box_alpha);
        var _name_w = string_mmx_width(_item.speaker, MMX_FONT.SMALL, 1.0) + 12;
        draw_set_color(make_color_rgb(15, 15, 25));
        draw_rectangle(_box_x + 8, _box_y - 6, _box_x + 8 + _name_w, _box_y + 8, false);
        draw_set_color(_item.color);
        draw_rectangle(_box_x + 8, _box_y - 6, _box_x + 8 + _name_w, _box_y + 8, true);
        
        draw_set_alpha(dialogue_box_alpha);
        draw_mmx_text(_box_x + 14, _box_y - 4, _item.speaker, MMX_FONT.SMALL, 1.0, 1.0, _item.color, dialogue_box_alpha);
        
        // Vẽ nội dung câu thoại đang hiển thị (typewriter)
        ps1_draw_text(_box_x + 12, _box_y + 14, _item.text, _box_w - 24, 48,
            c_white, floor(dialogue_char_idx), dialogue_box_alpha);
        
        // Biểu tượng nhấp nháy bấm Enter khi đã gõ xong câu
        if (!dialogue_is_typing && (current_time % 600 < 350)) {
            draw_mmx_text(_box_x + _box_w - 56, _box_y + _box_h - 12, "ENTER >", MMX_FONT.SMALL, 0.9, 0.9, make_color_rgb(255, 230, 80), dialogue_box_alpha);
        }
        
        draw_set_alpha(1.0);
    }
}

