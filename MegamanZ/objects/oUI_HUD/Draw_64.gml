if (!instance_exists(oPlayer)) return;
var _p = instance_find(oPlayer, 0);

var _hx = 16;
var _hy = 16;
var _bar_h = 64;
var _bar_w = 8;

// Outer bracket
draw_set_color(c_black);
draw_rectangle(_hx - 2, _hy - 2, _hx + _bar_w + 1, _hy + _bar_h + 1, false);
draw_set_color(make_color_rgb(140, 160, 190));
draw_rectangle(_hx - 2, _hy - 2, _hx + _bar_w + 1, _hy + _bar_h + 1, true);

// HP bars
var _ticks = _p.hp_max;
var _tick_h = (_bar_h - 2) / max(1, _ticks);
for (var _i = 0; _i < _ticks; _i++) {
    var _by = _hy + _bar_h - 2 - ((_i + 1) * _tick_h);
    if (_i < _p.hp_current) {
        if (_p.hp_current <= 4) {
            draw_set_color(make_color_rgb(255, 60, 60));
        } else if (_p.hp_current <= 8) {
            draw_set_color(make_color_rgb(255, 210, 40));
        } else {
            draw_set_color(make_color_rgb(40, 240, 120));
        }
    } else {
        draw_set_color(make_color_rgb(40, 40, 50));
    }
    draw_rectangle(_hx, _by, _hx + _bar_w - 1, _by + _tick_h - 1, false);
}

// Icon & Label
if (global.current_char == CHAR_TYPE.X) {
    draw_set_color(make_color_rgb(60, 170, 255));
    draw_circle(_hx + 3, _hy - 8, 6, false);
    draw_set_color(c_white);
    draw_text(_hx - 1, _hy - 14, "X");
} else {
    draw_set_color(make_color_rgb(255, 50, 50));
    draw_circle(_hx + 3, _hy - 8, 6, false);
    draw_set_color(c_white);
    draw_text(_hx - 1, _hy - 14, "Z");
}

// Stage Title Banner (top center)
var _st_name = "TEST PLAYGROUND";
if (room_get_name(room) == "rStage_Intro") _st_name = "INTRO STAGE: RUINED HIGHWAY";
else if (room_get_name(room) == "rStage_WebSpider") _st_name = "STAGE 1: WEB SPIDER JUNGLE";

draw_set_color(c_black);
draw_set_alpha(0.6);
draw_rectangle(VIEW_WIDTH * 0.5 - 90, 4, VIEW_WIDTH * 0.5 + 90, 18, false);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(255, 220, 100));
draw_set_halign(fa_center);
draw_text(VIEW_WIDTH * 0.5, 5, _st_name);
draw_set_halign(fa_left);

// Air Dash indicator
if (_p.has_air_dash || (variable_global_exists("has_air_dash") && global.has_air_dash)) {
    draw_set_color(make_color_rgb(80, 220, 255));
    draw_text(_hx + 14, _hy + 4, "AIR DASH [ON]");
}

// Help banner (bottom)
draw_set_color(c_black);
draw_set_alpha(0.65);
draw_rectangle(0, VIEW_HEIGHT - 14, VIEW_WIDTH, VIEW_HEIGHT, false);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(200, 220, 240));
draw_text(4, VIEW_HEIGHT - 13, "Move: Arrows | Z: Jump | X: Atk | C: Dash | V: Spec | 1/2/3: Stage | TAB: Char | F1: Debug");
