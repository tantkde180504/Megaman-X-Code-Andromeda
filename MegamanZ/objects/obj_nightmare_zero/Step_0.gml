/// @desc Nightmare Zero - Step Event (Mega Man X6 Video Mechanics)
// -------------------------------------------------------------------------
// 1. Kiểm tra Tử Trận (Death Trigger) & Giới Hạn Tọa Độ Đấu Trường
// -------------------------------------------------------------------------
if (hp <= 0 && state != NZ_STATE.DEATH) {
    nz_change_state(NZ_STATE.DEATH);
}

// KHÓNG CHẾ TỌA ĐỘ: Đảm bảo Boss KHÔNG BAO GIỜ lọt ra ngoài đấu trường
x = clamp(x, 32, room_width - 32);

// Phản ứng khi nhận sát thương nặng từ Buster/Saber (Stagger & Invincibility)
if (hp < prev_hp) {
    var _dmg_taken = prev_hp - hp;
    prev_hp = hp;
    
    if (state != NZ_STATE.SPAWN && state != NZ_STATE.DEATH && state != NZ_STATE.DOME_TELEPORT && state != NZ_STATE.HURT) {
        // Đòn Charged Buster hoặc đòn mạnh làm khựng boss (Stagger Flinch)
        if (_dmg_taken >= 2) {
            nz_change_state(NZ_STATE.HURT);
        } else {
            flash_timer = 10;
        }
    }
} else if (hp > prev_hp) {
    prev_hp = hp;
}

// Gọi Step cơ sở của obj_boss_parent (Trừ khi đang ở AIR_ATTACK, DOME_TELEPORT hay DEATH)
if (state != NZ_STATE.AIR_ATTACK && state != NZ_STATE.DOME_TELEPORT && state != NZ_STATE.DEATH) {
    event_inherited();
} else {
    // Vẫn cập nhật target và flash timer
    if (flash_timer > 0) flash_timer--;
    if (invulnerability_timer > 0) invulnerability_timer--;
    if (instance_exists(oPlayer)) target = instance_nearest(x, y, oPlayer);
}

state_timer++;

