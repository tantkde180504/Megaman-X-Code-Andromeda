/// @desc Cập nhật dòng thời gian hiệu ứng hạ gục (Step Event)

// Khởi tạo thông số tại Frame 0
if (timer == 0) {
    origin_x = x;
    origin_y = (y > room_height) ? (room_height - 24) : (y - 18);
    
    // Gán bảng màu theo nhân vật
    if (character_type == "ZERO" || character_type == "Zero" || character_type == 1) {
        col_glow_outer = make_color_rgb(255, 80, 0);    // Đỏ cam
        col_glow_mid   = make_color_rgb(255, 195, 0);   // Vàng cam
        col_core       = make_color_rgb(255, 250, 180); // Vàng nhạt
        col_fog        = make_color_rgb(255, 180, 50);  // Ánh chớp vàng
    } else {
        col_glow_outer = make_color_rgb(0, 120, 255);   // Xanh dương đậm
        col_glow_mid   = make_color_rgb(0, 235, 255);   // Cyan rực rỡ
        col_core       = c_white;                       // Trắng sáng
        col_fog        = c_aqua;                        // Ánh chớp xanh trắng
    }
    
    // Khóa nhân vật
    if (instance_exists(player_id)) {
        player_id.hsp = 0;
        player_id.vsp = 0;
        player_id.image_speed = 0;
        player_id.state = PLAYER_STATE.DEATH;
    }
    
    // Dừng nhạc nền BGM
    if (variable_global_exists("current_bgm") && audio_is_playing(global.current_bgm)) {
        audio_stop_sound(global.current_bgm);
    }
    if (script_exists(asset_get_index("music_stop_boss_nightmare_zero"))) {
        music_stop_boss_nightmare_zero(100);
    }
    camera_shake(3, 8);
}

// -------------------------------------------------------------
// GIAI ĐOẠN 1: STATE_HIT_FREEZE (Frame 0 -> 24)
// -------------------------------------------------------------
if (timer <= 24) {
    state = 0;
    
    // Tạo tia lửa điện ngẫu nhiên quanh thân
    if (timer % 3 == 0) {
        array_push(sparks, {
            x: origin_x + irandom_range(-14, 14),
            y: origin_y + irandom_range(-14, 14),
            len: irandom_range(6, 12),
            angle: random(360),
            life: 4,
            col: choose(col_core, col_glow_mid)
        });
    }
    if (timer % 5 == 0 && object_exists(oFX_HitSpark)) {
        instance_create_layer(origin_x + irandom_range(-10, 10), origin_y + irandom_range(-12, 12), "Instances", oFX_HitSpark);
    }
    
    // Cập nhật tia sét
    for (var i = array_length(sparks) - 1; i >= 0; i--) {
        sparks[i].life--;
        if (sparks[i].life <= 0) array_delete(sparks, i, 1);
    }
}

// -------------------------------------------------------------
// GIAI ĐOẠN 2: STATE_CORE_IMPLOSION (Frame 25 -> 32)
// -------------------------------------------------------------
else if (timer <= 32) {
    state = 1;
    
    // Frame 25: Ẩn nhân vật & phát nổ lõi năng lượng
    if (timer == 25) {
        if (instance_exists(player_id)) {
            player_id.visible = false;
        }
        camera_shake(5, 10);
    }
    
    // Frame 25..29: Phình nhanh từ scale 0.4 lên 1.6
    if (timer <= 29) {
        core_scale = 0.4 + ((timer - 25) / 4.0) * 1.2;
    } else {
        // Frame 30..32: Thu gọn / nén lại cực nhanh trước khi bung vòng
        core_scale = 1.6 - ((timer - 29) / 3.0) * 1.35;
    }
}

// -------------------------------------------------------------
// GIAI ĐOẠN 3: STATE_RING_BURST (Frame 33 -> 100)
// -------------------------------------------------------------
else if (timer <= 100) {
    state = 2;
    
    // Sinh các đợt vòng tròn năng lượng
    if (death_style == "MMX4_PS1") {
        // Chuẩn Mega Man X4: 3 đợt vòng tròn cách nhau 6 frames
        if (timer == 33) {
            // Đợt 1
            for (var i = 0; i < 8; i++) {
                array_push(rings, new DeathRing(0, i, origin_x, origin_y, "MMX4_PS1", character_type));
            }
        } else if (timer == 39) {
            // Đợt 2
            for (var i = 0; i < 8; i++) {
                array_push(rings, new DeathRing(1, i, origin_x, origin_y, "MMX4_PS1", character_type));
            }
        } else if (timer == 45) {
            // Đợt 3
            for (var i = 0; i < 8; i++) {
                array_push(rings, new DeathRing(2, i, origin_x, origin_y, "MMX4_PS1", character_type));
            }
        }
    } else {
        // Tùy chọn MMX1_SNES: 2 đợt × 8 quả cầu bay thẳng không trọng lực
        if (timer == 33) {
            for (var i = 0; i < 8; i++) {
                array_push(rings, new DeathRing(0, i, origin_x, origin_y, "MMX1_SNES", character_type));
            }
            // 4 hạt nhỏ chéo
            var _diag = [22.5, 112.5, 202.5, 292.5];
            for (var j = 0; j < 4; j++) {
                array_push(rings, new DeathRing(1, j, origin_x, origin_y, "MMX1_SNES", character_type, _diag[j]));
            }
        } else if (timer == 45) {
            for (var i = 0; i < 8; i++) {
                array_push(rings, new DeathRing(1, i, origin_x, origin_y, "MMX1_SNES", character_type));
            }
        }
    }
    
    // Cập nhật chuyển động của từng vòng tròn năng lượng
    for (var i = array_length(rings) - 1; i >= 0; i--) {
        rings[i].update();
        if (!rings[i].is_active) {
            array_delete(rings, i, 1);
        }
    }
    
    // SNES style: Chớp trắng ở Frame 85
    if (death_style == "MMX1_SNES" && timer == 85) {
        white_flash_alpha = 1.0;
    }
    if (white_flash_alpha > 0.0) {
        white_flash_alpha = max(0.0, white_flash_alpha - 0.1);
    }
}

