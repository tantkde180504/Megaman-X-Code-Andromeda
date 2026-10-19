/// @desc Web Spider Authentic Drawing System (Mega Man X4 PS1 Architecture)

/// @func draw_web_spider_part(row, frame, x, y, facing, flash, alpha, xscale, yscale)
function draw_web_spider_part(_row, _frame, _x, _y, _facing = 1, _flash = false, _alpha = 1.0, _xscale = 1.0, _yscale = 1.0) {
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
            if (_f11 == 0)      { _sx = 266; _w = 83; _h = 92; } // Small ring
            else if (_f11 == 1) { _sx = 363; _w = 89; _h = 91; } // Medium ring
            else if (_f11 == 2) { _sx = 461; _w = 93; _h = 93; } // Large ring
            else                { _sx = 566; _w = 83; _h = 88; } // Flashing ring
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
                // Floor crawl (0..7)
                var _floor_spans = [[88, 31], [128, 24], [163, 25], [199, 25], [236, 24], [268, 31], [304, 31], [340, 32]];
                _sx = _floor_spans[_f13][0];
                _w = _floor_spans[_f13][1];
            } else if (_f13 <= 12) {
                // Wall climb (8..12)
                var _wall_spans = [[376, 20], [412, 18], [448, 16], [468, 19], [504, 19]];
                var _widx = _f13 - 8;
                _sx = _wall_spans[_widx][0];
                _w = _wall_spans[_widx][1];
            } else {
                // Air falling (13..17)
                var _air_spans = [[542, 25], [578, 19], [609, 23], [648, 22], [686, 19]];
                var _aidx = clamp(_f13 - 13, 0, 4);
                _sx = _air_spans[_aidx][0];
                _w = _air_spans[_aidx][1];
            }
            _ox = floor(_w / 2); _oy = floor(_h / 2);
            break;
    }
    
    // Draw part with facing, scale, hurt flash & alpha
    var _draw_x = floor(_x - (_ox * _xscale * _facing));
    var _draw_y = floor(_y - (_oy * _yscale));
    
    if (_flash) {
        gpu_set_fog(true, c_white, 0, 0);
        draw_sprite_part_ext(WebSpider, 0, _sx, _sy, _w, _h, _draw_x, _draw_y, _facing * _xscale, _yscale, c_white, _alpha);
        gpu_set_fog(false, c_white, 0, 0);
    } else {
        draw_sprite_part_ext(WebSpider, 0, _sx, _sy, _w, _h, _draw_x, _draw_y, _facing * _xscale, _yscale, c_white, _alpha);
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

/// @func draw_web_spider_multipart(body_f, head_f, big_leg_f, small_leg_f, arm_f, x, y, facing, flash, alpha)
/// @desc Multi-part animation renderer matching Rows 4, 5, 6, 7, 8
function draw_web_spider_multipart(_body_f, _head_f, _big_leg_f, _small_leg_f, _arm_f, _x, _y, _facing = 1, _flash = false, _alpha = 1.0) {
    if (!sprite_exists(WebSpider)) return;
    
    // Row 4: Thân rỗng & 7 trạng thái mở nắp bung nhện con
    static r4_boxes = [
        [276, 264, 40, 60], // Frame 0: Thân gốc chuẩn (hàng 4 frame 1)
        [324, 268, 16, 56], // Frame 1: Nắp lưng hé mở nấc 1
        [344, 268, 16, 48], // Frame 2: Nắp lưng hé mở nấc 2
        [364, 264, 68, 59], // Frame 3: Bụng mở rộng bung nhện con
        [436, 260, 32, 24], // Frame 4: Xả nhện nấc 1
        [472, 250, 32, 34], // Frame 5: Xả nhện nấc 2
        [508, 252, 32, 32]  // Frame 6: Nắp lưng khép lại
    ];
    
    // Row 5: Cử động của đầu (4 frames đầu kết hợp với phần thân)
    static r5_boxes = [
        [89, 340, 16, 25],
        [111, 338, 17, 28],
        [134, 338, 18, 21],
        [164, 339, 16, 29]
    ];
    
    // Row 6: Cử động bò của chân lớn kết hợp với thân (11 frames)
    static r6_boxes = [
        [228, 380, 18, 16], [258, 380, 20, 16], [291, 376, 18, 22],
        [323, 381, 18, 13], [354, 384, 19, 10], [386, 383, 19, 11],
        [418, 380, 19, 18], [450, 383, 19, 11], [482, 384, 19, 10],
        [515, 381, 18, 13], [555, 380, 17, 16]
    ];
    
    // Row 7: Cử động của các chân nhỏ (11 frames)
    static r7_boxes = [
        [10, 410, 14, 18], [31, 408, 13, 19], [52, 412, 16, 28],
        [79, 413, 13, 18], [100, 414, 12, 26], [117, 408, 13, 13],
        [137, 409, 15, 22], [157, 416, 15, 21], [177, 409, 14, 29],
        [197, 416, 13, 15], [217, 415, 14, 18]
    ];
    
    // Row 8: Cử động lúc bò của tay kết hợp với thân (7 frames)
    static r8_boxes = [
        [332, 457, 16, 15], [352, 459, 16, 12], [372, 460, 16, 11],
        [392, 458, 16, 13], [412, 457, 14, 15], [432, 457, 16, 13],
        [455, 458, 19, 11]
    ];
    
    var _b_idx = clamp(floor(_body_f), 0, 6);
    var _h_idx = clamp(floor(_head_f), 0, 3);
    var _l_idx = clamp(floor(_big_leg_f), 0, 10);
    var _sl_idx = clamp(floor(_small_leg_f), 0, 10);
    var _a_idx = clamp(floor(_arm_f), 0, 6);
    
    // Hàm phụ vẽ từng bộ phận theo offset và facing
    var _draw_sub = function(_b, _ox, _oy, _px, _py, _f, _fl, _al) {
        var _sx = _b[0];
        var _sy = _b[1];
        var _w = _b[2];
        var _h = _b[3];
        var _dx = (_f == 1) ? floor(_px + _ox) : floor(_px - _ox - _w);
        var _dy = floor(_py + _oy);
        
        if (_fl) {
            gpu_set_fog(true, c_white, 0, 0);
            draw_sprite_part_ext(WebSpider, 0, _sx, _sy, _w, _h, _dx, _dy, _f, 1, c_white, _al);
            gpu_set_fog(false, c_white, 0, 0);
        } else {
            draw_sprite_part_ext(WebSpider, 0, _sx, _sy, _w, _h, _dx, _dy, _f, 1, c_white, _al);
        }
    };
    
    // 1. Lớp Chân lớn (Hàng 6)
    _draw_sub(r6_boxes[_l_idx], -16, 2, _x, _y, _facing, _flash, _alpha);
    
    // 2. Lớp Chân nhỏ (Hàng 7)
    _draw_sub(r7_boxes[_sl_idx], -14, 10, _x, _y, _facing, _flash, _alpha);
    
    // 3. Lớp Thân (Hàng 4 Frame 1)
    _draw_sub(r4_boxes[0], -20, -25, _x, _y, _facing, _flash, _alpha);
    
    // 3b. Nắp mở bung nhện con (Hàng 4 với 7 frame) nếu đang ở hoạt ảnh xả nhện
    if (_b_idx > 0) {
        _draw_sub(r4_boxes[_b_idx], -20, -25, _x, _y, _facing, _flash, _alpha);
    }
    
    // 4. Lớp Đầu (Hàng 5 với 4 frame)
    _draw_sub(r5_boxes[_h_idx], 10, -15, _x, _y, _facing, _flash, _alpha);
    
    // 5. Lớp Tay lúc bò (Hàng 8 với 7 frame)
    _draw_sub(r8_boxes[_a_idx], 15, -2, _x, _y, _facing, _flash, _alpha);
}
