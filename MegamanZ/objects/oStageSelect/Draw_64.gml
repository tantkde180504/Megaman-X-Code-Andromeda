display_set_gui_size(VIEW_WIDTH, VIEW_HEIGHT);

// 1. Draw Elevator Shaft / Command Room Background
var _sy = clamp(scroll_y, 5, scroll_max);
if (sprite_exists(StageSelectBkGrd)) {
    draw_sprite_part_ext(StageSelectBkGrd, 0, 5, _sy, 320, 180, 0, 0, 1.5, 1.5, c_white, 1.0);
}

// 2. Elevator Scroll State Overlay
if (state == STAGE_SELECT_STATE.ELEVATOR_SCROLL) {
    // Cyber speed lines rushing upwards
    draw_set_color(make_color_rgb(0, 200, 255));
    draw_set_alpha(0.25);
    for (var i = 0; i < 6; i++) {
        var _lx = 100 + i * 55;
        var _ly = (anim_timer * 12 + i * 40) % VIEW_HEIGHT;
        draw_line(_lx, _ly, _lx, _ly + 30);
    }
    draw_set_alpha(1.0);
    
    // Top banner
    draw_set_color(make_color_rgb(4, 12, 35));
    draw_set_alpha(0.85);
    draw_rectangle(0, 0, VIEW_WIDTH, 26, false);
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(0, 200, 255));
    draw_rectangle(0, 25, VIEW_WIDTH, 26, false);
    
    draw_mmx_text(24, 6, "COMMAND SHAFT - DESCENDING TO HUNTER BASE", MMX_FONT.MEDIUM, 1.0, 1.0, make_color_rgb(0, 240, 255));
    
    // Bottom skip prompt
    if (floor(anim_timer / 15) % 2 == 0) {
        draw_mmx_text(VIEW_WIDTH / 2 - 80, VIEW_HEIGHT - 22, "[ENTER] FAST DESCENT", MMX_FONT.MEDIUM, 1.0, 1.0, make_color_rgb(255, 220, 50));
    }
} else {
    // 3. Draw Model LargeX on Left
    if (sprite_exists(StageX)) {
        var _box;
        if (x_anim_state == "normal") {
            x_frame_idx += x_frame_spd;
            var _f = floor(x_frame_idx) % 6;
            _box = r1_boxes[_f];
        } else if (x_anim_state == "boss_map") {
            x_frame_idx += x_frame_spd;
            var _f = floor(x_frame_idx) % 3;
            _box = r2_boss_boxes[_f];
        } else if (x_anim_state == "launch") {
            _box = r2_launch_box; // Row 2 Frame 5!
        } else {
            _box = r1_boxes[0]; // Idle pose
        }
        
        var _bx = _box[0], _by = _box[1], _bw = _box[2], _bh = _box[3];
        draw_sprite_part(StageX, 0, _bx, _by, _bw, _bh, x_pos, y_base - _bh);
        
        // Launch Teleport Beam FX
        if (x_anim_state == "launch") {
            draw_set_color(make_color_rgb(0, 240, 255));
            draw_set_alpha(teleport_beam_alpha * 0.7);
            draw_rectangle(x_pos - 6, 0, x_pos + 62, VIEW_HEIGHT, false);
            draw_set_color(c_white);
            draw_set_alpha(teleport_beam_alpha * 0.9);
            draw_rectangle(x_pos + 4, 0, x_pos + 52, VIEW_HEIGHT, false);
            draw_set_alpha(1.0);
        }
    }
    
    // 4. Upper Tactical Monitor (x: 180..452, y: 16..132)
    var _mx1 = 180, _my1 = 16, _mx2 = 452, _my2 = 132;
    // Dark cyber panel
    draw_set_color(make_color_rgb(4, 16, 42));
    draw_set_alpha(0.88);
    draw_rectangle(_mx1, _my1, _mx2, _my2, false);
    draw_set_alpha(1.0);
    
    // Double border: Outer cyan, inner navy
    draw_set_color(make_color_rgb(0, 200, 255));
    draw_rectangle(_mx1, _my1, _mx2, _my2, true);
    draw_set_color(make_color_rgb(20, 60, 110));
    draw_rectangle(_mx1 + 2, _my1 + 2, _mx2 - 2, _my2 - 2, true);
    
    if (state == STAGE_SELECT_STATE.BRIEFING) {
        // Monitor in Briefing Mode
        draw_mmx_text(_mx1 + 10, _my1 + 8, "TACTICAL TRANSMISSION FEED", MMX_FONT.MEDIUM, 1.0, 1.0, make_color_rgb(0, 240, 255));
        
        // Audio Equalizer bars
        var _eq_x = _mx1 + 20;
        var _eq_y = _my1 + 55;
        for (var b = 0; b < 24; b++) {
            var _bh = dialogue_is_typing ? (4 + 18 * abs(sin(anim_timer * 0.18 + b * 0.35))) : 3;
            draw_set_color(make_color_rgb(40, 180, 255));
            draw_rectangle(_eq_x + b * 10, _eq_y - _bh, _eq_x + b * 10 + 6, _eq_y + _bh, false);
        }
        
        draw_mmx_text(_mx1 + 14, _my1 + 85, "SECTOR RADAR: MULTIPLE MAVERICKS DETECTED", MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(255, 200, 50));
        draw_mmx_text(_mx1 + 14, _my1 + 102, "DEEP JUNGLE OUTBREAK - PRIORITY S", MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(255, 80, 80));
    } else {
        // Monitor in Stage Select Mode
        draw_mmx_text(_mx1 + 8, _my1 + 6, "STAGE SELECT - MISSION TARGETS", MMX_FONT.MEDIUM, 1.0, 1.0, make_color_rgb(0, 240, 255));
        
        // Left Column: Stages list
        for (var s = 0; s < stage_count; s++) {
            var _sy_item = _my1 + 26 + s * 24;
            var _is_sel = (s == selected_stage);
            
            if (_is_sel) {
                // Highlight bar
                draw_set_color(make_color_rgb(0, 80, 160));
                draw_set_alpha(0.65);
                draw_rectangle(_mx1 + 6, _sy_item - 2, _mx1 + 148, _sy_item + 18, false);
                draw_set_alpha(1.0);
                draw_set_color(make_color_rgb(0, 240, 255));
                draw_rectangle(_mx1 + 6, _sy_item - 2, _mx1 + 148, _sy_item + 18, true);
                
                // Cursor & Text
                draw_mmx_text(_mx1 + 10, _sy_item + 1, "> " + stages[s].name, MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(255, 230, 60));
            } else {
                draw_mmx_text(_mx1 + 14, _sy_item + 1, stages[s].name, MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(150, 180, 220));
            }
        }
        
        // Right Column: Target Details Panel
        var _cur_st = stages[selected_stage];
        var _rx = _mx1 + 158;
        
        draw_set_color(make_color_rgb(0, 120, 200));
        draw_line(_rx - 6, _my1 + 24, _rx - 6, _my2 - 6);
        
        draw_mmx_text(_rx, _my1 + 26, "CODE: " + _cur_st.code, MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(180, 210, 255));
        draw_mmx_text(_rx, _my1 + 44, "BOSS:", MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(255, 100, 100));
        draw_mmx_text(_rx, _my1 + 58, _cur_st.boss, MMX_FONT.MEDIUM, 1.0, 1.0, make_color_rgb(255, 60, 60));
        draw_mmx_text(_rx, _my1 + 78, "DANGER:", MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(255, 200, 50));
        draw_mmx_text(_rx, _my1 + 92, _cur_st.danger, MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(255, 220, 80));
    }
    
    // 5. Lower Dialogue Panel (x: 24..456, y: 184..256)
    var _bx1 = 24, _by1 = 184, _bx2 = 456, _by2 = 256;
    draw_set_color(make_color_rgb(4, 12, 35));
    draw_set_alpha(0.92);
    draw_rectangle(_bx1, _by1, _bx2, _by2, false);
    draw_set_alpha(1.0);
    
    // Double Border
    draw_set_color(c_white);
    draw_rectangle(_bx1, _by1, _bx2, _by2, true);
    draw_set_color(make_color_rgb(0, 180, 255));
    draw_rectangle(_bx1 + 2, _by1 + 2, _bx2 - 2, _by2 - 2, true);
    
    if (state == STAGE_SELECT_STATE.BRIEFING) {
        var _cur_d = dialogue_sentences[dialogue_idx];
        
        // Speaker Name
        var _spk_col = (_cur_d.speaker == "MEGA MAN X") ? make_color_rgb(80, 220, 255) : make_color_rgb(255, 220, 60);
        draw_mmx_text(_bx1 + 14, _by1 + 8, _cur_d.speaker, MMX_FONT.MEDIUM, 1.0, 1.0, _spk_col);
        
        // Typewriter Dialogue (one sentence per enter, never overflows!)
        draw_mmx_dialogue_line(_bx1 + 14, _by1 + 28, _cur_d.text, floor(dialogue_char_idx), MMX_FONT.SMALL, 1.0, 1.0, c_white);
        
        // Blinking Enter prompt when sentence finished
        if (!dialogue_is_typing) {
            if (floor(anim_timer / 15) % 2 == 0) {
                draw_mmx_text(_bx2 - 80, _by2 - 18, "[ENTER >]", MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(255, 220, 50));
            }
        }
    } else if (state == STAGE_SELECT_STATE.STAGE_SELECT) {
        var _cur_st = stages[selected_stage];
        // Line 1: Stage Title & Threat
        draw_mmx_text(_bx1 + 14, _by1 + 7, _cur_st.name + "  -  " + _cur_st.danger, MMX_FONT.MEDIUM, 1.0, 1.0, make_color_rgb(255, 220, 60));
        // Line 2: Briefing Description
        draw_mmx_text(_bx1 + 14, _by1 + 26, _cur_st.desc, MMX_FONT.SMALL, 1.0, 1.0, c_white);
        // Line 3: Footer Controls Guide
        draw_mmx_text(_bx1 + 14, _by1 + 48, "[ARROWS] SELECT STAGE    [ENTER / Z] LAUNCH MISSION", MMX_FONT.SMALL, 1.0, 1.0, make_color_rgb(0, 220, 255));
    } else if (state == STAGE_SELECT_STATE.LAUNCH) {
        var _cur_st = stages[selected_stage];
        draw_mmx_text(_bx1 + 14, _by1 + 10, "TARGET CONFIRMED: " + _cur_st.name, MMX_FONT.MEDIUM, 1.0, 1.0, make_color_rgb(0, 240, 255));
        draw_mmx_text(_bx1 + 14, _by1 + 32, "XUAT PHAT! COMMENCING MISSION...", MMX_FONT.LARGE, 1.0, 1.0, make_color_rgb(255, 230, 60));
    }
}

// 6. Fullscreen Flash & Fade
if (flash_alpha > 0.0) {
    draw_set_color(c_white);
    draw_set_alpha(flash_alpha);
    draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
    draw_set_alpha(1.0);
}

if (fade_alpha > 0.0) {
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
    draw_set_alpha(1.0);
}
