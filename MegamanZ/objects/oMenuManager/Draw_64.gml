if (instance_exists(obj_title_intro)) return;

// Tất cả tọa độ giao diện dùng pixel gốc của canvas PS1 320x240.
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(4, 10, 24));
draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
for (var _i = 0; _i < star_count; _i++) {
    var _star = stars[_i];
    draw_set_color(c_white);
    draw_set_alpha(_star.alpha);
    draw_point(round(_star.x), round(_star.y));
}
draw_set_alpha(1);

switch (state) {
    case MENU_STATE.SPLASH:
    case MENU_STATE.TITLE:
        var _logo = state == MENU_STATE.SPLASH && state_timer < 140 ? LogoCapcom : LogoGame;
        if (sprite_exists(_logo)) {
            var _w = sprite_get_width(_logo);
            var _h = sprite_get_height(_logo);
            var _scale = min(1, min(288 / _w, 120 / _h));
            draw_sprite_ext(_logo, 0,
                160 - (_w * 0.5 - sprite_get_xoffset(_logo)) * _scale,
                90 - (_h * 0.5 - sprite_get_yoffset(_logo)) * _scale,
                _scale, _scale, 0, c_white, 1);
        }
        ps1_draw_centered(160, 164, "MEGAMAN X ANDROMEDA", 296, c_aqua);
        if (anim_timer mod 60 < 40) ps1_draw_centered(160, 204, "ENTER / Z TO START", 296, c_yellow);
        break;

    case MENU_STATE.MAIN_MENU:
        ps1_draw_centered(160, 16, "MEGAMAN X ANDROMEDA", 296, c_aqua);
        ps1_draw_panel(48, 52, 224, 132);
        for (var _k = 0; _k < menu_count; _k++) {
            var _y = 60 + _k * 28;
            if (_k == menu_index) {
                draw_set_color(make_color_rgb(16, 68, 116));
                draw_rectangle(54, _y - 2, 265, _y + 19, false);
            }
            ps1_draw_centered(160, _y, menu_options[_k], 208, _k == menu_index ? c_yellow : c_white);
        }
        ps1_draw_centered(160, 216, "UP/DOWN Z:OK X:BACK", 296, c_aqua);
        break;

    case MENU_STATE.HOW_TO_PLAY:
        ps1_draw_panel(8, 8, 304, 224);
        ps1_draw_centered(160, 16, "CONTROLS", 288, c_yellow);
        ps1_draw_text(16, 48,
            "MOVE: ARROWS / WASD\nJUMP: Z   ATTACK: X\nDASH: C   SPECIAL: V\nSWITCH HUNTER: TAB\nDEBUG: F1", 288, 144);
        ps1_draw_centered(160, 212, "Z / X / ENTER TO RETURN", 288, c_aqua);
        break;

    case MENU_STATE.CREDITS:
        ps1_draw_panel(8, 8, 304, 224, c_yellow);
        ps1_draw_centered(160, 16, "CODE ANDROMEDA", 288, c_yellow);
        ps1_draw_text(16, 48,
            "DEVELOPER: TANTKDE180504\nAI: GOOGLE DEEPMIND ANTIGRAVITY\nMEGA MAN X AND ASSETS: CAPCOM\nENGINE: GAMEMAKER 2026 LTS",
            288, 152);
        ps1_draw_centered(160, 212, "Z / X / ENTER TO RETURN", 288, c_aqua);
        break;

    case MENU_STATE.CHAR_SELECT:
        if (sprite_exists(PlayerSelect)) {
            draw_sprite_part(PlayerSelect, 0, 6, 5, 320, 240, 0, 0);
            var _scroll = (anim_timer * 1.8) mod 240;
            for (var _x = -_scroll; _x < 320; _x += 240) {
                draw_sprite_part(PlayerSelect, 0, 337, 25, 197, 18, round(_x), 6);
            }
            // Hai card chéo chồng ở dải trong suốt: giữ nguyên pixel của sheet.
            var _draw_card = function(_which) {
                var _selected = selected_char == _which;
                var _alpha = _selected ? 1 : 0.5;
                var _x = _which == 0 ? 12 : 120;
                var _y = 35;
                draw_sprite_part_ext(PlayerSelect, 0, _which == 0 ? 8 : 202, 267,
                    188, 157, _x, _y, 1, 1, c_white, _alpha);
                if (_selected) {
                    var _cycle = [0, 1, 2, 1];
                    var _frame = char_confirmed ? ((anim_timer div 2) mod 2 + 1)
                        : _cycle[(anim_timer div 4) mod 4];
                    var _lefts = _which == 0 ? [6, 219, 431] : [2, 215, 427];
                    var _rights = _which == 0 ? [118, 331, 543] : [175, 388, 600];
                    var _sy = _which == 0 ? 624 : 450;
                    draw_sprite_part(PlayerSelect, 0, _lefts[_frame], _sy,
                        _which == 0 ? 27 : 88, 169, _x - 6, _y - 6);
                    draw_sprite_part(PlayerSelect, 0, _rights[_frame], _sy,
                        _which == 0 ? 88 : 27, 169, _x - 6 + (_which == 0 ? 112 : 173), _y - 6);
                }
            };
            _draw_card(1 - selected_char);
            _draw_card(selected_char);
            draw_sprite_part(PlayerSelect, 0, 347, 60, 118, 19, 16, 196);
            draw_sprite_part(PlayerSelect, 0, 373, 95, 54, 19, 242, 196);
            var _xs = selected_char == 0 && char_confirmed ? sX_Victory : sX_Idle;
            var _zs = selected_char == 1 && char_confirmed ? sZero_Teleport_Out : sZero_Idle;
            var _xf = selected_char == 0 && char_confirmed ? min(3, floor((55 - char_confirm_timer) * 0.12)) : floor(char_anim_frame) mod sprite_get_number(_xs);
            var _zf = selected_char == 1 && char_confirmed ? 6 : floor(char_anim_frame) mod sprite_get_number(_zs);
            draw_sprite_ext(_xs, _xf, 38, 190, 1, 1, 0, c_white, selected_char == 0 ? 1 : 0.6);
            draw_sprite_ext(_zs, _zf, 282, 190, 1, 1, 0, c_white, selected_char == 1 ? 1 : 0.6);
        }
        ps1_draw_centered(160, 222, char_confirmed ? "HUNTER READY" : "LEFT/RIGHT Z:OK X:BACK", 304, c_yellow);
        break;

    case MENU_STATE.CUTSCENE:
        var _step = cutscene_script[cutscene_step];
        if (_step.is_dialogue) {
            // Hai mugshot 94x112 giữ nguyên tỉ lệ, nằm trọn trong mép 16..304.
            if (sprite_exists(Mugshots)) {
                var _hero_talk = cutscene_is_typing && cutscene_speaker_key == "hero";
                var _alia_talk = cutscene_is_typing && cutscene_speaker_key == "alia";
                var _hero_src = (selected_char == 0 ? 196 : 392)
                    + (_hero_talk && (anim_timer div 6) mod 2 == 1 ? 98 : 0);
                draw_sprite_part(Mugshots, 0, _hero_src, 0, 94, 112, 16, 8);
                draw_sprite_part(Mugshots, 0, _alia_talk && (anim_timer div 6) mod 2 == 1 ? 98 : 0,
                    0, 94, 112, 210, 8);
            }
            ps1_draw_centered(63, 122, selected_char == 0 ? "X" : "ZERO", 100, c_aqua);
            ps1_draw_centered(257, 122, "ALIA", 100, c_fuchsia);
            ps1_draw_centered(160, 28, "HQ", 88, c_aqua);
            ps1_draw_panel(8, 144, 304, 80);
            ps1_draw_text(16, 148, cutscene_speaker_name, 288, 16, c_yellow);
            ps1_draw_text(16, 168, cutscene_target_text, 288, 48, c_white, floor(cutscene_char_idx));
        } else {
            ps1_draw_centered(160, 24, "MISSION BRIEFING", 296, c_aqua);
            ps1_draw_panel(8, 64, 304, 152);
            ps1_draw_text(16, 76, cutscene_target_text, 288, 128, c_white, floor(cutscene_char_idx));
        }
        ps1_draw_centered(160, 224, cutscene_is_typing ? "Z:SHOW ALL  S:SKIP" : "Z:NEXT  S:SKIP", 304, c_yellow);
        break;

    case MENU_STATE.TRANSITION_OUT:
        ps1_draw_centered(160, 104, "WARP BEAM INITIALIZED", 296, c_aqua);
        break;
}

if (flash_alpha > 0 || fade_alpha > 0) {
    if (flash_alpha > 0) {
        draw_set_color(c_white);
        draw_set_alpha(flash_alpha);
        draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
    }
    if (fade_alpha > 0) {
        draw_set_color(c_black);
        draw_set_alpha(fade_alpha);
        draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
    }
}
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
