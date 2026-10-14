anim_timer++;
flash_alpha = max(0.0, flash_alpha - 0.05);

// Input checks
var _btn_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_space);
var _btn_left    = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
var _btn_right   = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _btn_up      = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var _btn_down    = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));

switch (state) {
    case STAGE_SELECT_STATE.ELEVATOR_SCROLL:
        // Slow descent down elevator shaft
        scroll_y += scroll_spd;
        
        // Fast skip descent on enter
        if (_btn_confirm) {
            scroll_y = scroll_max;
        }
        
        // Arrived at command room
        if (scroll_y >= scroll_max) {
            scroll_y = scroll_max;
            flash_alpha = 0.6;
            state = STAGE_SELECT_STATE.BRIEFING;
            dialogue_idx = 0;
            dialogue_char_idx = 0.0;
            dialogue_is_typing = true;
        }
        break;

    case STAGE_SELECT_STATE.BRIEFING:
        var _cur = dialogue_sentences[dialogue_idx];
        var _full_len = string_length(_cur.text);
        
        if (dialogue_char_idx < _full_len) {
            dialogue_char_idx += dialogue_type_spd;
            dialogue_is_typing = true;
            x_anim_state = _cur.anim;
        } else {
            dialogue_is_typing = false;
            x_anim_state = "idle";
        }
        
        if (_btn_confirm) {
            if (dialogue_is_typing) {
                // Reveal full sentence immediately
                dialogue_char_idx = _full_len;
                dialogue_is_typing = false;
                x_anim_state = "idle";
            } else {
                // Advance to next sentence
                dialogue_idx++;
                if (dialogue_idx < array_length(dialogue_sentences)) {
                    dialogue_char_idx = 0.0;
                    dialogue_is_typing = true;
                } else {
                    // Briefing finished, enter stage select!
                    state = STAGE_SELECT_STATE.STAGE_SELECT;
                    x_anim_state = stages[selected_stage].anim;
                }
            }
        }
        break;

    case STAGE_SELECT_STATE.STAGE_SELECT:
        // Cycle stages
        if (_btn_left || _btn_up) {
            selected_stage = (selected_stage - 1 + stage_count) % stage_count;
        }
        if (_btn_right || _btn_down) {
            selected_stage = (selected_stage + 1) % stage_count;
        }
        
        // Update animation of LargeX based on highlighted stage/boss
        x_anim_state = stages[selected_stage].anim;
        
        // Confirm stage and launch!
        if (_btn_confirm) {
            state = STAGE_SELECT_STATE.LAUNCH;
            x_anim_state = "launch";
            launch_timer = 0;
            flash_alpha = 1.0;
        }
        break;

    case STAGE_SELECT_STATE.LAUNCH:
        x_anim_state = "launch";
        launch_timer++;
        teleport_beam_alpha = min(1.0, teleport_beam_alpha + 0.08);
        
        if (launch_timer > 50) {
            fade_alpha = min(1.0, fade_alpha + 0.04);
            if (fade_alpha >= 1.0) {
                var _st = stages[selected_stage];
                global.checkpoint_x = _st.spawn_x;
                global.checkpoint_y = _st.spawn_y;
                room_goto(_st.room_id);
            }
        }
        break;
}
