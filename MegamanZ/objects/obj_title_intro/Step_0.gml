/// @desc Timeline va dieu khien menu Title Screen
var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("Z"));
var _cancel = keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_escape);
var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));

// Settings use fixed navigation so rebinding cannot strand the player.
var _controls_open = state == TITLE_INTRO_STATE.MENU && menu_state == TITLE_MENU_STATE.CONTROLS;
var _settings_open = state == TITLE_INTRO_STATE.MENU && menu_state == TITLE_MENU_STATE.SETTINGS;
var _left = keyboard_check_pressed(vk_left);
var _right = keyboard_check_pressed(vk_right);
if (_controls_open || _settings_open) {
    _confirm = keyboard_check_pressed(vk_enter);
    _cancel = keyboard_check_pressed(vk_escape);
    _up = keyboard_check_pressed(vk_up);
    _down = keyboard_check_pressed(vk_down);
}

for (var _pad = 0; _pad < 4; _pad++) {
    if (gamepad_is_connected(_pad)) {
        _confirm = _confirm || gamepad_button_check_pressed(_pad, gp_start)
            || gamepad_button_check_pressed(_pad, gp_face1);
        _cancel = _cancel || gamepad_button_check_pressed(_pad, gp_face2);
        _up = _up || gamepad_button_check_pressed(_pad, gp_padu);
        _down = _down || gamepad_button_check_pressed(_pad, gp_padd);
        _left = _left || gamepad_button_check_pressed(_pad, gp_padl);
        _right = _right || gamepad_button_check_pressed(_pad, gp_padr);
    }
}

if (_settings_open) {
    if (_cancel) {
        menu_state = TITLE_MENU_STATE.OPTIONS;
        exit;
    }
    var _move = _down - _up;
    if (_move != 0) {
        settings_row = (settings_row + _move + 4) mod 4;
        play_title_sound(sound_move);
    }
    if (_confirm || _left || _right) {
        switch (settings_row) {
            case 0:
                if (_confirm) {
                    menu_state = TITLE_MENU_STATE.CONTROLS;
                    controls_capturing = false;
                    controls_message = "ARROWS: SELECT  ENTER: EDIT  ESC: BACK";
                }
                break;
            case 1:
                display_settings_toggle_fullscreen();
                play_title_sound(sound_confirm);
                break;
            case 2:
                display_settings_cycle_size(_left ? -1 : 1);
                play_title_sound(sound_move);
                break;
            case 3:
                if (_confirm) menu_state = TITLE_MENU_STATE.OPTIONS;
                break;
        }
    }
    exit;
}

