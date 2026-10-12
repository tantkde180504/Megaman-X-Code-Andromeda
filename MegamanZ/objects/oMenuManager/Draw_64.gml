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
            // Screen 1: Capcom Tribute
            draw_set_color(make_color_rgb(255, 215, 0)); // Capcom Gold
            draw_text_transformed(240, 110, "CAPCOM", 2.2, 2.2, 0);
            
            draw_set_color(make_color_rgb(80, 200, 255)); // Cyan
            draw_text(240, 142, "PRESENTS");
            
            draw_set_color(make_color_rgb(180, 190, 210));
            draw_text(240, 175, "A TRIBUTE TO THE LEGENDARY MEGA MAN X SERIES");
            draw_set_color(make_color_rgb(120, 130, 150));
            draw_text(240, 240, "[ PRESS ANY KEY TO SKIP ]");
        } else {
            // Screen 2: Andromeda Fanmade Splash
            draw_set_color(make_color_rgb(40, 220, 255));
            draw_text(240, 100, "MEGAMAN X FANMADE PRODUCTION");
            
            draw_set_color(make_color_rgb(255, 200, 40));
            draw_text_transformed(240, 135, "CODE: ANDROMEDA", 1.8, 1.8, 0);
            
            draw_set_color(make_color_rgb(170, 180, 200));
            draw_text(240, 170, "DEEPMIND AGENTIC PAIR-PROGRAMMING ENGINE");
            draw_set_color(make_color_rgb(120, 130, 150));
            draw_text(240, 240, "[ PRESS ANY KEY TO SKIP ]");
        }
        break;

    case MENU_STATE.TITLE:
        // Logo: MEGA MAN X
        // 3D Shadow layer
        draw_set_color(make_color_rgb(10, 20, 50));
        draw_text_transformed(242, 67, "MEGA MAN X", 2.6, 2.6, 0);
        // Bevel glow layer
        draw_set_color(make_color_rgb(0, 120, 220));
        draw_text_transformed(240, 66, "MEGA MAN X", 2.5, 2.5, 0);
        // Core layer
        draw_set_color(make_color_rgb(180, 240, 255));
        draw_text_transformed(240, 64, "MEGA MAN X", 2.4, 2.4, 0);
        
        // Subtitle: CODE ANDROMEDA
        var _pulse = 0.85 + 0.15 * dsin(anim_timer * 4);
        draw_set_color(make_color_rgb(255, 180, 30));
        draw_set_alpha(_pulse);
        draw_text_transformed(240, 106, "— CODE ANDROMEDA —", 1.5, 1.5, 0);
        draw_set_alpha(1.0);
        
        // Light shimmer bar
        var _shim_x = (anim_timer * 4) % (VIEW_WIDTH + 100) - 50;
        draw_set_color(c_white);
        draw_set_alpha(0.25);
        draw_rectangle(_shim_x - 12, 50, _shim_x + 12, 120, false);
        draw_set_alpha(1.0);
        
        // Press Start prompt (pulsing)
        var _start_alpha = max(0, dsin(anim_timer * 5));
        draw_set_color(make_color_rgb(255, 255, 100));
        draw_set_alpha(_start_alpha);
        draw_text_transformed(240, 182, "— PRESS START —", 1.3, 1.3, 0);
        draw_set_color(c_white);
        draw_text(240, 204, "[ PRESS ENTER / SPACE / Z ]");
        draw_set_alpha(1.0);
        
        // Footer
        draw_set_color(make_color_rgb(100, 115, 145));
        draw_text(240, 254, "© 2026 FANMADE TRIBUTE PROJECT // FOR FANS BY FANS");
        break;

    case MENU_STATE.MAIN_MENU:
        // Mini Header
        draw_set_color(make_color_rgb(0, 180, 255));
        draw_text_transformed(240, 35, "MEGA MAN X: CODE ANDROMEDA", 1.3, 1.3, 0);
        
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
        // Character Select Screen (Mega Man X4 Style)
        draw_set_color(make_color_rgb(0, 210, 255));
        draw_text_transformed(240, 20, "- SELECT YOUR HUNTER -", 1.4, 1.4, 0);
        draw_set_color(make_color_rgb(180, 200, 225));
        draw_text(240, 36, "CHOOSE YOUR WARRIOR FOR THE ANDROMEDA CRISIS");
        
        // ---------------------------------------------------------
        // CARD 1: MEGA MAN X (Left Card: 20 .. 232)
        // ---------------------------------------------------------
        var _x_sel = (selected_char == 0);
        var _x_alpha = _x_sel ? 0.95 : 0.45;
        
        // Card Background
        draw_set_color(_x_sel ? make_color_rgb(15, 30, 60) : make_color_rgb(10, 15, 25));
        draw_set_alpha(_x_alpha);
        draw_rectangle(20, 48, 232, 248, false);
        draw_set_alpha(1.0);
        
        // Card Border
        draw_set_color(_x_sel ? make_color_rgb(0, 200, 255) : make_color_rgb(50, 80, 120));
        draw_rectangle(20, 48, 232, 248, true);
        if (_x_sel) {
            // Glowing border
            draw_set_alpha(0.4 + 0.3 * dsin(anim_timer * 6));
            draw_rectangle(19, 47, 233, 249, true);
            draw_set_alpha(1.0);
        }
        
        // X Card Header
        draw_set_color(_x_sel ? make_color_rgb(0, 220, 255) : make_color_rgb(100, 150, 190));
        draw_text_transformed(126, 62, "MEGA MAN X", 1.3, 1.3, 0);
        draw_set_color(make_color_rgb(160, 200, 240));
        draw_text(126, 78, "CLASS B -> SPECIAL A HUNTER");
        
        // Draw Animated X Sprite
        var _x_spr = sX_Idle;
        var _x_frame = (floor(char_anim_frame) % 5);
        if (_x_sel && char_confirmed && sprite_exists(sX_Victory)) {
            _x_spr = sX_Victory;
            _x_frame = 0;
        }
        if (sprite_exists(_x_spr)) {
            draw_sprite_ext(_x_spr, _x_frame, 126, 152, 1.4, 1.4, 0, c_white, _x_alpha);
        }
        
        // X Perks & Stats
        draw_set_halign(fa_left);
        var _tx = 32;
        draw_set_color(_x_sel ? c_white : make_color_rgb(140, 150, 170));
        draw_text(_tx, 172, "- Weapon: X-Buster (Long Range)");
        draw_text(_tx, 188, "- Skill: 3-Stage Charge Shot");
        draw_text(_tx, 204, "- Ability: Armor Parts Upgrade");
        draw_set_color(_x_sel ? make_color_rgb(80, 240, 150) : make_color_rgb(100, 140, 110));
        draw_text(_tx, 224, "* Style: Balanced, Wide-Area Control");
        draw_set_halign(fa_center);
        
        // ---------------------------------------------------------
        // CARD 2: ZERO (Right Card: 248 .. 460)
        // ---------------------------------------------------------
        var _z_sel = (selected_char == 1);
        var _z_alpha = _z_sel ? 0.95 : 0.45;
        
        // Card Background
        draw_set_color(_z_sel ? make_color_rgb(50, 15, 15) : make_color_rgb(20, 10, 10));
        draw_set_alpha(_z_alpha);
        draw_rectangle(248, 48, 460, 248, false);
        draw_set_alpha(1.0);
        
        // Card Border
        draw_set_color(_z_sel ? make_color_rgb(255, 60, 60) : make_color_rgb(120, 50, 50));
        draw_rectangle(248, 48, 460, 248, true);
        if (_z_sel) {
            // Glowing border
            draw_set_alpha(0.4 + 0.3 * dsin(anim_timer * 6));
            draw_set_color(make_color_rgb(255, 200, 40));
            draw_rectangle(247, 47, 461, 249, true);
            draw_set_alpha(1.0);
        }
        
        // Zero Card Header
        draw_set_color(_z_sel ? make_color_rgb(255, 90, 80) : make_color_rgb(180, 100, 100));
        draw_text_transformed(354, 62, "ZERO", 1.3, 1.3, 0);
        draw_set_color(make_color_rgb(255, 190, 80));
        draw_text(354, 78, "SPECIAL 0TH UNIT COMMANDER");
        
        // Draw Animated Zero Sprite
        var _z_spr = sZero_Idle;
        var _z_frame = (floor(char_anim_frame) % 5);
        if (_z_sel && char_confirmed && sprite_exists(sZero_Teleport_Out)) {
            _z_spr = sZero_Teleport_Out;
            _z_frame = 6; // Thumbs up victory pose!
        }
        if (sprite_exists(_z_spr)) {
            draw_sprite_ext(_z_spr, _z_frame, 354, 152, 1.4, 1.4, 0, c_white, _z_alpha);
        }
        
        // Zero Perks & Stats
        draw_set_halign(fa_left);
        var _zx = 260;
        draw_set_color(_z_sel ? c_white : make_color_rgb(170, 140, 140));
        draw_text(_zx, 172, "- Weapon: Z-Saber (Close Combat)");
        draw_text(_zx, 188, "- Skill: 3-Hit Combo & Dash Slash");
        draw_text(_zx, 204, "- Ability: Learn Boss Techniques");
        draw_set_color(_z_sel ? make_color_rgb(255, 180, 50) : make_color_rgb(140, 110, 80));
        draw_text(_zx, 224, "* Style: High Aggression, High Damage");
        draw_set_halign(fa_center);
        
        // Bottom Hint
        draw_set_color(make_color_rgb(255, 230, 80));
        if (!char_confirmed) {
            draw_text(240, 260, "[LEFT/RIGHT] SELECT  |  [Z/ENTER] CONFIRM  |  [X/ESC] BACK");
        } else {
            draw_text(240, 260, "* READY: " + ((selected_char == 0) ? "MEGA MAN X" : "ZERO") + "! COMMENCING MISSION... *");
        }
        break;

    case MENU_STATE.CUTSCENE:
        // Story Cutscene (Mega Man X5 Typewriter Style)
        // Outer Terminal Frame
        draw_set_color(make_color_rgb(6, 10, 18));
        draw_set_alpha(0.95);
        draw_rectangle(15, 10, 465, 260, false);
        draw_set_alpha(1.0);
        
        draw_set_color(make_color_rgb(30, 120, 200));
        draw_rectangle(15, 10, 465, 260, true);
        
        // Terminal Header
        draw_set_color(make_color_rgb(20, 60, 110));
        draw_rectangle(16, 11, 464, 30, false);
        draw_set_color(make_color_rgb(0, 230, 255));
        draw_text(240, 20, "HUNTER BASE // EMERGENCY TRANSMISSION // CODE: ANDROMEDA");
        
        // Scanlines effect
        draw_set_color(make_color_rgb(0, 255, 200));
        draw_set_alpha(0.2);
        draw_line(15, cutscene_scanline, 465, cutscene_scanline);
        draw_set_alpha(1.0);
        
        // Top Left: Hologram Radar / Transmission Box (25..120, 38..130)
        draw_set_color(make_color_rgb(10, 24, 45));
        draw_rectangle(25, 38, 120, 130, false);
        draw_set_color(make_color_rgb(0, 180, 220));
        draw_rectangle(25, 38, 120, 130, true);
        
        // Hologram Scanner Circles
        draw_set_color(make_color_rgb(0, 200, 255));
        draw_set_alpha(0.5);
        draw_circle(72, 84, 28, true);
        draw_circle(72, 84, 16, true);
        draw_line(72, 56, 72, 112);
        draw_line(44, 84, 100, 84);
        var _sweep_ang = anim_timer * 4;
        draw_line(72, 84, 72 + lengthdir_x(28, _sweep_ang), 84 + lengthdir_y(28, _sweep_ang));
        draw_set_alpha(1.0);
        draw_text(72, 120, "LIVE FEED: HQ");
        
        // Top Right: Mission Intel & Threat Level (130..455, 38..130)
        draw_set_color(make_color_rgb(10, 24, 45));
        draw_rectangle(130, 38, 455, 130, false);
        draw_set_color(make_color_rgb(0, 180, 220));
        draw_rectangle(130, 38, 455, 130, true);
        
        draw_set_halign(fa_left);
        draw_set_color(make_color_rgb(255, 60, 60));
        draw_text(142, 52, "- STATUS: EMERGENCY ALERT // CODE RED");
        draw_set_color(make_color_rgb(255, 200, 40));
        draw_text(142, 70, "- SECTOR: ORBITAL HIGHWAY (RUINED SKYWAY)");
        draw_set_color(make_color_rgb(100, 220, 255));
        draw_text(142, 88, "- SCOUT UNIT: UNIT 17 (SIGNAL LOST)");
        draw_set_color(make_color_rgb(180, 240, 255));
        var _c_str = (selected_char == 0) ? "MEGA MAN X (DEPLOYED)" : "ZERO (DEPLOYED)";
        draw_text(142, 106, "- HUNTER: " + _c_str);
        draw_set_halign(fa_center);
        
        // Bottom: Dialogue Box (25..455, 138..248)
        draw_set_color(make_color_rgb(10, 18, 35));
        draw_rectangle(25, 138, 455, 248, false);
        draw_set_color(make_color_rgb(0, 160, 230));
        draw_rectangle(25, 138, 455, 248, true);
        
        // Speaker Badge
        draw_set_color(make_color_rgb(0, 80, 160));
        draw_rectangle(30, 142, 230, 158, false);
        draw_set_color(make_color_rgb(255, 220, 40));
        draw_set_halign(fa_left);
        draw_text(36, 150, "> " + cutscene_speaker);
        
        // Page counter
        draw_set_halign(fa_right);
        draw_set_color(make_color_rgb(140, 170, 210));
        draw_text(448, 150, "PAGE " + string(cutscene_page + 1) + "/3");
        
        // Dialogue Text
        draw_set_color(c_white);
        draw_text_ext(36, 172, cutscene_text, 14, 410);
        draw_set_halign(fa_center);
        
        // Cutscene Controls Hint
        draw_set_color(make_color_rgb(255, 200, 40));
        draw_text(240, 254, "[Z / ENTER] NEXT  |  [S / ESC] SKIP CUTSCENE");
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
