if (!instance_exists(oPlayer)) return;
var _p = instance_find(oPlayer, 0);
var _hx = 16;
var _hy = 20;
var _bar_h = 64;
var _bar_w = 8;
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(_hx - 2, _hy - 2, _hx + _bar_w + 1, _hy + _bar_h + 1, false);
draw_set_color(make_color_rgb(140, 160, 190));
draw_rectangle(_hx - 2, _hy - 2, _hx + _bar_w + 1, _hy + _bar_h + 1, true);
var _tick_h = (_bar_h - 2) / max(1, _p.hp_max);
for (var _i = 0; _i < _p.hp_max; _i++) {
    var _y = _hy + _bar_h - 2 - (_i + 1) * _tick_h;
    var _colour = make_color_rgb(40, 40, 50);
    if (_i < _p.hp_current) {
        _colour = _p.hp_current <= 4 ? c_red : (_p.hp_current <= 8 ? c_yellow : c_lime);
    }
    draw_set_color(_colour);
    draw_rectangle(_hx, _y, _hx + _bar_w - 1, _y + _tick_h - 1, false);
}
ps1_draw_text(16, 2, global.current_char == CHAR_TYPE.X ? "X" : "Z", 16, 16);
var _title = "TRAINING";
if (room == rStage_Intro) _title = "RUINED HIGHWAY";
else if (room == rStage_WebSpider) _title = "DEEP JUNGLE";
else if (room == rBoss_NightmareZero) _title = "NIGHTMARE AREA";
// Reserve both screen edges for the player and boss health bars.
ps1_draw_centered(160, 2, _title, 240, c_yellow);
var _air_dash = _p.has_air_dash || global.has_air_dash;
var _double_jump = _p.has_double_jump;
var _ability = _air_dash && _double_jump ? "AIR DASH / D-JUMP"
    : (_air_dash ? "AIR DASH" : (_double_jump ? "DOUBLE JUMP" : ""));
ps1_draw_text(40, 22, _ability, 236, 16, c_aqua);
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, VIEW_HEIGHT - 18, VIEW_WIDTH, VIEW_HEIGHT, false);
draw_set_alpha(1);
ps1_draw_centered(160, VIEW_HEIGHT - 17, "Z:JUMP X:ATK C:DASH TAB:SWITCH", 312, c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

