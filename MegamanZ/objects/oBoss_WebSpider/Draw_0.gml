/// @desc Web Spider Boss Draw Event

// 1. Draw Silk Thread from ceiling to body
if (state == SPIDER_STATE.INTRO || state == SPIDER_STATE.CEILING_IDLE || state == SPIDER_STATE.CEILING_MOVE || state == SPIDER_STATE.DESCEND || state == SPIDER_STATE.ASCEND) {
    draw_set_color(c_white);
    draw_line_width(anchor_x, ceiling_y, x, y - 24, 2);
    draw_set_color(make_color_rgb(170, 210, 255));
    draw_line(anchor_x - 1, ceiling_y, x - 1, y - 24);
}

// 2. Select Source Frame from WebSpider Sprite Sheet
var _src_x = 269;
var _src_y = 10;
var _w = 63;
var _h = 63;
var _ox = 31;
var _oy = 31;

switch (state) {
    case SPIDER_STATE.INTRO:
    case SPIDER_STATE.CEILING_IDLE:
    case SPIDER_STATE.CEILING_MOVE:
        // 4-frame hanging animation (Band 0)
        var _idx = floor(anim_frame) % 4;
        if (_idx == 0)      { _src_x = 269; _src_y = 10; _w = 63; _h = 63; }
        else if (_idx == 1) { _src_x = 336; _src_y = 10; _w = 65; _h = 63; }
        else if (_idx == 2) { _src_x = 408; _src_y = 10; _w = 59; _h = 63; }
        else                { _src_x = 476; _src_y = 10; _w = 63; _h = 63; }
        _ox = floor(_w / 2);
        _oy = floor(_h / 2);
        break;
        
    case SPIDER_STATE.DESCEND:
    case SPIDER_STATE.ASCEND:
        // Dropping / climbing thread frame (Band 1)
        _src_x = 56;
        _src_y = 88;
        _w = 80;
        _h = 68;
        _ox = floor(_w / 2);
        _oy = floor(_h / 2);
        break;
        
    case SPIDER_STATE.ATTACK_WEB:
        if (state_timer < 20) {
            // Windup prep frame (Band 2)
            _src_x = 346;
            _src_y = 181;
            _w = 79;
            _h = 50;
        } else {
            // Firing frame (Band 2)
            _src_x = 518;
            _src_y = 181;
            _w = 75;
            _h = 50;
        }
        _ox = floor(_w / 2);
        _oy = floor(_h / 2);
        break;
        
    case SPIDER_STATE.HURT:
    case SPIDER_STATE.DEATH:
        // Electric shock / hurt frame (Band 1)
        _src_x = 231;
        _src_y = 85;
        _w = 134;
        _h = 72;
        _ox = floor(_w / 2);
        _oy = floor(_h / 2);
        break;
}

// 3. Render Sprite with Hurt Flash
var _flash = (flash_timer > 0 && flash_timer % 4 < 2);
enemy_draw_sprite(WebSpider, _src_x, _src_y, _w, _h, _ox, _oy, x, y, facing, _flash);