// -------------------------------------------------------------
// GIAI ĐOẠN 4: STATE_SCREEN_TRANSITION (Frame 101 -> 140)
// -------------------------------------------------------------
else if (timer <= 140) {
    state = 3;
    
    // Tiếp tục cập nhật các vòng tròn còn lại
    for (var i = array_length(rings) - 1; i >= 0; i--) {
        rings[i].update();
        if (!rings[i].is_active) {
            array_delete(rings, i, 1);
        }
    }
    
    // Màn đen phủ dần (Fade-out to Black)
    fade_alpha = clamp((timer - 100) / 35.0, 0.0, 1.0);
    global.screen_fade_alpha = fade_alpha;
    
    // Frame 140: Màn hình đen hoàn toàn -> Khởi tạo lại checkpoint & respawn
    if (timer == 140 && !respawn_done) {
        respawn_done = true;
        
        // Trừ mạng người chơi nếu có hệ thống mạng
        if (variable_global_exists("player_lives")) {
            global.player_lives -= 1;
            if (global.player_lives <= 0 && room_exists(asset_get_index("rm_game_over"))) {
                room_goto(asset_get_index("rm_game_over"));
                instance_destroy();
                return;
            }
        }
        
        // Di chuyển người chơi về điểm Checkpoint
        if (instance_exists(player_id)) {
            if (variable_global_exists("checkpoint_x") && variable_global_exists("checkpoint_y")) {
                player_id.x = global.checkpoint_x;
                player_id.y = global.checkpoint_y;
            }
            player_id.hp_current = player_id.hp_max;
            player_id.facing = 1;
            player_id.grounded = true;
            player_id.is_dash_jumping = false;
            player_id.hsp = 0;
            player_id.vsp = 0;
            player_id.visible = false; // Giữ ẩn trong lúc màn hình đang fade-in từ màu đen
        }
        
        // Căn tâm Camera vào vị trí hồi sinh
        if (instance_exists(oCamera) && instance_exists(player_id)) {
            oCamera.x = player_id.x;
            oCamera.y = player_id.y - 16;
        }
        
        // Khôi phục phòng Boss, cửa và bẫy
        if (script_exists(asset_get_index("scr_reset_boss_room"))) {
            scr_reset_boss_room();
        }
    }
}

// -------------------------------------------------------------
// GIAI ĐOẠN 5: RESPAWN FADE-IN (Frame 141 -> 170)
// -------------------------------------------------------------
else if (timer <= 170) {
    state = 4;
    
    // Màn đen mờ dần, sáng trở lại (Fade-in from Black)
    fade_alpha = clamp((170 - timer) / 30.0, 0.0, 1.0);
    global.screen_fade_alpha = fade_alpha;
    
    if (timer == 170) {
        global.screen_fade_alpha = 0.0;
        
        // Kích hoạt lại hiệu ứng Teleport Beam & READY Intro khi hồi sinh tại checkpoint
        if (instance_exists(player_id)) {
            player_id.state = PLAYER_STATE.INTRO;
            player_id.intro_phase = 0;
            player_id.teleport_beam_y = player_id.y - 240;
            player_id.teleport_sphere_frame = 1.0;
            player_id.intro_anim_frame = 0.0;
            player_id.intro_hold_timer = 25;
            player_id.intro_sound_played = false;
            player_id.iframes = 60;
            player_id.visible = true;
        }
        
        if (!instance_exists(obj_ready_intro)) {
            var _lay = layer_get_id("Instances");
            if (_lay != -1) instance_create_layer(0, 0, _lay, obj_ready_intro);
            else instance_create_depth(0, 0, -10000, obj_ready_intro);
        }
        
        instance_destroy();
        return;
    }
}

timer++;
