/// @desc Timeline và điều khiển menu Title Screen
var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
for (var _pad = 0; _pad < 4; _pad++) {
    if (gamepad_is_connected(_pad)) {
        _confirm = _confirm || gamepad_button_check_pressed(_pad, gp_start)
            || gamepad_button_check_pressed(_pad, gp_face1);
        _up = _up || gamepad_button_check_pressed(_pad, gp_padu);
        _down = _down || gamepad_button_check_pressed(_pad, gp_padd);
    }
}

// Bấm Enter/Space/Start bất kỳ lúc nào để Skip ngay vào màn hình Press Start
if (state != TITLE_INTRO_STATE.MENU && _confirm) {
    enter_title_state(TITLE_INTRO_STATE.MENU);
    exit;
}

flash_alpha = max(0, flash_alpha - 0.08);
state_frame++;
menu_blink++;
if (menu_notice_timer > 0) menu_notice_timer--;

// Hiệu ứng viền sáng 11 frame chạy ping-pong (0 -> 10 -> 0)
if (state >= TITLE_INTRO_STATE.LOGO) {
    logo_frame += logo_direction * 0.35;
    if (logo_frame >= 10) { logo_frame = 10; logo_direction = -1; }
    else if (logo_frame <= 0) { logo_frame = 0; logo_direction = 1; }
}

switch (state) {
    case TITLE_INTRO_STATE.BEAM:
        // Tia sáng dãn ngang thành chữ MEGAMAN (~0.5s)
        var _t = clamp(state_frame / 29, 0, 1);
        var _ease = 1 - power(1 - _t, 3);
        megaman_xscale = lerp(3, 1, _ease);
        megaman_yscale = lerp(0.05, 1, _ease);
        if (state_frame >= 30) enter_title_state(TITLE_INTRO_STATE.TEXT);
        break;

    case TITLE_INTRO_STATE.TEXT:
        // Giữ chữ MEGAMAN (~0.5s)
        if (state_frame >= 30) enter_title_state(TITLE_INTRO_STATE.IMPACT);
        break;

    case TITLE_INTRO_STATE.IMPACT:
        // Chữ X phóng to thu nhanh vào tâm (~0.33s)
        var _t = clamp(state_frame / 12, 0, 1);
        impact_scale = lerp(4.5, 1, 1 - power(1 - _t, 3));
        if (state_frame >= 20) enter_title_state(TITLE_INTRO_STATE.LOGO);
        break;

    case TITLE_INTRO_STATE.LOGO:
        // Ghép logo và chạy sáng viền (~0.66s)
        if (state_frame == 10) play_title_sound(sound_voice);
        if (state_frame >= 40) enter_title_state(TITLE_INTRO_STATE.BACKGROUND);
        break;

    case TITLE_INTRO_STATE.BACKGROUND:
        // Nền vũ trụ hiện dần lên (~0.5s)
        bg_alpha = clamp(state_frame / 30, 0, 1);
        if (state_frame >= 30) enter_title_state(TITLE_INTRO_STATE.MENU);
        break;

    case TITLE_INTRO_STATE.MENU:
        if (menu_state == TITLE_MENU_STATE.PRESS_START) {
            if (_confirm) {
                play_title_sound(sound_confirm);
                menu_state = TITLE_MENU_STATE.OPTIONS;
                exit;
            }
        } else {
            var _move = _down - _up;
            if (_move != 0) {
                menu_index = (menu_index + _move + 3) mod 3;
                play_title_sound(sound_move);
            }
            if (_confirm) {
                play_title_sound(sound_confirm);
                switch (menu_index) {
                    case 0: start_new_game(); break;
                    case 1:
                        global.title_menu_action = "continue";
                        menu_notice = "CONTINUE: CHƯA CÓ DỮ LIỆU SAVE";
                        menu_notice_timer = 180;
                        break;
                    case 2:
                        global.title_menu_action = "option";
                        menu_notice = "OPTION: CHƯA KẾT NỐI CÀI ĐẶT";
                        menu_notice_timer = 180;
                        break;
                }
            }
        }
        break;
}
