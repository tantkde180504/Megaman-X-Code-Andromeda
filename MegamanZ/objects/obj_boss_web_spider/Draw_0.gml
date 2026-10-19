/// @desc Web Spider Boss Draw Event

// 1. Draw Electric Silk Thread from Ceiling (spr_ws_web_thread)
if (wire_active && y > y_ceiling) {
    var _pulse = ((anim_timer * 10) % 2 == 0);
    draw_set_color(_pulse ? c_white : make_color_rgb(140, 220, 255));
    draw_line_width(anchor_x, y_ceiling, x, y - 24, 2);
    draw_set_color(make_color_rgb(60, 160, 240));
    draw_line(anchor_x - 1, y_ceiling, x - 1, y - 24);
}

// Don't draw if fully hidden in canopy
if (state == WS_STATE.PHASE1_CANOPY_HIDE && y <= y_ceiling - 40) return;

// 2. Select Sprite Row and Frame
var _row = 3;
var _frame = 3;
var _flash = (flash_timer > 0 && flash_timer % 4 < 2);

switch (state) {
    case WS_STATE.INTRO:
        _row = 1;
        _frame = anim_frame;
        break;
        
    case WS_STATE.PHASE1_DESCEND:
    case WS_STATE.PHASE1_ASCEND:
        _row = 2;
        _frame = 4;
        break;
        
    case WS_STATE.PHASE1_FIRE_WEB:
    case WS_STATE.PHASE2_ATTACK_WEB:
        if (state_timer < 20) {
            _row = 2; // spr_ws_body_charge (electric charge)
            _frame = 2;
        } else {
            _row = 3; // spr_ws_attack_body (firing web)
            _frame = 5;
        }
        break;
        
    case WS_STATE.PHASE2_TRANSITION:
        _row = 2;
        _frame = 2; // spr_ws_body_charge (electric charge aura)
        break;
        
    case WS_STATE.PHASE2_WEB_MOVE:
        _row = 3;
        _frame = 3 + (floor(anim_timer) % 2); // crawl on web
        break;
        
    case WS_STATE.PHASE2_SPAWN_SPIDERS:
        _row = 3;
        _frame = (state_timer < 25) ? 1 : 2; // spr_ws_body_spawn_spiders (abdomen up)
        break;
        
    case WS_STATE.WIRE_CUT_FALL:
        _row = 2;
        _frame = (y < y_floor) ? 0 : 1; // spr_ws_body_fall (falling on back)
        break;
        
    case WS_STATE.DEATH:
        _row = 2;
        _frame = 2;
        break;
}

// 3. Render Sprite Part using authentic MMX4 atlas coordinates
draw_web_spider_part(_row, _frame, x, y, facing, _flash);
