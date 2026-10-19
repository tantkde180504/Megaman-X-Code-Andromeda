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
    case WS_STATE.PHASE2_ATTACK_WEB:
        _row = 1;
        _frame = 0;
        break;
        
    case WS_STATE.PHASE2_TRANSITION:
        _row = 1;
        _frame = 0;
        break;
        
    case WS_STATE.PHASE2_WEB_MOVE:
        _row = 1;
        _frame = (floor(anim_timer * 0.20) % 2); // crawl on web
        break;
        
    case WS_STATE.PHASE2_SPAWN_SPIDERS:
        _row = 1;
        _frame = 1;
        break;
        
    case WS_STATE.DEATH:
        _row = 1;
        _frame = 0;
        break;
}

// 4. Render Sprite Part using authentic MMX4 atlas coordinates
draw_web_spider_part(_row, _frame, x, y, facing, _flash);
