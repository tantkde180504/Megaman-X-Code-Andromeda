// -------------------------------------------------------------
// 1. BACKGROUND: Deep Space & Cyber Grid
// -------------------------------------------------------------
draw_set_color(make_color_rgb(8, 12, 22)); // Deep space navy
draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);

// Draw Starfield
for (var i = 0; i < star_count; i++) {
    var _s = stars[i];
    draw_set_color(c_white);
    draw_set_alpha(_s.alpha * (0.8 + 0.2 * dsin((anim_timer * 2) + (i * 15))));
    if (_s.size == 1) {
        draw_point(_s.x, _s.y);
    } else {
        draw_rectangle(_s.x, _s.y, _s.x + 1, _s.y + 1, false);
    }
}
draw_set_alpha(1.0);

// Draw Cyber Grid (Horizon at y=190, converging perspective lines)
var _horizon_y = 190;
draw_set_color(make_color_rgb(20, 50, 110)); // Grid neon blue
draw_set_alpha(0.35);
// Horizontal lines with perspective spacing
var _y_steps = [190, 196, 204, 214, 226, 240, 256, 270];
for (var j = 0; j < array_length(_y_steps); j++) {
    draw_line(0, _y_steps[j], VIEW_WIDTH, _y_steps[j]);
}
// Vertical perspective lines
for (var _gx = -60 + grid_offset; _gx < VIEW_WIDTH + 60; _gx += 24) {
    draw_line(240 + ((_gx - 240) * 0.15), _horizon_y, _gx, VIEW_HEIGHT);
}
draw_set_alpha(1.0);

// -------------------------------------------------------------
// 2. STATE SPECIFIC DRAWING
// -------------------------------------------------------------
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

