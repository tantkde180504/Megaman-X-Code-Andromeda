/// @desc Draw Title Intro 320x240 inside native 320x240 PS1 screen
var _cx = 160;
var _cy = 75;
var _menu_y = 185;

var _colour = draw_get_colour();
var _alpha = draw_get_alpha();
var _halign = draw_get_halign();
var _valign = draw_get_valign();

// Nen den tong the
draw_set_alpha(1.0);
draw_set_colour(c_black);
draw_rectangle(0, 0, 320, 240, false);

// 1. Nen vu tru + Trai Dat + Tram khong gian + Ban quyen (phu kin 320x240)
if (sprite_exists(title_bg) && bg_alpha > 0) {
    draw_sprite_ext(title_bg, 0, 0, 0, 1, 1, 0, c_white, bg_alpha);
}

// 2. Hieu ung dan tia sang chu MEGAMAN & Logo X thu vao tam
if (state < TITLE_INTRO_STATE.LOGO) {
    if (state == TITLE_INTRO_STATE.IMPACT) {
        if (sprite_exists(logo_andromeda)) {
            // Bong logo trang thu vao tam
            gpu_set_fog(true, c_white, 0, 0);
            draw_sprite_ext(logo_andromeda, 0, _cx, _cy,
                impact_scale, impact_scale, 0, c_white, 0.9);
            gpu_set_fog(false, c_white, 0, 0);
        }
    }

    if (state == TITLE_INTRO_STATE.BEAM) {
        if (sprite_exists(megaman_text)) {
            // Chu MEGAMAN dan ngang
            gpu_set_fog(true, c_white, 0, 0);
            draw_sprite_ext(megaman_text, 0, _cx, _cy,
                megaman_xscale, megaman_yscale, 0, c_white, 1.0);
            gpu_set_fog(false, c_white, 0, 0);
        }

        // Tia laser trang phong ngang toan man hinh 320
        var _beam = 1 - clamp(state_frame / 15, 0, 1);
        if (_beam > 0) {
            draw_set_alpha(_beam);
            draw_line_width_colour(0, _cy, 320, _cy, 2, c_white, c_white);
            draw_set_alpha(1.0);
        }
    } else {
        // Chu MEGAMAN xanh goc
        if (sprite_exists(megaman_text)) {
            draw_sprite_ext(megaman_text, 0, _cx, _cy,
                megaman_xscale, megaman_yscale, 0, c_white, 1.0);
        }
    }
} else {
    // 3. Sang vien mot vong trong intro; Menu giu co dinh frame 0.
    if (sprite_exists(logo_andromeda)) {
        draw_sprite_ext(logo_andromeda, floor(logo_frame), _cx, _cy,
            1, 1, 0, c_white, 1.0);
    }
}

// 4. Menu PRESS START & Options (GAME START / CONTINUE / OPTION)
if (state == TITLE_INTRO_STATE.MENU) {
    if (menu_state == TITLE_MENU_STATE.PRESS_START) {
        if (sprite_exists(press_start) && ((menu_blink div 20) mod 2 == 0)) {
            draw_sprite_ext(press_start, 0, _cx, _menu_y, 1, 1, 0, c_white, 1.0);
        }
    } else if (menu_state == TITLE_MENU_STATE.OPTIONS) {
        if (sprite_exists(menu_options)) {
            draw_sprite_ext(menu_options, menu_index, _cx, _menu_y, 1, 1, 0, c_white, 1.0);
        }
    }
    if (menu_notice_timer > 0) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_colour(c_yellow);
        draw_text(_cx, 225, menu_notice);
    }
}

if (state == TITLE_INTRO_STATE.MENU && menu_state == TITLE_MENU_STATE.SETTINGS) {
    ps1_draw_panel(4, 2, 312, 236);
    ps1_draw_centered(160, 16, "OPTIONS", 300, c_aqua);
    var _labels = ["KEYBOARD", "SCREEN MODE", "WINDOW SIZE", "BACK"];
    var _values = ["EDIT", display_settings_is_web() ? "BROWSER"
        : (window_get_fullscreen() ? "FULLSCREEN" : "WINDOWED"),
        display_settings_size_label(), ""];
    for (var _row = 0; _row < 4; _row++) {
        var _y = 56 + _row * 34;
        var _selected = settings_row == _row;
        if (_selected) {
            draw_set_alpha(1);
            draw_set_colour(make_colour_rgb(24, 58, 96));
            draw_rectangle(12, _y - 3, 307, _y + 19, false);
        }
        draw_mmx_text(20, _y, _labels[_row], MMX_FONT.SMALL, 1, 1,
            _selected ? c_yellow : c_white);
        draw_mmx_text(180, _y, _values[_row], MMX_FONT.SMALL, 1, 1,
            _selected ? c_yellow : c_aqua);
    }
    ps1_draw_centered(160, 196, "ARROWS: SELECT / CHANGE", 300, c_aqua);
    ps1_draw_centered(160, 212, "ENTER: CONFIRM  ESC: BACK", 300, c_white);
}

// Native 320x240 controls panel, using the same bitmap font as character select.
if (state == TITLE_INTRO_STATE.MENU && menu_state == TITLE_MENU_STATE.CONTROLS) {
    ps1_draw_panel(4, 2, 312, 236);
    ps1_draw_centered(160, 6, "OPTIONS - KEYBOARD", 300, c_aqua);
    for (var _s = 0; _s < 3; _s++) {
        ps1_draw_centered(138 + _s * 66, 23, "KEY " + string(_s + 1), 64, c_gray);
    }
    for (var _a = 0; _a < array_length(global.key_actions); _a++) {
        var _y = 40 + _a * 16;
        var _selected = controls_row == _a;
        draw_mmx_text(12, _y, global.key_labels[_a], MMX_FONT.SMALL, 1, 1, _selected ? c_yellow : c_white);
        for (var _s = 0; _s < 3; _s++) {
            var _active = _selected && controls_slot == _s;
            var _x = 106 + _s * 66;
            if (_active) {
                draw_set_alpha(1);
                draw_set_colour(make_color_rgb(24, 58, 96));
                draw_rectangle(_x, _y, _x + 63, _y + 15, false);
                draw_set_colour(controls_capturing ? c_yellow : c_aqua);
                draw_rectangle(_x, _y, _x + 63, _y + 15, true);
            }
            var _name = _active && controls_capturing ? "..." : input_key_name(global.key_bindings[_a][_s]);
            ps1_draw_centered(_x + 32, _y, _name, 64, _active ? c_yellow : c_white);
        }
    }
    ps1_draw_centered(160, 186, (controls_row == 9 ? "> " : "") + "RESTORE DEFAULTS", 300, controls_row == 9 ? c_yellow : c_white);
    ps1_draw_centered(160, 202, (controls_row == 10 ? "> " : "") + "BACK", 300, controls_row == 10 ? c_yellow : c_white);
    // Compact one-line instructions/status, scaled to stay within the panel.
    var _scale = min(1, 296 / max(1, string_mmx_width(controls_message)));
    draw_mmx_text(12, 220, controls_message, MMX_FONT.SMALL, _scale, 1, c_aqua);
}

// 5. Hieu ung chop trang man hinh (Screen Flash)
if (flash_alpha > 0) {
    draw_set_colour(c_white);
    draw_set_alpha(flash_alpha);
    draw_rectangle(0, 0, 320, 240, false);
}

// Khoi phuc GPU states
gpu_set_fog(false, c_white, 0, 0);
draw_set_alpha(_alpha);
draw_set_colour(_colour);
draw_set_halign(_halign);
draw_set_valign(_valign);
