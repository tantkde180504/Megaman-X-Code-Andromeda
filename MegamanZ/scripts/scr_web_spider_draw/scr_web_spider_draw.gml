/// @desc Web Spider Authentic Drawing System (Mega Man X4 PS1 Architecture)

/// @func draw_web_spider_part(row, frame, x, y, facing, flash, alpha)
function draw_web_spider_part(_row, _frame, _x, _y, _facing = 1, _flash = false, _alpha = 1.0) {
    if (!sprite_exists(WebSpider)) return;
    
    var _sx = 0, _sy = 0, _w = 64, _h = 64, _ox = 32, _oy = 32;
    
    switch (_row) {
        // =====================================================================
        // Row 1: Intro (y = 10..72, h = 63)
        // =====================================================================
        case 1:
            _sy = 10; _h = 63;
            var _f1 = clamp(floor(_frame), 0, 3);
            if (_f1 == 0)      { _sx = 269; _w = 63; }
            else if (_f1 == 1) { _sx = 336; _w = 65; }
            else if (_f1 == 2) { _sx = 408; _w = 59; }
            else               { _sx = 476; _w = 63; }
            _ox = floor(_w / 2); _oy = floor(_h / 2);
            break;
            
        // =====================================================================
        // Row 2: Hurt, Fall, Charge, Climb (y = 85..156, h = 72)
        // =====================================================================
        case 2:
            _sy = 85; _h = 72;
            var _f2 = clamp(floor(_frame), 0, 6);
            if (_f2 == 0)      { _sx = 56;  _w = 80;  _h = 68; _sy = 88; } // Wire cut fall 1
            else if (_f2 == 1) { _sx = 140; _w = 80;  _h = 68; _sy = 88; } // Wire cut fall 2
            else if (_f2 == 2) { _sx = 231; _w = 134; _h = 72; _sy = 85; } // Charge electric shock
            else if (_f2 == 3) { _sx = 372; _w = 90;  _h = 69; _sy = 85; } // Ambush climb 1
            else if (_f2 == 4) { _sx = 473; _w = 92;  _h = 62; _sy = 88; } // Ambush climb 2
            else if (_f2 == 5) { _sx = 575; _w = 84;  _h = 62; _sy = 88; } // Ambush climb 3
            else               { _sx = 665; _w = 87;  _h = 63; _sy = 88; } // Ambush climb 4
            _ox = floor(_w / 2); _oy = floor(_h / 2);
            break;
            
        // =====================================================================
        // Row 3: Attack, Spawn Spiders, Full Body Idle (y = 167..231, h = 65)
        // =====================================================================
        case 3:
            _sy = 167; _h = 65;
            var _f3 = clamp(floor(_frame), 0, 6);
            if (_f3 == 0)      { _sx = 98;  _w = 77; _h = 55; _sy = 168; } // Landing
            else if (_f3 == 1) { _sx = 181; _w = 78; _h = 57; _sy = 174; } // Spawn spiders 1 (abdomen up)
            else if (_f3 == 2) { _sx = 266; _w = 74; _h = 58; _sy = 176; } // Spawn spiders 2
            else if (_f3 == 3) { _sx = 346; _w = 79; _h = 65; _sy = 167; } // Body idle 1
            else if (_f3 == 4) { _sx = 431; _w = 79; _h = 65; _sy = 167; } // Body idle 2
            else if (_f3 == 5) { _sx = 518; _w = 75; _h = 61; _sy = 171; } // Fire web
            else               { _sx = 602; _w = 97; _h = 56; _sy = 175; } // Strike / lunge
            _ox = floor(_w / 2); _oy = floor(_h / 2);
            break;
            
        // =====================================================================
        // Row 8: Leaves Telegraph (y = 457..471, h = 15)
        // =====================================================================
        case 8:
            _sy = 457; _h = 15;
            var _f8 = clamp(floor(_frame), 0, 6);
            _sx = 332 + (_f8 * 20); _w = 16;
            _ox = 8; _oy = 7;
            break;
            
        // =====================================================================
        // Row 9: Web Thread Segments (y = 476..491, h = 16)
        // =====================================================================
        case 9:
            _sy = 476; _h = 16;
            var _f9 = clamp(floor(_frame), 0, 14);
            if (_f9 <= 5)      { _sx = 299; _w = 5;  _h = 16; } // Straight thread
            else if (_f9 <= 9) { _sx = 344; _w = 12; _h = 16; } // Electric thread
            else               { _sx = 423; _w = 23; _h = 16; } // Wire cut burst spark
            _ox = floor(_w / 2); _oy = 0;
            break;
            
        // =====================================================================
        // Row 10: Web Diamond (y = 500..593, h = 94)
        // =====================================================================
        case 10:
            _sy = 500; _h = 94;
            var _f10 = clamp(floor(_frame), 0, 2);
            if (_f10 == 0)      { _sx = 310; _w = 93; _h = 94; } // Blue diamond web
            else if (_f10 == 1) { _sx = 409; _w = 95; _h = 94; } // Electric cyan diamond web
            else                { _sx = 510; _w = 93; _h = 63; } // Flare
            _ox = floor(_w / 2); _oy = floor(_h / 2);
            break;
            
        // =====================================================================
        // Row 11: Web Octagon (y = 601..693, h = 93)
        // =====================================================================
        case 11:
            _sy = 601; _h = 93;
            var _f11 = clamp(floor(_frame), 0, 3);
            if (_f11 == 0)      { _sx = 266; _w = 83; _h = 92; }
            else if (_f11 == 1) { _sx = 363; _w = 89; _h = 91; }
            else if (_f11 == 2) { _sx = 461; _w = 93; _h = 93; }
            else                { _sx = 566; _w = 83; _h = 88; }
            _ox = floor(_w / 2); _oy = floor(_h / 2);
            break;
            
        // =====================================================================
        // Row 12: Lightning Web Projectile (Flying Seed: 0..3, Deployed Web: 4..9)
        // =====================================================================
        case 12:
            var _f12 = clamp(floor(_frame), 0, 9);
            if (_f12 == 0)      { _sx = 191; _sy = 719; _w = 6;  _h = 6; }  // Flying seed (small)
            else if (_f12 == 1) { _sx = 218; _sy = 719; _w = 6;  _h = 6; }  // Flying seed (small pulse)
            else if (_f12 == 2) { _sx = 240; _sy = 717; _w = 10; _h = 10; } // Flying seed (glow spark)
            else if (_f12 == 3) { _sx = 267; _sy = 717; _w = 10; _h = 10; } // Flying seed (glow pulse)
            else if (_f12 == 4) { _sx = 290; _sy = 715; _w = 43; _h = 41; } // Deployed web opening
            else if (_f12 == 5) { _sx = 344; _sy = 714; _w = 47; _h = 43; } // Deployed electric web 1
            else if (_f12 == 6) { _sx = 405; _sy = 715; _w = 46; _h = 41; } // Deployed electric web 2
            else if (_f12 == 7) { _sx = 464; _sy = 714; _w = 47; _h = 43; } // Deployed electric web 3
            else if (_f12 == 8) { _sx = 523; _sy = 716; _w = 42; _h = 39; } // Deployed electric web 4
            else                { _sx = 579; _sy = 715; _w = 49; _h = 41; } // Deployed electric web 5
            _ox = floor(_w / 2); _oy = floor(_h / 2);
            break;
            
        // =====================================================================
        // Row 13: Mini Spider (y = 776..806, h = 31)
        // =====================================================================
        case 13:
            _sy = 776; _h = 31;
            var _f13 = clamp(floor(_frame), 0, 17);
            if (_f13 <= 7) {
                // Floor crawl
                _sx = 88 + (_f13 * 36); _w = 28; _h = 24; _sy = 782;
            } else if (_f13 <= 12) {
                // Wall climb
                _sx = 376 + ((_f13 - 8) * 36); _w = 18; _h = 30; _sy = 776;
            } else {
                // Air falling
                _sx = 542 + ((_f13 - 13) * 36); _w = 22; _h = 28; _sy = 778;
            }
            _ox = floor(_w / 2); _oy = floor(_h / 2);
            break;
    }
    
    // Draw part with facing, hurt flash & alpha
    var _draw_x = (_facing == 1) ? floor(_x - _ox) : floor(_x + _ox);
    var _draw_y = floor(_y - _oy);
    
    if (_flash) {
        gpu_set_fog(true, c_white, 0, 0);
        draw_sprite_part_ext(WebSpider, 0, _sx, _sy, _w, _h, _draw_x, _draw_y, _facing, 1, c_white, _alpha);
        gpu_set_fog(false, c_white, 0, 0);
    } else {
        draw_sprite_part_ext(WebSpider, 0, _sx, _sy, _w, _h, _draw_x, _draw_y, _facing, 1, c_white, _alpha);
    }
}