switch (state) {
    case MENU_STATE.SPLASH:
        // Capcom & Fanmade Splash
        if (state_timer < 140) {
            // Screen 1: Capcom Official Logo Tribute
            if (sprite_exists(LogoCapcom)) {
                var _cw = sprite_get_width(LogoCapcom);
                var _ch = sprite_get_height(LogoCapcom);
                var _c_scale = 220 / _cw;
                var _c_ox = sprite_get_xoffset(LogoCapcom);
                var _c_oy = sprite_get_yoffset(LogoCapcom);
                var _c_dx = 240 - (_cw * 0.5 - _c_ox) * _c_scale;
                var _c_dy = 100 - (_ch * 0.5 - _c_oy) * _c_scale;
                draw_sprite_ext(LogoCapcom, 0, _c_dx, _c_dy, _c_scale, _c_scale, 0, c_white, 1.0);
            } else {
                draw_set_color(make_color_rgb(255, 215, 0)); // Capcom Gold
                draw_text_transformed(240, 100, "CAPCOM", 2.2, 2.2, 0);
            }
            
            draw_set_color(make_color_rgb(80, 200, 255)); // Cyan
            draw_text(240, 140, "PRESENTS");
            
            draw_set_color(make_color_rgb(180, 190, 210));
            draw_text(240, 175, "A TRIBUTE TO THE LEGENDARY MEGA MAN X SERIES");
            draw_set_color(make_color_rgb(120, 130, 150));
            draw_text(240, 240, "[ PRESS ANY KEY TO SKIP ]");
        } else {
            // Screen 2: Andromeda Fanmade Splash
            draw_set_color(make_color_rgb(40, 220, 255));
            draw_text(240, 60, "MEGAMAN X FANMADE PRODUCTION");
            
            if (sprite_exists(LogoGame)) {
                var _gw = sprite_get_width(LogoGame);
                var _gh = sprite_get_height(LogoGame);
                var _g_scale = 230 / _gw;
                var _g_ox = sprite_get_xoffset(LogoGame);
                var _g_oy = sprite_get_yoffset(LogoGame);
                var _g_dx = 240 - (_gw * 0.5 - _g_ox) * _g_scale;
                var _g_dy = 125 - (_gh * 0.5 - _g_oy) * _g_scale;
                draw_sprite_ext(LogoGame, 0, _g_dx, _g_dy, _g_scale, _g_scale, 0, c_white, 1.0);
            } else {
                draw_set_color(make_color_rgb(255, 200, 40));
                draw_text_transformed(240, 125, "CODE: ANDROMEDA", 1.8, 1.8, 0);
            }
            
            draw_set_color(make_color_rgb(170, 180, 200));
            draw_text(240, 185, "DEEPMIND AGENTIC PAIR-PROGRAMMING ENGINE");
            draw_set_color(make_color_rgb(120, 130, 150));
            draw_text(240, 240, "[ PRESS ANY KEY TO SKIP ]");
        }
        break;

    case MENU_STATE.TITLE:
        // Draw LogoGame with floating effect and cyber bloom
        var _float_y = 82 + 2.0 * dsin(anim_timer * 2.5);
        if (sprite_exists(LogoGame)) {
            var _gw = sprite_get_width(LogoGame);
            var _gh = sprite_get_height(LogoGame);
            var _pulse = 1.0 + 0.015 * dsin(anim_timer * 3);
            var _g_scale = (290 / _gw) * _pulse;
            var _g_ox = sprite_get_xoffset(LogoGame);
            var _g_oy = sprite_get_yoffset(LogoGame);
            var _g_dx = 240 - (_gw * 0.5 - _g_ox) * _g_scale;
            var _g_dy = _float_y - (_gh * 0.5 - _g_oy) * _g_scale;
            
            // Cyber glow halo behind logo
            draw_set_color(make_color_rgb(0, 140, 255));
            draw_set_alpha(0.18 + 0.08 * dsin(anim_timer * 4));
            draw_ellipse(240 - 150, _float_y - 45, 240 + 150, _float_y + 45, false);
            draw_set_alpha(1.0);
            
            // Draw Main Game Logo
            draw_sprite_ext(LogoGame, 0, _g_dx, _g_dy, _g_scale, _g_scale, 0, c_white, 1.0);
            
            // Light shimmer bar
            var _shim_x = (anim_timer * 5) % (VIEW_WIDTH + 140) - 70;
            draw_set_color(c_white);
            draw_set_alpha(0.18);
            draw_rectangle(_shim_x - 12, _float_y - 50, _shim_x + 12, _float_y + 50, false);
            draw_set_alpha(1.0);
        } else {
            // Fallback text if sprite missing
            draw_set_color(make_color_rgb(10, 20, 50));
            draw_text_transformed(242, 67, "MEGA MAN X", 2.6, 2.6, 0);
            draw_set_color(make_color_rgb(180, 240, 255));
            draw_text_transformed(240, 64, "MEGA MAN X", 2.4, 2.4, 0);
            draw_set_color(make_color_rgb(255, 180, 30));
            draw_text_transformed(240, 106, "- CODE ANDROMEDA -", 1.5, 1.5, 0);
        }
        
        // Press Start prompt (pulsing)
        var _start_alpha = max(0, dsin(anim_timer * 5));
        draw_set_color(make_color_rgb(255, 255, 100));
        draw_set_alpha(_start_alpha);
        draw_text_transformed(240, 180, "- PRESS START -", 1.3, 1.3, 0);
        draw_set_color(c_white);
        draw_text(240, 202, "[ PRESS ENTER / SPACE / Z ]");
        draw_set_alpha(1.0);
        
        // Footer
        draw_set_color(make_color_rgb(100, 115, 145));
        draw_text(240, 254, "(C) 2026 FANMADE TRIBUTE PROJECT // FOR FANS BY FANS");
        break;

    case MENU_STATE.MAIN_MENU:
        // Mini Header using LogoGame
        if (sprite_exists(LogoGame)) {
            var _gw = sprite_get_width(LogoGame);
            var _gh = sprite_get_height(LogoGame);
            var _m_scale = 135 / _gw;
            var _m_ox = sprite_get_xoffset(LogoGame);
            var _m_oy = sprite_get_yoffset(LogoGame);
            var _m_dx = 240 - (_gw * 0.5 - _m_ox) * _m_scale;
            var _m_dy = 36 - (_gh * 0.5 - _m_oy) * _m_scale;
            draw_sprite_ext(LogoGame, 0, _m_dx, _m_dy, _m_scale, _m_scale, 0, c_white, 0.95);
        } else {
            draw_set_color(make_color_rgb(0, 180, 255));
            draw_text_transformed(240, 35, "MEGA MAN X: CODE ANDROMEDA", 1.3, 1.3, 0);
        }
        
        // Menu Panel Box
        var _mx1 = 140, _my1 = 70, _mx2 = 340, _my2 = 215;
        draw_set_color(make_color_rgb(12, 18, 32));
        draw_set_alpha(0.85);
        draw_rectangle(_mx1, _my1, _mx2, _my2, false);
        draw_set_alpha(1.0);
        
        // Outer neon border
        draw_set_color(make_color_rgb(40, 160, 240));
        draw_rectangle(_mx1, _my1, _mx2, _my2, true);
        // Corner tech accents
        draw_set_color(make_color_rgb(255, 200, 40));
        draw_rectangle(_mx1 - 2, _my1 - 2, _mx1 + 6, _my1 + 6, false);
        draw_rectangle(_mx2 - 6, _my1 - 2, _mx2 + 2, _my1 + 6, false);
        draw_rectangle(_mx1 - 2, _my2 - 6, _mx1 + 6, _my2 + 2, false);
        draw_rectangle(_mx2 - 6, _my2 - 6, _mx2 + 2, _my2 + 2, false);
        
        // Menu Items
        for (var k = 0; k < menu_count; k++) {
            var _item_y = 96 + (k * 28);
            var _is_sel = (k == menu_index);
            
            if (_is_sel) {
                // Highlight box
                draw_set_color(make_color_rgb(20, 60, 120));
                draw_set_alpha(0.65);
                draw_rectangle(_mx1 + 8, _item_y - 10, _mx2 - 8, _item_y + 10, false);
                draw_set_alpha(1.0);
                
                // Cursor and Glowing Text
                draw_set_color(make_color_rgb(255, 230, 40));
                draw_text_transformed(240, _item_y, ">  " + menu_options[k] + "  <", 1.15, 1.15, 0);
            } else {
                draw_set_color(make_color_rgb(160, 175, 200));
                draw_text(240, _item_y, menu_options[k]);
            }
        }
        
        // Hint footer
        draw_set_color(make_color_rgb(120, 140, 170));
        draw_text(240, 246, "[UP/DOWN] SELECT  |  [Z/ENTER] CONFIRM  |  [X/ESC] BACK");
        break;

    case MENU_STATE.HOW_TO_PLAY:
        // Controls Guide Modal
        var _hx1 = 40, _hy1 = 30, _hx2 = 440, _hy2 = 240;
        draw_set_color(make_color_rgb(10, 16, 28));
        draw_set_alpha(0.92);
        draw_rectangle(_hx1, _hy1, _hx2, _hy2, false);
        draw_set_alpha(1.0);
        draw_set_color(make_color_rgb(40, 180, 255));
        draw_rectangle(_hx1, _hy1, _hx2, _hy2, true);
        
        draw_set_color(make_color_rgb(255, 215, 40));
        draw_text_transformed(240, 48, "- CONTROLS GUIDE -", 1.2, 1.2, 0);
        
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        var _lx = 70;
        draw_text(_lx, 80,  "- MOVE:          Arrow Keys / WASD");
        draw_text(_lx, 102, "- JUMP:          [ Z ]");
        draw_text(_lx, 124, "- ATTACK:        [ X ] (Buster Shot / Z-Saber)");
        draw_text(_lx, 146, "- DASH:          [ C ] (Supports Air Dash)");
        draw_text(_lx, 168, "- SPECIAL TECH:  [ V ] (Ryuenjin, Hyouretsuzan, Raijingeki)");
        draw_text(_lx, 190, "- DEBUG / CHAR:  [ TAB ] Switch Hunter  |  [ F1 ] Hitbox Display");
        
        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(255, 200, 40));
        draw_text(240, 222, "[ PRESS Z / X / ENTER TO RETURN ]");
        break;

    case MENU_STATE.CREDITS:
        // Credits Modal
        var _cx1 = 50, _cy1 = 35, _cx2 = 430, _cy2 = 235;
        draw_set_color(make_color_rgb(10, 16, 28));
        draw_set_alpha(0.92);
        draw_rectangle(_cx1, _cy1, _cx2, _cy2, false);
        draw_set_alpha(1.0);
        draw_set_color(make_color_rgb(255, 180, 40));
        draw_rectangle(_cx1, _cy1, _cx2, _cy2, true);
        
        draw_set_color(make_color_rgb(255, 215, 40));
        draw_text_transformed(240, 55, "- MEGAMAN X: CODE ANDROMEDA -", 1.2, 1.2, 0);
        
        draw_set_color(c_white);
        draw_text(240, 90,  "Lead Developer & Gameplay: tantkde180504");
        draw_text(240, 115, "AI Pair Programmer & Architect: Google Deepmind Antigravity");
        draw_text(240, 140, "Original Mega Man X Characters & Assets (C) Capcom Co., Ltd.");
        draw_text(240, 165, "Engine: GameMaker 2026 LTS (Custom GML Pixel-Perfect Engine)");
        
        draw_set_color(make_color_rgb(40, 220, 255));
        draw_text(240, 212, "[ PRESS Z / X / ENTER TO RETURN ]");
        break;

    case MENU_STATE.CHAR_SELECT:
        // =========================================================
        // AUTHENTIC MEGA MAN X4 CHARACTER SELECT SCREEN
        // =========================================================
        if (sprite_exists(PlayerSelect)) {
            // 1. Full Screen Green Tech Background (scaled from 320x240 to 480x270)
            draw_sprite_part_ext(PlayerSelect, 0, 6, 5, 320, 240, 0, 0, 480 / 320, 270 / 240, c_white, 1.0);
            
            // 2. Dual Running "PLAYER SELECT" Banners
            // Top marquee (scrolls to the left)
            var _top_scroll = (anim_timer * 1.8) % 240;
            for (var _bx = -_top_scroll - 40; _bx < VIEW_WIDTH + 240; _bx += 240) {
                draw_sprite_part(PlayerSelect, 0, 337, 25, 197, 18, _bx, 14);
            }
            // Bottom marquee (scrolls to the right)
            var _bot_scroll = (anim_timer * 1.8) % 240;
            for (var _bx = -240 + _bot_scroll; _bx < VIEW_WIDTH + 240; _bx += 240) {
                draw_sprite_part(PlayerSelect, 0, 337, 25, 197, 18, _bx, 238);
            }
            
            // 3. Card Positions
            var _dx1 = 44, _dy1 = 46;   // X Portrait (188 x 157)
            var _dx2 = 248, _dy2 = 46;  // Zero Portrait (188 x 157)
            
            var _x_sel = (selected_char == 0);
            var _z_sel = (selected_char == 1);
            
            var _x_alpha = _x_sel ? 1.0 : 0.55;
            var _z_alpha = _z_sel ? 1.0 : 0.55;
            
            // 4. Draw Character Portraits
            draw_sprite_part_ext(PlayerSelect, 0, 8, 267, 188, 157, _dx1, _dy1, 1.0, 1.0, c_white, _x_alpha);
            draw_sprite_part_ext(PlayerSelect, 0, 202, 267, 188, 157, _dx2, _dy2, 1.0, 1.0, c_white, _z_alpha);
            
            // 5. Draw Card Name Labels
            draw_sprite_part_ext(PlayerSelect, 0, 347, 60, 118, 19, 104, 176, 1.0, 1.0, c_white, _x_alpha);
            draw_sprite_part_ext(PlayerSelect, 0, 373, 95, 54, 19, 292, 176, 1.0, 1.0, c_white, _z_alpha);
            
            // 6. Animated Blinking Neon Brackets & Reticles
            var _glow_seq = [0, 1, 2, 1];
            var _glow_frame = char_confirmed ? ((anim_timer % 4 < 2) ? 1 : 2) : _glow_seq[floor((anim_timer / 4) % 4)];
            
            if (_x_sel) {
                // X Neon Brackets (Region 4, Y: 624, H: 169)
                var _x_left_xs  = [6, 219, 431];
                var _x_right_xs = [118, 331, 543];
                var _lx = _x_left_xs[_glow_frame];
                var _rx = _x_right_xs[_glow_frame];
                
                // Draw Left vertical bracket & Right slanted bracket
                draw_sprite_part(PlayerSelect, 0, _lx, 624, 27, 169, _dx1 - 6, _dy1 - 6);
                draw_sprite_part(PlayerSelect, 0, _rx, 624, 88, 169, _dx1 - 6 + 112, _dy1 - 6);
                
                // Draw Reticle above X's head
                draw_sprite_part(PlayerSelect, 0, 264, 800, 79, 14, 98, 56);
            }
            
            if (_z_sel) {
                // Zero Neon Brackets (Region 3, Y: 450, H: 169)
                var _z_left_xs  = [2, 215, 427];
                var _z_right_xs = [175, 388, 600];
                var _lx = _z_left_xs[_glow_frame];
                var _rx = _z_right_xs[_glow_frame];
                
                // Draw Left slanted bracket & Right vertical bracket
                draw_sprite_part(PlayerSelect, 0, _lx, 450, 88, 169, _dx2 - 6, _dy2 - 6);
                draw_sprite_part(PlayerSelect, 0, _rx, 450, 27, 169, _dx2 - 6 + 173, _dy2 - 6);
                
                // Draw Reticle above Zero's head
                draw_sprite_part(PlayerSelect, 0, 264, 800, 79, 14, 345, 56);
            }
            
            // 7. Mini In-Game Models & Ready Animations
            // X Mini Model (bottom-left of X card at x=76, y=194)
            var _x_mini_spr = sX_Idle;
            var _x_mini_idx = floor(char_anim_frame) % 5;
            if (_x_sel && char_confirmed) {
                if (sprite_exists(sX_Victory)) {
                    _x_mini_spr = sX_Victory;
                    _x_mini_idx = min(3, floor((55 - char_confirm_timer) * 0.12));
                }
                // Energy Pillar Ready Beam for X
                var _beam_w = 16 + 6 * dsin(anim_timer * 12);
                draw_set_color(make_color_rgb(0, 220, 255));
                draw_set_alpha(0.35 + 0.25 * dsin(anim_timer * 10));
                draw_rectangle(76 - _beam_w, 46, 76 + _beam_w, 194, false);
                draw_set_color(c_white);
                draw_rectangle(76 - 3, 46, 76 + 3, 194, false);
                draw_set_alpha(1.0);
            }
            if (sprite_exists(_x_mini_spr)) {
                draw_sprite_ext(_x_mini_spr, _x_mini_idx, 76, 194, 1.0, 1.0, 0, c_white, _x_alpha);
            }
            
            // Zero Mini Model (bottom-right of Zero card at x=405, y=194)
            var _z_mini_spr = sZero_Idle;
            var _z_mini_idx = floor(char_anim_frame) % 5;
            if (_z_sel && char_confirmed) {
                if (sprite_exists(sZero_Teleport_Out)) {
                    _z_mini_spr = sZero_Teleport_Out;
                    _z_mini_idx = 6; // Thumbs up pose!
                }
                // Energy Pillar Ready Beam for Zero
                var _beam_w = 16 + 6 * dsin(anim_timer * 12);
                draw_set_color(make_color_rgb(255, 60, 60));
                draw_set_alpha(0.35 + 0.25 * dsin(anim_timer * 10));
                draw_rectangle(405 - _beam_w, 46, 405 + _beam_w, 194, false);
                draw_set_color(make_color_rgb(255, 230, 80));
                draw_rectangle(405 - 3, 46, 405 + 3, 194, false);
                draw_set_alpha(1.0);
            }
            if (sprite_exists(_z_mini_spr)) {
                draw_sprite_ext(_z_mini_spr, _z_mini_idx, 405, 194, 1.0, 1.0, 0, c_white, _z_alpha);
            }
            
            // 8. Status & Controls Hint
            draw_set_halign(fa_center);
            if (!char_confirmed) {
                draw_set_color(make_color_rgb(255, 230, 80));
                draw_text(240, 218, "[LEFT / RIGHT] SELECT  |  [Z / ENTER] CONFIRM  |  [X / ESC] BACK");
            } else {
                var _cname = (_x_sel) ? "MEGA MAN X" : "ZERO";
                var _pulse_col = (anim_timer % 6 < 3) ? make_color_rgb(255, 255, 120) : make_color_rgb(80, 255, 160);
                draw_set_color(_pulse_col);
                draw_text_transformed(240, 218, "*** " + _cname + " READY! COMMENCING MISSION *** ", 1.05, 1.05, 0);
            }
        }
        break;

    case MENU_STATE.CUTSCENE:
        // Set dynamic font if available for full Vietnamese character rendering
        if (variable_instance_exists(id, "dialogue_font") && font_exists(dialogue_font)) {
            draw_set_font(dialogue_font);
        }

        var _cur_step = cutscene_script[cutscene_step];
        var _is_diag = _cur_step.is_dialogue;

        // -------------------------------------------------------------
        // PHASE 1: BỐI CẢNH (PROLOGUE / CONTEXT - Steps 0 & 1)
        // -------------------------------------------------------------
        if (!_is_diag) {
            // Draw background (sci-fi deep space atmosphere; user can replace with sCutscene_BG later)
            if (asset_get_index("sCutscene_BG") != -1) {
                draw_sprite_stretched(asset_get_index("sCutscene_BG"), 0, 0, 0, VIEW_WIDTH, VIEW_HEIGHT);
            } else {
                draw_set_color(make_color_rgb(4, 8, 18));
                draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
                
                // Subtle nebula & space glow
                draw_set_color(make_color_rgb(18, 40, 85));
                draw_set_alpha(0.35);
                draw_circle(240, 135, 140, false);
                draw_set_alpha(1.0);
            }

            // Lower dialogue box (Mega Man X4 style)
            var _bx1 = 36, _by1 = 152, _bx2 = 444, _by2 = 252;
            
            // Box deep navy background
            draw_set_color(make_color_rgb(8, 28, 75));
            draw_set_alpha(0.92);
            draw_rectangle(_bx1, _by1, _bx2, _by2, false);
            draw_set_alpha(1.0);
            
            // Double border: 2px white outer, 1px ice blue inner
            draw_set_color(c_white);
            draw_rectangle(_bx1, _by1, _bx2, _by2, true);
            draw_rectangle(_bx1 + 1, _by1 + 1, _bx2 - 1, _by2 - 1, true);
            draw_set_color(make_color_rgb(80, 180, 255));
            draw_rectangle(_bx1 + 3, _by1 + 3, _bx2 - 3, _by2 - 3, true);

            // Text display
            if (cutscene_step == 0) {
                // Step 0: Prologue Title "2126: MegaMan X Code: Andromeda"
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                
                // Shadow
                draw_set_color(c_black);
                draw_text(241, 203, cutscene_text);
                // Glowing text
                draw_set_color(make_color_rgb(255, 220, 60));
                draw_text(240, 202, cutscene_text);
            } else {
                // Step 1: Prologue Lore
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                
                // Shadow
                draw_set_color(c_black);
                draw_text_ext(_bx1 + 17, _by1 + 15, cutscene_text, 18, 376);
                // White text
                draw_set_color(c_white);
                draw_text_ext(_bx1 + 16, _by1 + 14, cutscene_text, 18, 376);
            }
            
            // Blinking prompt arrow when typing finished
            if (!cutscene_is_typing) {
                if (anim_timer % 30 < 18) {
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_set_color(make_color_rgb(255, 230, 80));
                    draw_text(_bx2 - 14, _by2 - 14, "▼");
                }
            }

            // Controls Hint footer
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(make_color_rgb(140, 170, 210));
            draw_text(240, 256, "[Z / ENTER] TIẾP TỤC  |  [S / ESC] BỎ QUA");
        }
        // -------------------------------------------------------------
        // PHASE 2: THOẠI NHÂN VẬT (CHARACTER DIALOGUE - Steps 2..7)
        // -------------------------------------------------------------
        else {
            // Background: Hunter Base Tactical Transmission Feed
            draw_set_color(make_color_rgb(6, 12, 24));
            draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
            
            // Transmission scanlines
            draw_set_color(make_color_rgb(0, 180, 240));
            draw_set_alpha(0.12);
            draw_line(0, cutscene_scanline, VIEW_WIDTH, cutscene_scanline);
            draw_set_alpha(1.0);
            
            // Hunter Base HUD tech telemetry in center gap
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(make_color_rgb(0, 200, 255));
            draw_text(240, 22, "HUNTER BASE HQ");
            draw_set_color(make_color_rgb(255, 60, 60));
            draw_text(240, 38, "[SECTOR: JUNGLE]");
            
            // Audio visualizer equalizer in center
            var _wave_center = 240;
            var _wave_y = 75;
            for (var w = -42; w <= 42; w += 6) {
                var _bar_h = cutscene_is_typing ? (3 + 9 * abs(sin(anim_timer * 0.2 + w * 0.1))) : 2;
                var _bar_col = (cutscene_speaker_key == "alia") ? make_color_rgb(255, 120, 200) : make_color_rgb(80, 200, 255);
                draw_set_color(_bar_col);
                draw_line(_wave_center + w, _wave_y - _bar_h, _wave_center + w, _wave_y + _bar_h);
            }

            if (sprite_exists(Mugshots)) {
                // =====================================================
                // 1. LEFT MUGSHOT BOX: HERO (MEGA MAN X / ZERO)
                // =====================================================
                var _lx = 44, _ly = 20;
                
                // Amber speedlines background tile inside mugshot box
                draw_sprite_part(Mugshots, 0, 243, 8, 94, 112, _lx, _ly);
                
                var _hero_is_speaking = (cutscene_is_typing && cutscene_speaker_key == "hero");
                
                if (selected_char == 0) {
                    // MEGA MAN X (Clipped to stay precisely inside 94x112 box)
                    // Base head: 144, 120, 94, 98 drawn at (_lx, _ly + 9)
                    draw_sprite_part(Mugshots, 0, 144, 120, 94, 98, _lx, _ly + 9);
                    
                    // Talking mouth animation:
                    // When typing, toggle mouth open/closed every 5 frames
                    if (_hero_is_speaking) {
                        var _x_mouth_open = (floor(anim_timer / 5) % 2 == 1);
                        if (_x_mouth_open) {
                            draw_sprite_part(Mugshots, 0, 160, 223, 51, 36, _lx + 16, _ly + 63);
                        }
                    }
                } else {
                    // ZERO (Clipped to stay precisely inside 94x112 box)
                    // Base head: 358, 130, 94, 94 drawn at (_lx, _ly + 18)
                    draw_sprite_part(Mugshots, 0, 358, 130, 94, 94, _lx, _ly + 18);
                    
                    // Talking mouth animation:
                    // When typing, alternate Mouth 1 and Mouth 2 every 6 frames
                    if (_hero_is_speaking) {
                        var _z_mouth_open = (floor(anim_timer / 6) % 2 == 1);
                        if (_z_mouth_open) {
                            // Mouth 2 (open talking)
                            draw_sprite_part(Mugshots, 0, 417, 225, 32, 16, _lx + 41, _ly + 80);
                        } else {
                            // Mouth 1 (half open)
                            draw_sprite_part(Mugshots, 0, 381, 225, 32, 16, _lx + 41, _ly + 80);
                        }
                    } else {
                        // Listening / idle: closed mouth (Mouth 1)
                        draw_sprite_part(Mugshots, 0, 381, 225, 32, 16, _lx + 41, _ly + 80);
                    }
                }
                
                // Left box borders
                draw_set_color(c_black);
                draw_rectangle(_lx - 1, _ly - 1, _lx + 94, _ly + 112, true);
                var _l_frame_col = _hero_is_speaking ? make_color_rgb(255, 220, 80) : make_color_rgb(100, 160, 220);
                draw_set_color(_l_frame_col);
                draw_rectangle(_lx - 2, _ly - 2, _lx + 95, _ly + 113, true);
                
                // Name plate under left box
                var _hero_title = (selected_char == 0) ? "MEGA MAN X" : "ZERO";
                draw_set_color(make_color_rgb(8, 20, 45));
                draw_rectangle(_lx - 2, _ly + 114, _lx + 95, _ly + 125, false);
                draw_set_color(_l_frame_col);
                draw_rectangle(_lx - 2, _ly + 114, _lx + 95, _ly + 125, true);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                draw_text(_lx + 46, _ly + 119, _hero_title);

                // =====================================================
                // 2. RIGHT MUGSHOT BOX: ALIA (THE NAVIGATOR)
                // =====================================================
                var _rx = 342, _ry = 20;
                var _alia_is_speaking = (cutscene_is_typing && cutscene_speaker_key == "alia");
                
                if (_alia_is_speaking) {
                    // Alternate talking mouth frames 1 and 2
                    var _alia_frame = (floor(anim_timer / 6) % 2 == 0) ? 1 : 2;
                    var _alia_src_x = (_alia_frame == 1) ? 350 : 450;
                    draw_sprite_part(Mugshots, 0, _alia_src_x, 4, 94, 112, _rx, _ry);
                } else {
                    // Frame 0 (closed mouth / listening)
                    draw_sprite_part(Mugshots, 0, 10, 4, 94, 112, _rx, _ry);
                }
                
                // Right box borders
                draw_set_color(c_black);
                draw_rectangle(_rx - 1, _ry - 1, _rx + 94, _ry + 112, true);
                var _r_frame_col = _alia_is_speaking ? make_color_rgb(255, 220, 80) : make_color_rgb(220, 120, 200);
                draw_set_color(_r_frame_col);
                draw_rectangle(_rx - 2, _ry - 2, _rx + 95, _ry + 113, true);
                
                // Name plate under right box
                draw_set_color(make_color_rgb(8, 20, 45));
                draw_rectangle(_rx - 2, _ry + 114, _rx + 95, _ry + 125, false);
                draw_set_color(_r_frame_col);
                draw_rectangle(_rx - 2, _ry + 114, _rx + 95, _ry + 125, true);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                draw_text(_rx + 46, _ry + 119, "ALIA");
            }

            // =========================================================
            // 3. LOWER DIALOGUE BOX (MEGA MAN X4 STYLE)
            // =========================================================
            var _dx1 = 40, _dy1 = 148, _dx2 = 440, _dy2 = 252;
            
            // Box deep navy background
            draw_set_color(make_color_rgb(8, 28, 75));
            draw_set_alpha(0.92);
            draw_rectangle(_dx1, _dy1, _dx2, _dy2, false);
            draw_set_alpha(1.0);
            
            // Double border: 2px white outer, 1px ice blue inner
            draw_set_color(c_white);
            draw_rectangle(_dx1, _dy1, _dx2, _dy2, true);
            draw_rectangle(_dx1 + 1, _dy1 + 1, _dx2 - 1, _dy2 - 1, true);
            draw_set_color(make_color_rgb(80, 180, 255));
            draw_rectangle(_dx1 + 3, _dy1 + 3, _dx2 - 3, _dy2 - 3, true);

            // Speaker Name Header
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            
            var _speaker_display = cutscene_speaker_name;
            // Shadow
            draw_set_color(c_black);
            draw_text(_dx1 + 15, _dy1 + 11, _speaker_display);
            // Glowing Yellow Name Header
            draw_set_color(make_color_rgb(255, 230, 80));
            draw_text(_dx1 + 14, _dy1 + 10, _speaker_display);
            
            // Dialogue Text
            // Subtle black shadow
            draw_set_color(c_black);
            draw_text_ext(_dx1 + 15, _dy1 + 31, cutscene_text, 18, 368);
            // White body text
            draw_set_color(c_white);
            draw_text_ext(_dx1 + 14, _dy1 + 30, cutscene_text, 18, 368);
            
            // Blinking prompt arrow when typing finished
            if (!cutscene_is_typing) {
                if (anim_timer % 30 < 18) {
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_set_color(make_color_rgb(255, 230, 80));
                    draw_text(_dx2 - 14, _dy2 - 14, "▼");
                }
            }

            // Controls Hint footer
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(make_color_rgb(140, 170, 210));
            draw_text(240, 256, "[Z / ENTER] TIẾP TỤC  |  [S / ESC] BỎ QUA");
        }

        // Reset font to default for safety
        draw_set_font(-1);
        break;

    case MENU_STATE.TRANSITION_OUT:
        // Transitioning to stage
        draw_set_color(make_color_rgb(0, 220, 255));
        draw_text_transformed(240, 135, "WARP BEAM INITIALIZED...", 1.3, 1.3, 0);
        break;
}

// -------------------------------------------------------------
// 3. FULLSCREEN FLASH & FADE OVERLAYS
// -------------------------------------------------------------
if (flash_alpha > 0) {
    draw_set_color(c_white);
    draw_set_alpha(flash_alpha);
    draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
    draw_set_alpha(1.0);
}

if (fade_alpha > 0) {
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
    draw_set_alpha(1.0);
}
