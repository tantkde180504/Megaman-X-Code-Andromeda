/// @desc Draw GUI: canvas 320x240 pixel art letterbox
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _scale = min(_gw / 320, _gh / 240);
if (_scale >= 1) _scale = floor(_scale);

var _left = floor((_gw - 320 * _scale) * 0.5);
var _top = floor((_gh - 240 * _scale) * 0.5);
var _cx = _left + 160 * _scale;
var _cy = _top + 75 * _scale;
var _menu_y = _top + 185 * _scale;

var _filter = gpu_get_texfilter();
var _colour = draw_get_colour();
var _halign = draw_get_halign();
var _valign = draw_get_valign();

gpu_set_blendmode(bm_normal);
gpu_set_texfilter(false);
gpu_set_fog(false, c_white, 0, 1);

// Nen den tong the
draw_set_alpha(1);
draw_set_colour(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

// 1. Nen vu tru + Trai Dat + Tram khong gian + Ban quyen
if (bg_alpha > 0) {
    draw_sprite_ext(title_bg, 0, _left, _top, _scale, _scale, 0, c_white, bg_alpha);
}

// 2. Chu MEGAMAN dan tia sang & Logo X thu vao tam
if (state < TITLE_INTRO_STATE.LOGO) {
    if (state == TITLE_INTRO_STATE.IMPACT) {
        // Bong logo trang phong to roi thu vao tam
        gpu_set_fog(true, c_white, 0, 1);
        draw_sprite_ext(logo_andromeda, 0, _cx, _cy,
            impact_scale * _scale, impact_scale * _scale, 0, c_white, 0.9);
        gpu_set_fog(false, c_white, 0, 1);
    }

    if (state == TITLE_INTRO_STATE.BEAM) {
        // Chu MEGAMAN mau trang dan ngang
        gpu_set_fog(true, c_white, 0, 1);
        draw_sprite_ext(megaman_text, 0, _cx, _cy,
            megaman_xscale * _scale, megaman_yscale * _scale, 0, c_white, 1);
        gpu_set_fog(false, c_white, 0, 1);

        // Tia sang laser trang phong ngang
        var _beam = 1 - clamp(state_frame / 15, 0, 1);
        if (_beam > 0) {
            draw_set_alpha(_beam);
            draw_line_width_colour(_left, _cy, _left + 320 * _scale, _cy,
                max(1, 2 * _scale), c_white, c_white);
            draw_set_alpha(1);
        }
    } else {
        // Chu MEGAMAN mau xanh goc
        draw_sprite_ext(megaman_text, 0, _cx, _cy,
            megaman_xscale * _scale, megaman_yscale * _scale, 0, c_white, 1);
    }
} else {
    // 3. Logo MEGAMAN X ANDROMEDA chay 11 frame vien sang
    draw_sprite_ext(logo_andromeda, floor(logo_frame), _cx, _cy,
        _scale, _scale, 0, c_white, 1);
}

// 4. Menu PRESS START & Options (GAME START / CONTINUE / OPTION)
if (state == TITLE_INTRO_STATE.MENU) {
    if (menu_state == TITLE_MENU_STATE.PRESS_START) {
        if ((menu_blink div 20) mod 2 == 0) {
            draw_sprite_ext(press_start, 0, _cx, _menu_y, _scale, _scale, 0, c_white, 1);
        }
    } else {
        draw_sprite_ext(menu_options, menu_index, _cx, _menu_y, _scale, _scale, 0, c_white, 1);
    }
    if (menu_notice_timer > 0) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_colour(c_yellow);
        draw_text(_cx, _top + 225 * _scale, menu_notice);
    }
}

// 5. Hieu ung chop trang man hinh (Screen Flash)
if (flash_alpha > 0) {
    draw_set_colour(c_white);
    draw_set_alpha(flash_alpha);
    draw_rectangle(_left, _top, _left + 320 * _scale, _top + 240 * _scale, false);
}

// 6. Letterbox den che vien ngoai vung 320x240
draw_set_alpha(1);
draw_set_colour(c_black);
if (_left > 0) {
    draw_rectangle(0, 0, _left - 1, _gh, false);
    draw_rectangle(_left + 320 * _scale, 0, _gw, _gh, false);
}
if (_top > 0) {
    draw_rectangle(0, 0, _gw, _top - 1, false);
    draw_rectangle(0, _top + 240 * _scale, _gw, _gh, false);
}

// Khoi phuc GPU states
gpu_set_texfilter(_filter);
gpu_set_fog(false, c_white, 0, 1);
draw_set_alpha(1.0);
draw_set_colour(_colour);
draw_set_halign(_halign);
draw_set_valign(_valign);
