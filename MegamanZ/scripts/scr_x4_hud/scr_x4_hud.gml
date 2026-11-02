/// @desc Assemble native X4 HUD parts; only the shaft repeats, never the emblems.
enum X4_HUD_STYLE { X, ZERO, BOSS_X, BOSS_R, BOSS_SIGMA }

function hud_x4_base(_style) {
    switch (_style) {
        case X4_HUD_STYLE.ZERO: return sHUD_X4_BaseZero;
        case X4_HUD_STYLE.BOSS_X: return sHUD_X4_BaseBossX;
        case X4_HUD_STYLE.BOSS_R: return sHUD_X4_BaseBossR;
        case X4_HUD_STYLE.BOSS_SIGMA: return sHUD_X4_BaseBossSigma;
    }
    return sHUD_X4_BaseX;
}

function hud_x4_filled_cells(_current, _maximum, _cells) {
    if (_maximum <= 0) return 0;
    return ceil(clamp(_current / _maximum, 0, 1) * _cells);
}

function hud_x4_draw_bar(_left, _top, _current, _maximum, _style, _cells, _flash = false) {
    var _old_alpha = draw_get_alpha();
    var _old_colour = draw_get_colour();
    draw_set_alpha(1);
    draw_set_colour(c_white);
    _cells = clamp(round(_cells), 1, 64);
    var _bar_x = floor(_left) + (_style == X4_HUD_STYLE.BOSS_X ? 10 : 7);
    var _bar_y = floor(_top);
    var _filled = hud_x4_filled_cells(_current, _maximum, _cells);
    // Back the source's translucent empty-shaft pattern with black.
    draw_set_colour(c_black);
    draw_rectangle(_bar_x + 3, _bar_y + 3, _bar_x + 7, _bar_y + 2 + _cells * 2, false);
    draw_set_colour(c_white);
    draw_sprite(sHUD_X4_Cap, 0, _bar_x, _bar_y);
    for (var _i = 0; _i < _cells; _i++) {
        draw_sprite(sHUD_X4_Shaft, 0, _bar_x, _bar_y + 3 + _i * 2);
    }
    for (var _i = 0; _i < _filled; _i++) {
        draw_sprite(sHUD_X4_Cell, _flash ? 1 : 0, _bar_x + 3,
            _bar_y + 3 + (_cells - 1 - _i) * 2);
    }
    draw_sprite(hud_x4_base(_style), 0, floor(_left), _bar_y + 3 + _cells * 2);
    draw_set_colour(_old_colour);
    draw_set_alpha(_old_alpha);
}

function hud_x4_draw_boss(_current, _maximum, _style, _flash = false) {
    var _left = VIEW_WIDTH - 8 - sprite_get_width(hud_x4_base(_style));
    hud_x4_draw_bar(_left, 12, _current, _maximum, _style, 32, _flash);
}

function hud_x4_draw_number(_value, _x, _y) {
    var _text = string(max(0, floor(_value)));
    var _advance = sprite_get_width(sHUD_X4_Digits) + 1;
    for (var _i = 1; _i <= string_length(_text); _i++) {
        draw_sprite(sHUD_X4_Digits, real(string_char_at(_text, _i)),
            floor(_x) + (_i - 1) * _advance, floor(_y));
    }
}
