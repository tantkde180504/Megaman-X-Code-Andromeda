/// @desc Zero Nightmare (Nightmare Zero) - Exact User Sequence Step Logic
// -------------------------------------------------------------------------
// 1. KIỂM TRA TỬ TRẬN & GIỚI HẠN TỌA ĐỘ
// -------------------------------------------------------------------------
if (hp <= 0 && state != NZ_STATE.DEFEAT) {
    nz_change_state(NZ_STATE.DEFEAT);
}

// Giữ boss luôn ở trong giới hạn sàn đấu
x = clamp(x, 32, room_width - 32);

// Kiểm tra mục tiêu người chơi
if (instance_exists(oPlayer)) {
    target = instance_nearest(x, y, oPlayer);
} else {
    target = noone;
}

// CỬ ĐỘNG 3 (KHI CÒN 20% MÁU): Thực hiện đòn Shin Messenkou, sau đó quay lại Cử động 2
if (hp <= max_hp * 0.2 && !messenkou_done && state != NZ_STATE.INTRO && state != NZ_STATE.DEFEAT) {
    messenkou_done = true;
    nz_change_state(NZ_STATE.ACT3_MESSENKOU);
}

// Phản xạ nhận sát thương nặng từ Charged Shot (Stagger flinch & i-frames)
if (hp < prev_hp) {
    var _dmg_taken = prev_hp - hp;
    prev_hp = hp;
    
    if (state != NZ_STATE.INTRO && state != NZ_STATE.DEFEAT && 
        state != NZ_STATE.ACT2_TELEPORT && state != NZ_STATE.ACT3_MESSENKOU && state != NZ_STATE.HURT) {
        if (_dmg_taken >= 2) {
            nz_change_state(NZ_STATE.HURT);
        } else {
            flash_timer = 10;
        }
    }
} else if (hp > prev_hp) {
    prev_hp = hp;
}

// Vật lý cơ sở (trọng lực, va chạm nền)
if (state != NZ_STATE.ACT2_TELEPORT && state != NZ_STATE.DEFEAT) {
    event_inherited();
} else {
    if (flash_timer > 0) flash_timer--;
    if (invulnerability_timer > 0) invulnerability_timer--;
}

state_timer++;

// -------------------------------------------------------------------------
// 2. DIỄN HOẠT ANIMATION THỦ CÔNG (image_speed = 0)
// -------------------------------------------------------------------------
anim_timer++;
if (anim_timer >= anim_delay) {
    anim_timer = 0;
    var _max_f = sprite_get_number(anim_sprite);
    if (anim_frame < _max_f - 1) {
        anim_frame++;
    } else {
        anim_done = true;
    }
}

// -------------------------------------------------------------------------
// 3. HIỆU ỨNG TÀN ẢNH (Afterimages lúc Lướt & Teleport)
// -------------------------------------------------------------------------
if (state == NZ_STATE.ACT1_DASH || state == NZ_STATE.ACT2_TELEPORT) {
    if (state_timer % 3 == 0) {
        if (array_length(afterimages) >= 4) {
            array_delete(afterimages, 0, 1);
        }
        array_push(afterimages, {
            x: x,
            y: y,
            sprite: anim_sprite,
            frame: anim_frame,
            facing: -facing,
            alpha: 0.6
        });
    }
}

for (var _i = 0; _i < array_length(afterimages); _i++) {
    afterimages[_i].alpha = max(0, afterimages[_i].alpha - 0.04);
}