/// @func draw_web_spider_weakness_hurt(frame_idx, x, y, facing, flash, alpha)
/// @desc 14-frame weakness hurt reaction animation across Row 2 & Row 3 when hit by Zero's fire slash (Ryuenjin)
function draw_web_spider_weakness_hurt(_frame_idx, _x, _y, _facing = 1, _flash = false, _alpha = 1.0) {
    if (!sprite_exists(WebSpider)) return;
    
    var _f = clamp(floor(_frame_idx), 0, 13);
    var _sx = 0, _sy = 0, _w = 64, _h = 64;
    
    // Pixel-mapped coordinates across Row 2 (Frames 0..6) & Row 3 (Frames 7..13):
    switch (_f) {
        // --- Row 2 (Frames 0..6): Falling down, ground impact spark, initial crash ---
        case 0:  _sx = 56;  _sy = 88;  _w = 80;  _h = 64; break; // Frame 0: Upside-down tumble
        case 1:  _sx = 140; _sy = 89;  _w = 80;  _h = 63; break; // Frame 1: Air fall flailing
        case 2:  _sx = 231; _sy = 85;  _w = 134; _h = 72; break; // Frame 2: Ground slam spark & impact
        case 3:  _sx = 372; _sy = 98;  _w = 90;  _h = 56; break; // Frame 3: Stunned / on knees
        case 4:  _sx = 473; _sy = 99;  _w = 92;  _h = 48; break; // Frame 4: Slipping
        case 5:  _sx = 575; _sy = 96;  _w = 84;  _h = 51; break; // Frame 5: Collapsing
        case 6:  _sx = 665; _sy = 108; _w = 87;  _h = 40; break; // Frame 6: Flat on belly
        
        // --- Row 3 (Frames 7..13): Rolling over, push-up struggle, crouching, springing upward ---
        case 7:  _sx = 98;  _sy = 168; _w = 77; _h = 54; break; // Frame 7: Legs in air / rolling
        case 8:  _sx = 181; _sy = 174; _w = 78; _h = 50; break; // Frame 8: Rolling sideways
        case 9:  _sx = 266; _sy = 176; _w = 74; _h = 49; break; // Frame 9: Rolling forward onto belly
        case 10: _sx = 346; _sy = 181; _w = 79; _h = 51; break; // Frame 10: Pushing up on feet
        case 11: _sx = 431; _sy = 181; _w = 79; _h = 51; break; // Frame 11: Crouched on all 8 legs
        case 12: _sx = 518; _sy = 181; _w = 75; _h = 47; break; // Frame 12: Squatting / coiling down
        case 13: _sx = 602; _sy = 167; _w = 97; _h = 56; break; // Frame 13: Springing / launching upward
    }
    
    var _ox = floor(_w / 2);
    // Align with solid floor ground
    var _oy = _h - 20;
    
    var _draw_x = (_facing == 1) ? floor(_x - _ox) : floor(_x + _ox);
    var _draw_y = floor(_y - _oy);
    
    if (_flash) {
        gpu_set_fog(true, c_white, 0, 0);
        draw_sprite_part_ext(WebSpider, 0, _sx, _sy, _w, _h, _draw_x, _draw_y, _facing, 1, c_white, _alpha);
        gpu_set_fog(false, c_white, 0, 0);
    } else {
        draw_sprite_part_ext(WebSpider, 0, _sx, _sy, _w, _h, _draw_x, _draw_y, _facing, 1, c_white, _alpha);
    }
}

