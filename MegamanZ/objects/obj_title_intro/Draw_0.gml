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
    } else {
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