// -------------------------------------------------------------------------
// 4. BỘ ĐIỀU KHIỂN CHU KỲ TUẦN TỰ THEO ĐÚNG YÊU CẦU NGƯỜI DÙNG
// -------------------------------------------------------------------------
switch (state) {

    // =====================================================================
    // 0. INTRO: Cảnh báo WARNING -> Ooze phồng lên hóa Zero (hàng 1, 2: 15 frames)
    // =====================================================================
    case NZ_STATE.INTRO:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        if (warning_timer > 0) {
            warning_timer--;
            image_alpha = 0;
            anim_frame = 0;
            anim_timer = 0;
        } else {
            image_alpha = 1;
            if (anim_done && intro_done) {
                act1_loop_count = 0;
                act1_shoot_wave_step = 0;
                nz_change_state(NZ_STATE.ACT1_DASH);
            }
        }
        break;

    // =====================================================================
    // 1. IDLE: Nghỉ ngắn giữa các đợt
    // =====================================================================
    case NZ_STATE.IDLE:
        hsp = 0;
        if (instance_exists(target)) facing = (target.x >= x) ? 1 : -1;
        if (state_timer >= 12) {
            nz_change_state(NZ_STATE.ACT1_DASH);
        }
        break;

    // =====================================================================
    // CỬ ĐỘNG 1: LƯỚT TỚI GẦN NHÂN VẬT -> CHÉM THƯỜNG -> BẮN -> CHÉM SÓNG KIẾM
    // (Lặp lại 1 lần nữa cử động bắn rồi chém, sau đó lặp lại Cử động 1 thêm 1 lần)
    // =====================================================================
    case NZ_STATE.ACT1_DASH:
        if (instance_exists(target)) facing = (target.x >= x) ? 1 : -1;
        hsp = facing * 6.5;
        
        // Lặp tư thế lướt (frames 1..3) trong lúc di chuyển tới gần mục tiêu
        if (anim_frame >= 4) {
            anim_frame = 1;
        }
        
        // Dừng lướt khi áp sát mục tiêu (<= 56px), gặp tường oSolid hoặc sau tối đa 90 step
        var _dist = (instance_exists(target)) ? abs(target.x - x) : 999;
        if (_dist <= 56 || place_meeting(x + hsp, y, oSolid) || state_timer >= 90) {
            hsp = 0;
            nz_change_state(NZ_STATE.ACT1_SLASH);
        }
        break;

    case NZ_STATE.ACT1_SLASH:
        hsp = 0;
        if (state_timer == 1 && instance_exists(target)) {
            facing = (target.x >= x) ? 1 : -1;
        }
        
        // Frame 3 chém vòng cung lớn: kích hoạt hitbox cận chiến
        if (anim_frame == 3 && !action_triggered) {
            action_triggered = true;
            camera_shake(4, 8);
            var _hb = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_slash_hitbox);
            _hb.damage = 4;
            _hb.source_boss = self;
        }
        
        // Chém xong -> sang đòn bắn
        if (anim_done) {
            nz_change_state(NZ_STATE.ACT1_SHOOT);
        }
        break;

    case NZ_STATE.ACT1_SHOOT:
        hsp = 0;
        if (state_timer == 1 && instance_exists(target)) {
            facing = (target.x >= x) ? 1 : -1;
        }
        shoot_burst_timer++;
        
        if (hp > max_hp * 0.5) {
            // Khi HP > 50%: Bắn 2 phát đạn theo đường thẳng
            if (shoot_burst_timer == 2) {
                camera_shake(2, 6);
                var _b1 = instance_create_layer(x + facing * 24, y - 26, "Instances", obj_nz_drill);
                _b1.hsp = facing * 6.5;
                _b1.vsp = 0;
                _b1.damage = 3;
                shoot_burst_count = 1;
            } else if (shoot_burst_timer == 14) {
                camera_shake(2, 6);
                var _b2 = instance_create_layer(x + facing * 24, y - 26, "Instances", obj_nz_drill);
                _b2.hsp = facing * 6.5;
                _b2.vsp = 0;
                _b2.damage = 3;
                shoot_burst_count = 2;
            }
            
            if (shoot_burst_timer >= 24 && anim_done) {
                nz_change_state(NZ_STATE.ACT1_WAVE);
            }
        } else {
            // Khi HP <= 50%: Bắn 10 phát liên tục theo đường hình quạt hướng về phía nhân vật
            var _target_dir = 0;
            if (instance_exists(target)) {
                _target_dir = point_direction(x, y - 26, target.x, target.y - 16);
            } else {
                _target_dir = (facing == 1) ? 0 : 180;
            }
            
            if (shoot_burst_timer % 3 == 0 && shoot_burst_count < 10) {
                camera_shake(1, 3);
                // Trải góc quạt từ -22.5 đến +22.5 độ
                var _angle_offset = -22.5 + (shoot_burst_count * 5.0);
                var _shot_angle = _target_dir + _angle_offset;
                
                var _b = instance_create_layer(x + facing * 24, y - 26, "Instances", obj_nz_drill);
                _b.hsp = lengthdir_x(6.5, _shot_angle);
                _b.vsp = lengthdir_y(6.5, _shot_angle);
                _b.damage = 3;
                shoot_burst_count++;
            }
            
            if (shoot_burst_count >= 10 && shoot_burst_timer >= 36) {
                nz_change_state(NZ_STATE.ACT1_WAVE);
            }
        }
        break;

    case NZ_STATE.ACT1_WAVE:
        hsp = 0;
        if (state_timer == 1 && instance_exists(target)) {
            facing = (target.x >= x) ? 1 : -1;
        }
        
        // Frame 3: chém sóng kiếm nhỏ bay theo hướng nhân vật
        if (anim_frame == 3 && !action_triggered) {
            action_triggered = true;
            camera_shake(3, 8);
            var _c = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
            var _dir = 0;
            if (instance_exists(target)) {
                _dir = point_direction(x, y - 24, target.x, target.y - 16);
            } else {
                _dir = (facing == 1) ? 0 : 180;
            }
            _c.hsp = lengthdir_x(5.2, _dir);
            _c.vsp = lengthdir_y(5.2, _dir);
            _c.damage = 3;
        }
        
        if (anim_done) {
            if (act1_shoot_wave_step == 0) {
                // "lặp lại 1 lần nữa cử động bắn rồi chém"
                act1_shoot_wave_step = 1;
                nz_change_state(NZ_STATE.ACT1_SHOOT);
            } else {
                // Đã hoàn thành 2 lần combo (bắn rồi chém)
                act1_shoot_wave_step = 0;
                if (act1_loop_count == 0) {
                    // "sau đó lặp lại cử động 1 thêm 1 lần nữa"
                    act1_loop_count = 1;
                    nz_change_state(NZ_STATE.ACT1_DASH);
                } else {
                    // Đã chạy đủ 2 lần Cử động 1 -> chuyển sang Cử động 2!
                    act1_loop_count = 0;
                    act2_teleport_count = 0;
                    act2_slash_count = 0;
                    nz_change_state(NZ_STATE.ACT2_TELEPORT);
                }
            }
        }
        break;

    // =====================================================================
    // CỬ ĐỘNG 2: TELEPORT 2 LẦN TỚI GẦN NHÂN VẬT -> CHÉM THƯỜNG 2 LẦN
    //            -> TELEPORT RỒI QUAY LẠI CỬ ĐỘNG 1
    // (Teleport tái sử dụng animation lướt)
    // =====================================================================
    case NZ_STATE.ACT2_TELEPORT:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        
        if (teleport_phase == 0) {
            // Mờ ảo biến mất (frame 0..3)
            image_alpha = max(0, 1 - (anim_frame / 3.0));
            if (anim_frame >= 3) {
                teleport_phase = 1;
                image_alpha = 0;
                act2_teleport_count++;
                
                // Chọn vị trí xuất hiện:
                if (act2_teleport_count == 1) {
                    // Teleport lần 1: xuất hiện sát phía sau người chơi
                    if (instance_exists(target)) {
                        teleport_dest_x = target.x - target.facing * 56;
                        teleport_dest_y = target.y;
                    }
                } else if (act2_teleport_count == 2) {
                    // Teleport lần 2: xuất hiện phía trước mặt người chơi
                    if (instance_exists(target)) {
                        teleport_dest_x = target.x + target.facing * 56;
                        teleport_dest_y = target.y;
                    }
                } else {
                    // Teleport lần 3 (sau khi chém 2 lần): teleport ra xa tạo khoảng cách
                    if (instance_exists(target)) {
                        teleport_dest_x = (target.x > room_width * 0.5) ? 96 : room_width - 96;
                        teleport_dest_y = target.y;
                    }
                }
                
                // Giới hạn trong sàn đấu và bám sát mặt sàn
                teleport_dest_x = clamp(teleport_dest_x, 64, room_width - 64);
                while (!place_meeting(teleport_dest_x, teleport_dest_y + 1, oSolid) && teleport_dest_y < room_height - 16) teleport_dest_y++;
                while (place_meeting(teleport_dest_x, teleport_dest_y, oSolid) && teleport_dest_y > 16) teleport_dest_y--;
                
                x = teleport_dest_x;
                y = teleport_dest_y;
                if (instance_exists(target)) facing = (target.x >= x) ? 1 : -1;
                
                // Tái xuất hiện
                teleport_phase = 2;
                anim_frame = 4;
                image_alpha = 1;
            }
        } else if (teleport_phase == 2) {
            image_alpha = 1;
            if (anim_done) {
                is_invulnerable = false;
                if (act2_teleport_count == 1) {
                    // Xong teleport 1 -> teleport lần 2 tới gần nhân vật
                    nz_change_state(NZ_STATE.ACT2_TELEPORT);
                } else if (act2_teleport_count == 2) {
                    // Xong teleport 2 -> chém thường 2 lần theo hướng nhân vật
                    act2_slash_count = 0;
                    nz_change_state(NZ_STATE.ACT2_SLASH);
                } else {
                    // Xong teleport 3 -> quay lại Cử động 1
                    act2_teleport_count = 0;
                    act1_loop_count = 0;
                    act1_shoot_wave_step = 0;
                    nz_change_state(NZ_STATE.ACT1_DASH);
                }
            }
        }
        break;

    case NZ_STATE.ACT2_SLASH:
        hsp = 0;
        if (state_timer == 1 && instance_exists(target)) {
            facing = (target.x >= x) ? 1 : -1;
        }
        
        // Frame 3: chém hitbox cận chiến
        if (anim_frame == 3 && !action_triggered) {
            action_triggered = true;
            camera_shake(4, 8);
            var _hb = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_slash_hitbox);
            _hb.damage = 4;
            _hb.source_boss = self;
        }
        
        if (anim_done) {
            act2_slash_count++;
            if (act2_slash_count < 2) {
                // Chém tiếp lần 2!
                nz_change_state(NZ_STATE.ACT2_SLASH);
            } else {
                // Đã chém xong 2 lần -> Teleport lần 3 rồi quay lại Cử động 1
                nz_change_state(NZ_STATE.ACT2_TELEPORT);
            }
        }
        break;

    // =====================================================================
    // CỬ ĐỘNG 3: SHIN MESSENKOU (KHI CÒN 20% MÁU)
    // + Dậm tay xuống: hàng 13, 14 (16 frames đầy đủ)
    // + Các đường đạn bắn lên: hàng 18 hiệu ứng đất (5 frames), hàng 17 luồng đạn bắn lên (4 frames)
    // -> Sau đó quay lại Cử động 2
    // =====================================================================
    case NZ_STATE.ACT3_MESSENKOU:
        hsp = 0;
        if (state_timer == 1 && instance_exists(target)) {
            facing = (target.x >= x) ? 1 : -1;
        }
        is_invulnerable = true;
        
        // Frame 7 (Zero đấm chạm sàn): Sinh các hiệu ứng dưới đất nổ bùng rồi bắn cột sáng lên
        if (anim_frame == 7 && !action_triggered) {
            action_triggered = true;
            camera_shake(6, 20);
            
            var _spike_xs = [48, 96, 144, 192, 240, 288, 336, 384, 432];
            for (var _i = 0; _i < array_length(_spike_xs); _i++) {
                var _sx = _spike_xs[_i];
                var _sy = y;
                while (!place_meeting(_sx, _sy + 1, oSolid) && _sy < room_height - 16) _sy++;
                while (place_meeting(_sx, _sy, oSolid) && _sy > 16) _sy--;
                
                instance_create_layer(_sx, _sy, "Instances", obj_nz_messenkou_vent);
            }
        }
        
        // Hoàn thành đòn Shin Messenkou -> quay lại Cử động 2!
        if (anim_done) {
            act2_teleport_count = 0;
            act2_slash_count = 0;
            nz_change_state(NZ_STATE.ACT2_TELEPORT);
        }
        break;

    // =====================================================================
    // HỆ THỐNG: HURT (BỊ BẮN CHOÁNG)
    // =====================================================================
    case NZ_STATE.HURT:
        hsp *= 0.85;
        is_invulnerable = true;
        if (state_timer >= 20) {
            // Sau khi hồi tỉnh, tiếp tục chu kỳ hành động
            nz_change_state(NZ_STATE.ACT1_DASH);
        }
        break;

    // =====================================================================
    // TIÊU DIỆT: Hàng cuối 2 frame cuối (frame 2 đang nổ -> frame cuối nằm gục)
    // =====================================================================
    case NZ_STATE.DEFEAT:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        death_timer++;
        
        if (death_timer < 55) {
            // Frame 2 của hàng cuối: Zero đứng chịu chuỗi nổ liên hoàn
            anim_frame = 0;
            if (death_timer % 6 == 0) {
                var _ex = x + irandom_range(-24, 24);
                var _ey = y - irandom_range(8, 48);
                instance_create_layer(_ex, _ey, "Instances", oFX_EnemyExplosion);
                camera_shake(3, 6);
            }
        } else {
            // Sau khi nổ: chuyển sang Frame cuối của hàng cuối (Zero nằm gục trên sàn)
            anim_frame = 1;
        }
        
        if (death_timer == 90) {
            instance_create_layer(x, y - 16, "Instances", oFX_EnemyExplosion);
            camera_shake(6, 16);
            
            // Mở cổng phòng trùm
            if (instance_exists(oTrigger_BossGate)) {
                with (oTrigger_BossGate) {
                    gate_state = GATE_STATE.OPENING;
                }
            }
        }
        break;
}