if (_controls_open) {
    var _action_count = array_length(global.key_actions);
    if (controls_capturing) {
        if (_cancel) {
            controls_capturing = false;
            controls_message = "CANCELLED. ENTER: EDIT  ESC: BACK";
            exit;
        }
        // Wait for the activation key to be released before accepting a new key.
        if (!controls_capture_armed) {
            if (!keyboard_check(vk_anykey)) controls_capture_armed = true;
            exit;
        }
        var _key = 0;
        for (var _code = 8; _code <= 255; _code++) {
            if (keyboard_check_pressed(_code)) { _key = _code; break; }
        }
        // Windows reports modifiers with generic codes; retain their physical side.
        if (_key == vk_shift) _key = keyboard_check_direct(vk_rshift) ? vk_rshift : vk_lshift;
        if (_key == vk_control) _key = keyboard_check_direct(vk_rcontrol) ? vk_rcontrol : vk_lcontrol;
        if (_key == vk_alt) _key = keyboard_check_direct(vk_ralt) ? vk_ralt : vk_lalt;
        if (_key == 0) exit;
        if (!input_binding_key_valid(_key)) {
            controls_message = "RESERVED KEY. CHOOSE ANOTHER. ESC: CANCEL";
            exit;
        }
        for (var _a = 0; _a < _action_count; _a++) {
            for (var _s = 0; _s < 3; _s++) {
                if (_a == controls_row && _s == controls_slot) continue;
                if (global.key_bindings[_a][_s] == _key) {
                    controls_message = "KEY USED BY " + global.key_labels[_a] + ". TRY AGAIN.";
                    exit;
                }
            }
        }
        global.key_bindings[controls_row][controls_slot] = _key;
        input_bindings_save();
        controls_capturing = false;
        controls_message = "SAVED. DEL: CLEAR SLOT  ESC: BACK";
        play_title_sound(sound_confirm);
        exit;
    }
    if (_cancel) {
        menu_state = TITLE_MENU_STATE.SETTINGS;
        exit;
    }
    var _move = _down - _up;
    if (_move != 0) {
        controls_row = (controls_row + _move + _action_count + 2) mod (_action_count + 2);
        play_title_sound(sound_move);
    }
    controls_slot = (controls_slot + _right - _left + 3) mod 3;
    if (controls_row < _action_count && keyboard_check_pressed(vk_delete)) {
        var _keys = global.key_bindings[controls_row];
        var _remaining = 0;
        for (var _s = 0; _s < 3; _s++) {
            if (_s != controls_slot && _keys[_s] != 0) _remaining++;
        }
        if (_remaining > 0) {
            global.key_bindings[controls_row][controls_slot] = 0;
            input_bindings_save();
            controls_message = "SAVED. ENTER: EDIT  ESC: BACK";
        } else {
            controls_message = "KEEP AT LEAST ONE KEY FOR EACH ACTION.";
        }
    }
    if (_confirm) {
        if (controls_row < _action_count) {
            controls_capturing = true;
            controls_capture_armed = false;
            controls_message = "PRESS A NEW KEY. ESC: CANCEL";
        } else if (controls_row == _action_count) {
            global.key_bindings = input_bindings_defaults();
            input_bindings_save();
            controls_message = "DEFAULT CONTROLS RESTORED AND SAVED.";
            play_title_sound(sound_confirm);
        } else {
            menu_state = TITLE_MENU_STATE.SETTINGS;
        }
    }
    exit;
}

// Bam Enter/Space/Z/X bat ky luc nao trong intro de Skip ngay vao man hinh Press Start
if (state != TITLE_INTRO_STATE.MENU && (_confirm || _cancel)) {
    enter_title_state(TITLE_INTRO_STATE.MENU);
    exit;
}

if (intro_audio_pending) {
    intro_audio_pending = false;
    play_title_sound(sound_beam);
    bgm_handle = play_title_sound(sound_bgm, false);
    intro_audio_started = bgm_handle != noone && bgm_handle != -1;
}

flash_alpha = max(0, flash_alpha - 0.08);
state_frame++;
menu_blink++;
if (menu_notice_timer > 0) menu_notice_timer--;

// Sync to second 7 of the Title track; use the frame clock if audio is unavailable.
intro_elapsed_frames++;
var _intro_playing = intro_audio_started && audio_is_playing(bgm_handle);
var _intro_position = _intro_playing ? audio_sound_get_track_position(bgm_handle) : intro_elapsed_frames / 60;
if (_intro_position >= logo_reveal_time && state < TITLE_INTRO_STATE.LOGO) {
    enter_title_state(TITLE_INTRO_STATE.LOGO);
}

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
        // Start the approaching X at 6.7s, then reveal the complete logo at 7s.
        if (_intro_position >= logo_reveal_time - 18 / 60) {
            enter_title_state(TITLE_INTRO_STATE.IMPACT);
        }
        break;

    case TITLE_INTRO_STATE.IMPACT:
        // Chu X phong to thu nhanh vao tam (~0.33s)
        var _t = clamp(state_frame / 15, 0, 1);
        impact_scale = lerp(3.5, 1, 1 - power(1 - _t, 3));
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
                        menu_state = TITLE_MENU_STATE.SETTINGS;
                        settings_row = 0;
                        controls_row = 0;
                        controls_slot = 0;
                        controls_capturing = false;
                        controls_message = "ARROWS: SELECT  ENTER: EDIT  ESC: BACK";
                        menu_notice_timer = 0;
                        break;
                }
            }
        }
        break;
}
