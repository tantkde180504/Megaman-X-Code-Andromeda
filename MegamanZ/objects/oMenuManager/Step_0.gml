anim_timer++;
grid_offset = (grid_offset + 0.6) % 24;

// Update starfield
for (var i = 0; i < star_count; i++) {
    var _s = stars[i];
    _s.x -= _s.spd;
    if (_s.x < 0) {
        _s.x = VIEW_WIDTH + irandom(20);
        _s.y = irandom(VIEW_HEIGHT);
    }
}

// Global controls input check
var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _confirm = keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _cancel = keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_escape);
var _skip = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_escape);

// If oInput exists and global.input exists, blend its inputs too
if (variable_global_exists("input") && is_struct(global.input)) {
    if (variable_struct_exists(global.input, "up_pressed") && global.input.up_pressed) _up = true;
    if (variable_struct_exists(global.input, "down_pressed") && global.input.down_pressed) _down = true;
    if (variable_struct_exists(global.input, "left_pressed") && global.input.left_pressed) _left = true;
    if (variable_struct_exists(global.input, "right_pressed") && global.input.right_pressed) _right = true;
    if (variable_struct_exists(global.input, "jump_pressed") && global.input.jump_pressed) _confirm = true;
    if (variable_struct_exists(global.input, "shoot_pressed") && global.input.shoot_pressed) _cancel = true;
}

// -----------------------------------------------------------------
// State Machine Handling
// -----------------------------------------------------------------
switch (state) {
    case MENU_STATE.SPLASH:
        state_timer++;
        
        // Fading phases:
        // 0..30: Fade in Capcom splash
        // 30..110: Hold Capcom splash
        // 110..140: Fade out
        // 140..170: Fade in Andromeda Fanmade splash
        // 170..250: Hold Andromeda splash
        // 250..280: Fade out
        if (state_timer < 30) {
            fade_alpha = max(0, 1.0 - (state_timer / 30.0));
        } else if (state_timer < 110) {
            fade_alpha = 0.0;
        } else if (state_timer < 140) {
            fade_alpha = min(1.0, (state_timer - 110) / 30.0);
        } else if (state_timer < 170) {
            fade_alpha = max(0, 1.0 - ((state_timer - 140) / 30.0));
        } else if (state_timer < 250) {
            fade_alpha = 0.0;
        } else if (state_timer < 280) {
            fade_alpha = min(1.0, (state_timer - 250) / 30.0);
        } else {
            state = MENU_STATE.TITLE;
            state_timer = 0;
            fade_alpha = 1.0;
        }
        
        // Skip Splash immediately on key press
        if (_confirm || _cancel || _skip) {
            state = MENU_STATE.TITLE;
            state_timer = 0;
            fade_alpha = 0.0;
            flash_alpha = 0.8;
        }
        break;

    case MENU_STATE.TITLE:
        fade_alpha = max(0, fade_alpha - 0.05);
        flash_alpha = max(0, flash_alpha - 0.05);
        state_timer++;
        
        if (_confirm) {
            flash_alpha = 1.0;
            state = MENU_STATE.MAIN_MENU;
            state_timer = 0;
        }
        break;

    case MENU_STATE.MAIN_MENU:
        flash_alpha = max(0, flash_alpha - 0.05);
        
        if (_up) {
            menu_index = (menu_index - 1 + menu_count) % menu_count;
        }
        if (_down) {
            menu_index = (menu_index + 1) % menu_count;
        }
        if (_cancel) {
            state = MENU_STATE.TITLE;
        }
        if (_confirm) {
            flash_alpha = 0.5;
            switch (menu_index) {
                case 0: // GAME START
                    state = MENU_STATE.CHAR_SELECT;
                    char_confirmed = false;
                    char_confirm_timer = 0;
                    break;
                case 1: // HOW TO PLAY
                    state = MENU_STATE.HOW_TO_PLAY;
                    break;
                case 2: // CREDITS
                    state = MENU_STATE.CREDITS;
                    break;
                case 3: // EXIT GAME
                    game_end();
                    break;
            }
        }
        break;

    case MENU_STATE.HOW_TO_PLAY:
    case MENU_STATE.CREDITS:
        if (_confirm || _cancel) {
            state = MENU_STATE.MAIN_MENU;
        }
        break;

    case MENU_STATE.CHAR_SELECT:
        flash_alpha = max(0, flash_alpha - 0.05);
        char_anim_frame += 0.12;
        
        if (!char_confirmed) {
            if (_left) {
                selected_char = 0; // X
                flash_alpha = 0.25;
            }
            if (_right) {
                selected_char = 1; // Zero
                flash_alpha = 0.25;
            }
            if (_cancel) {
                state = MENU_STATE.MAIN_MENU;
            }
            if (_confirm) {
                char_confirmed = true;
                char_confirm_timer = 40; // Hold celebratory pose
                flash_alpha = 0.9;
            }
        } else {
            char_confirm_timer--;
            if (char_confirm_timer <= 0) {
                // Advance to Story Cutscene!
                state = MENU_STATE.CUTSCENE;
                cutscene_page = 0;
                cutscene_char_idx = 0;
                cutscene_text = "";
                var _cname = (selected_char == 0) ? "MEGA MAN X" : "ZERO";
                cutscene_target_text = string_replace_all(story_pages[0], "[CHAR_NAME]", _cname);
                flash_alpha = 0.7;
            }
        }
        break;

    case MENU_STATE.CUTSCENE:
        flash_alpha = max(0, flash_alpha - 0.05);
        cutscene_scanline = (cutscene_scanline + 1) % 270;
        
        // Typewriter progression
        var _total_len = string_length(cutscene_target_text);
        if (cutscene_char_idx < _total_len) {
            cutscene_char_idx += cutscene_type_speed;
            cutscene_text = string_copy(cutscene_target_text, 1, floor(cutscene_char_idx));
        }
        
        // Skip current page or entire cutscene
        if (_skip) {
            // Skip straight to mission
            state = MENU_STATE.TRANSITION_OUT;
            fade_alpha = 0.0;
        } else if (_confirm) {
            if (cutscene_char_idx < _total_len) {
                // Finish typing immediately
                cutscene_char_idx = _total_len;
                cutscene_text = cutscene_target_text;
            } else {
                // Next page
                cutscene_page++;
                if (cutscene_page < array_length(story_pages)) {
                    cutscene_char_idx = 0;
                    cutscene_text = "";
                    var _cname = (selected_char == 0) ? "MEGA MAN X" : "ZERO";
                    cutscene_target_text = string_replace_all(story_pages[cutscene_page], "[CHAR_NAME]", _cname);
                } else {
                    // All pages complete! Transition to Stage Intro
                    state = MENU_STATE.TRANSITION_OUT;
                    fade_alpha = 0.0;
                }
            }
        }
        break;

    case MENU_STATE.TRANSITION_OUT:
        fade_alpha = min(1.0, fade_alpha + 0.04);
        if (fade_alpha >= 1.0) {
            // Apply chosen character
            global.current_char = (selected_char == 0) ? CHAR_TYPE.X : CHAR_TYPE.ZERO;
            global.checkpoint_x = 64;
            global.checkpoint_y = 480;
            room_goto(rStage_Intro);
        }
        break;
}