// -------------------------------------------------------------------------
// 2. Diễn hoạt Animation thủ công (image_speed = 0)
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
// 3. Cập nhật Hiệu ứng Tàn Ảnh (Afterimage Trail)
// -------------------------------------------------------------------------
if (state == NZ_STATE.DASH_SLASH || state == NZ_STATE.AIR_ATTACK || state == NZ_STATE.DOME_TELEPORT) {
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
// 4. State Machine (13 Trạng thái chuẩn Mega Man X6)
// -------------------------------------------------------------------------
switch (state) {

    // =====================================================================
    // 0. SPAWN: Ooze phồng lên rồi hóa thành người
    // =====================================================================
    case NZ_STATE.SPAWN:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        if (anim_done && intro_done) {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 1. IDLE: Đứng chờ, tóc bay, hướng về người chơi
    // =====================================================================
    case NZ_STATE.IDLE:
        hsp = 0;
        if (anim_done) {
            anim_frame = 0;
            anim_done = false;
        }
        if (instance_exists(target)) {
            facing = (target.x >= x) ? 1 : -1;
        }
        
        attack_wait_timer--;
        if (attack_wait_timer <= 0) {
            nz_choose_attack();
        }
        break;

    // =====================================================================
    // 2. CHASE: Chạy bộ áp sát người chơi
    // =====================================================================
    case NZ_STATE.CHASE:
        if (anim_done) {
            anim_frame = 0;
            anim_done = false;
        }
        if (instance_exists(target)) {
            facing = (target.x >= x) ? 1 : -1;
            var _spd = (phase == 1) ? run_speed_p1 : run_speed_p2;
            hsp = facing * _spd;
            
            if (abs(target.x - x) < 80 || state_timer >= 60) {
                hsp = 0;
                nz_change_state((random(100) < 55) ? NZ_STATE.SLASH_BIG : NZ_STATE.DASH_SLASH);
            }
        } else {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 3. SLASH_BIG: Lùi nhẹ, chém lớn vòng cung khí; Phase 2 bắn thêm đạn
    // =====================================================================
    case NZ_STATE.SLASH_BIG:
        if (anim_frame <= 1) {
            hsp = -facing * 1.0;
        } else {
            hsp = 0;
        }
        
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(5, 10);
            
            var _hb = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_slash_hitbox);
            _hb.damage = (phase == 1) ? dmg_slash_big : dmg_slash_big + 1;
            _hb.source_boss = self;
            
            // Phase 2: Kèm theo đạn trăng khuyết bay thẳng
            if (phase == 2) {
                var _c = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
                _c.hsp = facing * 4.5;
                _c.vsp = 0;
                _c.damage = dmg_crescent;
            }
        }
        
        if (anim_done) {
            if (phase == 2 && combo_count < max_combos) {
                combo_count++;
                nz_change_state(NZ_STATE.CRESCENT_SHOT);
            } else {
                nz_change_state(NZ_STATE.IDLE);
            }
        }
        break;

    // =====================================================================
    // 4. DASH_SLASH: Lao ngang tốc độ cao, hitbox thấp, trượt dừng
    // =====================================================================
    case NZ_STATE.DASH_SLASH:
        if (anim_frame == 0) {
            hsp = 0;
        } else if (anim_frame >= 1 && anim_frame <= 3) {
            var _d_spd = (phase == 1) ? dash_speed_p1 : dash_speed_p2;
            hsp = facing * _d_spd;
            
            if (anim_frame == 1 && !action_triggered) {
                action_triggered = true;
                var _hb = instance_create_layer(x + facing * 20, y - 16, "Instances", obj_nz_slash_hitbox);
                _hb.damage = dmg_dash_slash;
                _hb.source_boss = self;
            }
        } else if (anim_frame >= 4) {
            hsp *= 0.55;
        }
        
        if (anim_done) {
            if (phase == 2 && combo_count < max_combos) {
                combo_count++;
                nz_change_state(NZ_STATE.SLASH_BIG);
            } else {
                nz_change_state(NZ_STATE.IDLE);
            }
        }
        break;

    // =====================================================================
    // 5. CRESCENT_SHOT: Bắn đạn trăng khuyết (Genmurei / Denharei)
    // =====================================================================
    case NZ_STATE.CRESCENT_SHOT:
        hsp = 0;
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(3, 8);
            
            // Đạn 1: Bay ngang
            var _c1 = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
            _c1.hsp = facing * 4.2;
            _c1.vsp = 0;
            _c1.damage = dmg_crescent;
            
            // Đạn 2: Chếch lên
            var _c2 = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
            _c2.hsp = facing * 3.8;
            _c2.vsp = -1.8;
            _c2.damage = dmg_crescent;
            
            // Đạn 3 (Phase 2): Chếch xuống tạo thế kẹp góc
            if (phase == 2) {
                var _c3 = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
                _c3.hsp = facing * 3.8;
                _c3.vsp = 1.8;
                _c3.damage = dmg_crescent;
            }
        }
        
        if (anim_done) {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 6. GROUND_SPIKES: Shin Messenkou (Rekkoha) - Cột gai trải khắp sàn đấu
    // =====================================================================
    case NZ_STATE.GROUND_SPIKES:
        hsp = 0;
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(6, 16);
            
            // Trải các cột gai năng lượng khắp đấu trường có khoảng cách an toàn
            var _spike_xs = [64, 128, 192, 256, 320, 384, 420];
            for (var _i = 0; _i < array_length(_spike_xs); _i++) {
                var _sx = _spike_xs[_i];
                var _sy = y;
                while (!place_meeting(_sx, _sy + 1, oSolid) && _sy < room_height - 16) _sy++;
                while (place_meeting(_sx, _sy, oSolid) && _sy > 16) _sy--;
                
                var _sp = instance_create_layer(_sx, _sy, "Instances", obj_nz_spike);
                _sp.damage = dmg_spike;
            }
        }
        
        if (anim_done) {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 7. BUSTER_DRILL: Double Buster Shot siêu tốc
    // =====================================================================
    case NZ_STATE.BUSTER_DRILL:
        hsp = 0;
        if (anim_frame == 1 && !action_triggered) {
            instance_create_layer(x + facing * 22, y - 28, "Instances", obj_nz_ring_fx);
        }
        
        if (anim_frame == 2) {
            burst_shot_timer++;
            // Bắn phát 1
            if (burst_shot_count == 0) {
                burst_shot_count = 1;
                burst_shot_timer = 0;
                camera_shake(2, 6);
                var _drill1 = instance_create_layer(x + facing * 26, y - 28, "Instances", obj_nz_drill);
                _drill1.hsp = facing * 6.5;
                _drill1.damage = dmg_drill;
                hsp = -facing * 1.5;
            } 
            // Bắn phát 2 sau 12 frames
            else if (burst_shot_count == 1 && burst_shot_timer >= 12) {
                burst_shot_count = 2;
                camera_shake(2, 6);
                var _drill2 = instance_create_layer(x + facing * 26, y - 28, "Instances", obj_nz_drill);
                _drill2.hsp = facing * 6.5;
                _drill2.damage = dmg_drill;
                hsp = -facing * 1.0;
            }
        }
        
        if (anim_done && burst_shot_count >= 2) {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 8. AIR_ATTACK: Nhảy lên, lao chém chéo viền xanh, hạ cánh nổ địa chấn
    // =====================================================================
    case NZ_STATE.AIR_ATTACK:
        if (air_phase == 0) {
            if (state_timer == 1) {
                vsp = air_jump_vsp;
                hsp = facing * 2.2;
                grounded = false;
            }
            vsp += grav;
            x += hsp;
            y += vsp;
            
            anim_frame = min(anim_frame, 3);
            if (vsp >= -0.5) {
                air_phase = 1;
            }
        } else if (air_phase == 1) {
            vsp = air_dive_vsp;
            hsp = facing * air_dive_hsp;
            anim_frame = clamp(anim_frame, 4, 8);
            
            if (place_meeting(x + hsp, y, oSolid)) {
                while (!place_meeting(x + sign(hsp), y, oSolid)) x += sign(hsp);
                hsp = 0;
            }
            x += hsp;
            
            if (place_meeting(x, y + vsp, oSolid)) {
                while (!place_meeting(x, y + sign(vsp), oSolid)) y += sign(vsp);
                vsp = 0;
                grounded = true;
                air_phase = 2;
                camera_shake(6, 14);
                
                var _b1 = instance_create_layer(x - 24, y, "Instances", obj_nz_floor_burst);
                _b1.damage = dmg_shockwave;
                var _b2 = instance_create_layer(x + 24, y, "Instances", obj_nz_floor_burst);
                _b2.damage = dmg_shockwave;
                
                anim_frame = 9;
                state_timer = 0;
            } else {
                y += vsp;
            }
            
            if (instance_exists(target) && place_meeting(x, y, target)) {
                if (target.iframes <= 0 && target.state != PLAYER_STATE.HURT && target.state != PLAYER_STATE.DEATH) {
                    player_take_damage(dmg_air_dive, facing);
                }
            }
        } else if (air_phase == 2) {
            hsp = 0;
            vsp = 0;
            if (state_timer >= 15) {
                nz_change_state(NZ_STATE.IDLE);
            }
        }
        break;

    // =====================================================================
    // 9. DOME_TELEPORT: Tạo khiên bất tử, dịch chuyển chiến thuật (MM X6)
    // =====================================================================
    case NZ_STATE.DOME_TELEPORT:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        
        if (teleport_phase == 0) {
            // Khiên mở rộng bao bọc Zero
            if (anim_done) {
                teleport_phase = 1;
                state_timer = 0;
                image_alpha = 0; // Tàng hình
            }
        } else if (teleport_phase == 1) {
            // Chọn tọa độ dịch chuyển chiến thuật (3 phương án chuẩn X6)
            if (state_timer >= 12) {
                if (instance_exists(target)) {
                    var _choice = irandom(2);
                    var _dest_x = target.x;
                    if (_choice == 0) {
                        // Sau lưng người chơi
                        _dest_x = target.x - target.facing * 56;
                    } else if (_choice == 1) {
                        // Phía đối diện người chơi
                        _dest_x = (target.x > room_width * 0.5) ? 96 : room_width - 96;
                    } else {
                        // Trung tâm sàn đấu
                        _dest_x = room_width * 0.5 + irandom_range(-30, 30);
                    }
                    
                    // Giới hạn tuyệt đối trong đấu trường
                    _dest_x = clamp(_dest_x, 64, room_width - 64);
                    x = _dest_x;
                    y = target.y;
                    
                    // Căn chỉnh mặt sàn
                    while (!place_meeting(x, y + 1, oSolid) && y < room_height - 16) y++;
                    while (place_meeting(x, y, oSolid) && y > 16) y--;
                    
                    facing = (target.x >= x) ? 1 : -1;
                }
                image_alpha = 1;
                anim_frame = 0;
                anim_done = false;
                teleport_phase = 2;
            }
        } else if (teleport_phase == 2) {
            // Khiên thu nhỏ kết thúc -> Lập tức phản đòn!
            if (anim_done) {
                is_invulnerable = false;
                var _dist = (instance_exists(target)) ? abs(target.x - x) : 200;
                if (_dist < 110) {
                    nz_change_state((random(100) < 55) ? NZ_STATE.SLASH_BIG : NZ_STATE.DASH_SLASH);
                } else {
                    nz_change_state((random(100) < 50) ? NZ_STATE.BUSTER_DRILL : NZ_STATE.CRESCENT_SHOT);
                }
            }
        }
        break;

    // =====================================================================
    // 10. SKULL_WAVE (Phase 2): Đầu lâu tối chạy sàn kéo theo gai nổ
    // =====================================================================
    case NZ_STATE.SKULL_WAVE:
        hsp = 0;
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(4, 10);
            
            var _sk = instance_create_layer(x + facing * 20, y - 4, "Instances", obj_nz_skull_wave);
            _sk.hsp = facing * 3.5;
            _sk.damage = dmg_skull_wave;
        }
        
        if (anim_done) {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 11. HURT: Choáng đòn (Stagger Flinch) & Kích hoạt i-frames né đòn
    // =====================================================================
    case NZ_STATE.HURT:
        hsp *= 0.85;
        is_invulnerable = true;
        // Sau 22 frames khựng choáng:
        if (state_timer >= 22) {
            // Theo cơ chế video X6: Boss sau khi bị bắn trúng sẽ bật khiên teleport để phá thế ép góc
            if (random(100) < 80) {
                nz_change_state(NZ_STATE.DOME_TELEPORT);
            } else {
                nz_change_state(NZ_STATE.IDLE);
            }
        }
        break;

    // =====================================================================
    // 12. DEATH: Nổ liên hoàn, ooze tan rã, xóa object và mở cổng Boss
    // =====================================================================
    case NZ_STATE.DEATH:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        death_timer++;
        
        if (death_timer % 6 == 0 && death_timer < 70) {
            var _ex = x + irandom_range(-24, 24);
            var _ey = y - irandom_range(8, 50);
            instance_create_layer(_ex, _ey, "Instances", oFX_EnemyExplosion);
            camera_shake(3, 6);
        }
        
        if (death_timer == 45) {
            anim_sprite = spr_nz_death_ooze;
            anim_frame = 0;
            anim_delay = 12;
            anim_done = false;
        }
        
        if (death_timer >= 95) {
            instance_create_layer(x, y - 24, "Instances", oFX_EnemyExplosion);
            camera_shake(6, 16);
            
            if (instance_exists(oTrigger_BossGate)) {
                with (oTrigger_BossGate) {
                    gate_state = GATE_STATE.OPENING;
                }
            }
            
            instance_destroy();
            return;
        }
        break;
}
