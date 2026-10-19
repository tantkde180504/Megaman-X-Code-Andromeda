/// @desc Web Spider Boss Health Bar & WARNING HUD
if (hp <= 0 && state == SPIDER_STATE.DEATH && death_timer < 30) return;

// 1. WARNING Screen at Start
if (warning_timer > 0) {
    var _cx = VIEW_WIDTH * 0.5;
    var _cy = VIEW_HEIGHT * 0.5;
    var _flash = (warning_timer % 14 < 7);
    
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(_cx - 140, _cy - 24, _cx + 140, _cy + 24, false);
    draw_set_alpha(1.0);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    if (_flash) {
        draw_set_color(make_color_rgb(255, 40, 40));
    } else {
        draw_set_color(make_color_rgb(255, 230, 40));
    }
    
    draw_text_transformed(_cx, _cy, "WARNING !!", 2.0, 2.0, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// 2. Vertical Boss Health Bar (Mega Man X Style)
var _bx = VIEW_WIDTH - 24;
var _by = 28;
var _bar_w = 8;
var _bar_h = 64;

if (intro_done) {
    hp_display = hp;
}

// Frame & border
draw_set_color(c_black);
draw_rectangle(_bx - 2, _by - 2, _bx + _bar_w + 1, _by + _bar_h + 1, false);
draw_set_color(make_color_rgb(140, 180, 160));
draw_rectangle(_bx - 2, _by - 2, _bx + _bar_w + 1, _by + _bar_h + 1, true);

// Inner empty background
var _inner_h = _bar_h - 2;
var _fill_h = round((clamp(hp_display, 0, max_hp) / max(1, max_hp)) * _inner_h);

draw_set_color(make_color_rgb(25, 40, 30));
draw_rectangle(_bx, _by, _bx + _bar_w - 1, _by + _inner_h - 1, false);

// Health bar lines (Jungle green / electric blue)
if (_fill_h > 0) {
    var _fill_top = _by + _inner_h - _fill_h;
    for (var _py = _by + _inner_h - 1; _py >= _fill_top; _py--) {
        if (flash_timer > 0) {
            draw_set_color(c_white);
        } else if (phase == 2) {
            // Phase 2: Electric yellow-orange
            draw_set_color((_py % 2 == 0) ? make_color_rgb(255, 180, 30) : make_color_rgb(220, 120, 20));
        } else {
            // Phase 1: Forest green / teal
            draw_set_color((_py % 2 == 0) ? make_color_rgb(60, 220, 120) : make_color_rgb(30, 160, 80));
        }
        draw_line(_bx, _py, _bx + _bar_w - 1, _py);
    }
}

// Circular Boss Icon on top of health bar ("WS" for Web Spider)
draw_set_color(make_color_rgb(40, 160, 90));
draw_circle(_bx + 3, _by - 8, 6, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(_bx + 3, _by - 15, "WS");
draw_set_halign(fa_left);
