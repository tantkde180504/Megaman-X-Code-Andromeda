/// @desc Khoi tao Title Intro & Menu logic 320x240 (MMX4 Authentic)
enum TITLE_INTRO_STATE { BEAM, TEXT, IMPACT, LOGO, BACKGROUND, MENU }
enum TITLE_MENU_STATE { PRESS_START, OPTIONS }

if (instance_number(obj_title_intro) > 1) {
    instance_destroy();
    exit;
}

// Nap resource sprite truc tiep
title_bg = spr_title_bg;
megaman_text = spr_megaman_text;
logo_andromeda = spr_logo_andromeda;
press_start = spr_menu_press_start;
menu_options = spr_menu_options;

state = TITLE_INTRO_STATE.BEAM;
state_frame = -1;
menu_state = TITLE_MENU_STATE.PRESS_START;
menu_index = 0;
menu_blink = 0;
logo_frame = 0;
logo_direction = 1;
logo_animating = false;

megaman_xscale = 2.5;
megaman_yscale = 0.2;
impact_scale = 3.5;
flash_alpha = 0.0;
bg_alpha = 0.4; // Nen vu tru sang nhe ngay tu frame 0 de khong bao gio bi man hinh den

menu_notice = "";
menu_notice_timer = 0;
depth = -100;
global.title_intro_done = false;
global.title_menu_action = "";

// Am thanh chinh thong cua Mega Man X4
sound_beam = snd_teleport_in;
sound_slash = snd_zero_slash;
sound_impact = snd_x_charge_shot_full;
sound_voice = snd_x_shot_lv3;
sound_confirm = snd_teleport_out;
sound_move = snd_x_shot;
sound_bgm = snd_bgm_title;
bgm_handle = noone;

play_title_sound = function(_asset, _loop = false) {
    if (_asset != -1 && audio_exists(_asset)) {
        return audio_play_sound(_asset, 90, _loop);
    }
    return noone;
};

enter_title_state = function(_state) {
    state = _state;
    state_frame = 0;
    switch (_state) {
        case TITLE_INTRO_STATE.TEXT:
            flash_alpha = 0.9;
            megaman_xscale = 1.0;
            megaman_yscale = 1.0;
            if (bgm_handle == noone) bgm_handle = play_title_sound(sound_bgm, true);
            break;
        case TITLE_INTRO_STATE.IMPACT:
            impact_scale = 3.5;
            play_title_sound(sound_slash);
            break;
        case TITLE_INTRO_STATE.LOGO:
            flash_alpha = 0.9;
            impact_scale = 1.0;
            logo_frame = 0;
            logo_direction = 1;
            logo_animating = true;
            play_title_sound(sound_impact);
            break;
        case TITLE_INTRO_STATE.BACKGROUND:
            bg_alpha = 0.5;
            break;
        case TITLE_INTRO_STATE.MENU:
            bg_alpha = 1.0;
            flash_alpha = 0.0;
            logo_frame = 0;
            logo_animating = false;
            menu_blink = 0;
            global.title_intro_done = true;
            if (bgm_handle == noone) bgm_handle = play_title_sound(sound_bgm, true);
            break;
    }
};

start_new_game = function() {
    global.title_menu_action = "game_start";
    if (bgm_handle != noone && audio_is_playing(bgm_handle)) {
        audio_stop_sound(bgm_handle);
        bgm_handle = noone;
    }
    music_play_player_select();
    if (instance_exists(oMenuManager)) {
        with (oMenuManager) {
            state = MENU_STATE.CHAR_SELECT;
            state_timer = 0;
            fade_alpha = 0;
            flash_alpha = 0;
            char_confirmed = false;
            selected_char = 0;
            title_intro_input_cooldown = 2;
        }
    }
    instance_destroy();
};

if (variable_instance_exists(id, "start_in_menu") && start_in_menu) {
    enter_title_state(TITLE_INTRO_STATE.MENU);
    menu_state = TITLE_MENU_STATE.OPTIONS;
} else {
    play_title_sound(sound_beam);
}
