/// @desc Web Spider Boss Draw Event

// 1. Draw Electric Silk Thread from Ceiling (spr_ws_web_thread)
if ((wire_active || (state == WS_STATE.WIRE_CUT_FALL && weakness_phase == 2)) && y > y_ceiling) {
    var _pulse = ((anim_timer * 10) % 2 == 0);
    draw_set_color(_pulse ? c_white : make_color_rgb(140, 220, 255));
    draw_line_width(anchor_x, y_ceiling, x, y - 24, 2);
    draw_set_color(make_color_rgb(60, 160, 240));
    draw_line(anchor_x - 1, y_ceiling, x - 1, y - 24);
}

// Don't draw if fully hidden in canopy
if (state == WS_STATE.PHASE1_CANOPY_HIDE && y <= y_ceiling - 40) return;

// 2. Weakness Hurt Reaction State (Zero's fire slash: 14 frames across Row 2 & Row 3)
if (state == WS_STATE.WIRE_CUT_FALL) {
    var _blink_alpha = (state_timer % 4 < 2) ? 0.35 : 1.0;
    var _flash = (flash_timer > 0 && flash_timer % 4 < 2);
    draw_web_spider_weakness_hurt(weakness_frame, x, y, facing, _flash, _blink_alpha);
    return;
}

// 3. Select Sprite Row and Frame for Normal States
var _row = 1;
var _frame = 0;
var _flash = (flash_timer > 0 && flash_timer % 4 < 2);

switch (state) {
    case WS_STATE.INTRO:
        _row = 1;
        _frame = anim_frame;
        break;
        
    case WS_STATE.PHASE1_DESCEND:
    case WS_STATE.PHASE1_ASCEND:
        _row = 1;
        _frame = (floor(anim_timer * 0.15) % 2); // Hanging head-down on thread
        break;
        
    case WS_STATE.PHASE1_FIRE_WEB:
        _row = 1;
        _frame = 0;
        break;
        
    case WS_STATE.PHASE2_TRANSITION:
        // Động tác tiếp đất tâm mạng, chổng bụng truyền điện và bung mạng nhện
        if (state_timer < 20) {
            _row = 1; 
            _frame = 0; // Đu tơ hạ xuống tâm
        } else if (state_timer < 32) {
            _row = 3; 
            _frame = 1; // Tiếp đất tâm mạng, chổng bụng tích điện
        } else if (state_timer < 45) {
            _row = 3; 
            _frame = 2; // Động tác dệt mạng bung tơ tỏa ra 8 hướng
        } else {
            _row = 3; 
            _frame = 3; // Bám 8 chân vững vàng trên tâm mạng nhện
        }
        break;
        
    case WS_STATE.PHASE2_WEB_MOVE:
        // Cử động bò đa bộ phận (Multi-part) trên mạng nhện theo đúng yêu cầu:
        // - Thân: Hàng 4 Frame 1 (index 0)
        // - Đầu: Hàng 5 với 4 frame kết hợp với phần thân
        // - Chân lớn: Hàng 6 (11 frame) kết hợp với thân
        // - Chân nhỏ: Hàng 7 (11 frame)
        // - Tay: Hàng 8 (7 frame)
        var _head_f = (anim_timer * 0.15) % 4;
        var _leg_f = (anim_timer * 0.35) % 11;
        var _arm_f = (anim_timer * 0.25) % 7;
        draw_web_spider_multipart(0, _head_f, _leg_f, _leg_f, _arm_f, x, y, facing, _flash, 1.0);
        return;
        
    case WS_STATE.PHASE2_ATTACK_WEB:
        // Tích điện và phóng Lightning Web từ trên mạng nhện (Row 3, Frame 4 -> Frame 5)
        _row = 3;
        _frame = (state_timer < 20) ? 4 : 5;
        break;
        
    case WS_STATE.PHASE2_SPAWN_SPIDERS:
        // Animation bung nhện con: Hàng 4 với 7 frame mở nắp (1..7) kết hợp với phần thân và các chi
        var _body_f = 0;
        if (state_timer >= 12 && state_timer <= 46) {
            _body_f = 1 + clamp(floor(((state_timer - 12) / 34.0) * 7), 0, 6);
        }
        var _head_f = (anim_timer * 0.15) % 4;
        var _leg_f = (anim_timer * 0.20) % 11;
        var _arm_f = (anim_timer * 0.20) % 7;
        draw_web_spider_multipart(_body_f, _head_f, _leg_f, _leg_f, _arm_f, x, y, facing, _flash, 1.0);
        return;
        
    case WS_STATE.DEATH:
        // Hiệu ứng kết liễu: Dùng Frame giật điện/chao đảo (Row 2, Frame 2)
        _row = 2;
        _frame = 2;
        _flash = (death_timer % 4 < 2); // Nhấp nháy trắng liên tục khi trúng nổ
        var _death_alpha = (death_timer < 20) ? max(0, death_timer / 20.0) : 1.0;
        draw_web_spider_part(_row, _frame, x, y, facing, _flash, _death_alpha);
        return;
}

// 4. Render Sprite Part using authentic MMX4 atlas coordinates
draw_web_spider_part(_row, _frame, x, y, facing, _flash);
