/// @desc Timeline va dieu khien menu Title Screen
var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("Z"));
var _cancel = keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_escape);
var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));

for (var _pad = 0; _pad < 4; _pad++) {
    if (gamepad_is_connected(_pad)) {
        _confirm = _confirm || gamepad_button_check_pressed(_pad, gp_start)
            || gamepad_button_check_pressed(_pad, gp_face1);
        _cancel = _cancel || gamepad_button_check_pressed(_pad, gp_face2);
        _up = _up || gamepad_button_check_pressed(_pad, gp_padu);
        _down = _down || gamepad_button_check_pressed(_pad, gp_padd);
    }
}

// Bam Enter/Space/Z/X bat ky luc nao trong intro de Skip ngay vao man hinh Press Start
if (state != TITLE_INTRO_STATE.MENU && (_confirm || _cancel)) {
    enter_title_state(TITLE_INTRO_STATE.MENU);
    exit;
}

flash_alpha = max(0, flash_alpha - 0.08);
state_frame++;
menu_blink++;
if (menu_notice_timer > 0) menu_notice_timer--;

// Chay mot vong sang vien 0 -> 10 -> 0, roi giu logo tinh trong Menu.
if (logo_animating && (state == TITLE_INTRO_STATE.LOGO || state == TITLE_INTRO_STATE.BACKGROUND)) {
    logo_frame += logo_direction * 0.35;
    if (logo_frame >= 10) { logo_frame = 10; logo_direction = -1; }
    else if (logo_frame <= 0) {
        logo_frame = 0;
        logo_direction = 1;
        logo_animating = false;
    }
}

switch (state) {
    case TITLE_INTRO_STATE.BEAM:
        // Tia sang dan ngang thanh chu MEGAMAN (~0.5s)
        var _t = clamp(state_frame / 29, 0, 1);
        var _ease = 1 - power(1 - _t, 3);
        megaman_xscale = lerp(2.5, 1, _ease);
        megaman_yscale = lerp(0.2, 1, _ease);
        if (state_frame >= 30) enter_title_state(TITLE_INTRO_STATE.TEXT);
        break;

    case TITLE_INTRO_STATE.TEXT:
        // Giu chu MEGAMAN (~0.4s)
        if (state_frame >= 25) enter_title_state(TITLE_INTRO_STATE.IMPACT);
        break;

    case TITLE_INTRO_STATE.IMPACT:
        // Chu X phong to thu nhanh vao tam (~0.33s)
        var _t = clamp(state_frame / 15, 0, 1);
        impact_scale = lerp(3.5, 1, 1 - power(1 - _t, 3));
        if (state_frame >= 18) enter_title_state(TITLE_INTRO_STATE.LOGO);
        break;

    case TITLE_INTRO_STATE.LOGO:
        // Ghep logo va chay sang vien (~0.6s)
        if (state_frame == 8) play_title_sound(sound_voice);
        if (state_frame >= 35) enter_title_state(TITLE_INTRO_STATE.BACKGROUND);
        break;

    case TITLE_INTRO_STATE.BACKGROUND:
        // Nen vu tru hien day du len (~0.4s)
        bg_alpha = clamp(0.4 + (state_frame / 25) * 0.6, 0.4, 1.0);
        if (state_frame >= 25) enter_title_state(TITLE_INTRO_STATE.MENU);
        break;

    case TITLE_INTRO_STATE.MENU:
        bg_alpha = 1.0;
        if (menu_state == TITLE_MENU_STATE.PRESS_START) {
            if (_confirm) {
                play_title_sound(sound_confirm);
                menu_state = TITLE_MENU_STATE.OPTIONS;
                exit;
            }
        } else {
            if (_cancel) {
                menu_state = TITLE_MENU_STATE.PRESS_START;
                exit;
            }
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
                        menu_notice = "CONTINUE: CHUA CO DU LIEU SAVE";
                        menu_notice_timer = 180;
                        break;
                    case 2:
                        global.title_menu_action = "option";
                        menu_notice = "OPTION: CHUA KET NOI CAI DAT";
                        menu_notice_timer = 180;
                        break;
                }
            }
        }
        break;
}