/// @func draw_web_spider_multipart(torso_f, leg_f, cannon_ang, x, y, facing, flash)
/// @desc Procedural Multi-part animation renderer (Section 5 Deliverables)
function draw_web_spider_multipart(_torso_f, _leg_f, _cannon_ang, _x, _y, _facing = 1, _flash = false) {
    if (!sprite_exists(WebSpider)) return;
    
    // 1. Draw Legs (Row 6: y = 376..397, h = 22)
    var _leg_idx = clamp(floor(_leg_f), 0, 10);
    var _leg_sx = 228 + (_leg_idx * 31);
    draw_sprite_part_ext(WebSpider, 0, _leg_sx, 376, 28, 22, _x - (_facing * 20), _y + 6, _facing, 1, c_white, 1.0);
    
    // 2. Draw Torso (Row 4: y = 250..323, h = 74)
    var _torso_sx = 276;
    draw_sprite_part_ext(WebSpider, 0, _torso_sx, 250, 52, 74, _x - (_facing * 26), _y - 37, _facing, 1, c_white, 1.0);
    
    // 3. Draw Shoulder Cannons (Row 5: y = 336..367, h = 32)
    var _cannon_idx = clamp(floor(abs(_cannon_ang) / 18), 0, 19);
    var _can_sx = 89 + (_cannon_idx * 31);
    draw_sprite_part_ext(WebSpider, 0, _can_sx, 336, 26, 32, _x - (_facing * 12), _y - 20, _facing, 1, c_white, 1.0);
    
    // 4. Draw Arms (Row 7: y = 408..439, h = 32)
    var _arm_sx = 10;
    draw_sprite_part_ext(WebSpider, 0, _arm_sx, 408, 24, 32, _x + (_facing * 10), _y + 2, _facing, 1, c_white, 1.0);
}
