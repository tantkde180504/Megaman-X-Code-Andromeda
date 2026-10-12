/// @desc Zero Nightmare (Nightmare Zero) - Complete Step Logic (Mega Man X6)
// -------------------------------------------------------------------------
// 1. KIỂM TRA TỬ TRẬN & KHÓNG CHẾ TỌA ĐỘ ĐẤU TRƯỜNG
// -------------------------------------------------------------------------
if (hp <= 0 && state != NZ_STATE.DEFEAT) {
    nz_change_state(NZ_STATE.DEFEAT);
}

// Giới hạn tuyệt đối tọa độ x nằm trong lòng đấu trường
x = clamp(x, 32, room_width - 32);

// Phản ứng khi nhận sát thương nặng từ Buster/Saber (Stagger Flinch & i-frames)
if (hp < prev_hp) {
    var _dmg_taken = prev_hp - hp;
    prev_hp = hp;
    
    if (state != NZ_STATE.INTRO && state != NZ_STATE.DEFEAT && 
        state != NZ_STATE.TELEPORT_OUT && state != NZ_STATE.TELEPORT_IN && state != NZ_STATE.HURT) {
        // Đòn Charged Buster hoặc đòn mạnh làm khựng boss (Stagger)
        if (_dmg_taken >= 2) {
            nz_change_state(NZ_STATE.HURT);
        } else {
            flash_timer = 10;
        }
    }
} else if (hp > prev_hp) {
    prev_hp = hp;
}

// Gọi Step cơ sở của obj_boss_parent (Trừ khi JUMP, TELEPORT, hoặc DEFEAT tự xử lý vật lý)
if (state != NZ_STATE.JUMP && state != NZ_STATE.TELEPORT_OUT && 
    state != NZ_STATE.TELEPORT_IN && state != NZ_STATE.DEFEAT) {
    event_inherited();
} else {
    if (flash_timer > 0) flash_timer--;
    if (invulnerability_timer > 0) invulnerability_timer--;
    if (instance_exists(oPlayer)) target = instance_nearest(x, y, oPlayer);
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
// 3. HIỆU ỨNG TÀN ẢNH (Afterimage Trail)
// -------------------------------------------------------------------------
if (state == NZ_STATE.DASH || state == NZ_STATE.JUMP || 
    state == NZ_STATE.TELEPORT_OUT || state == NZ_STATE.TELEPORT_IN) {
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
// 4. BỘ ĐIỀU KHIỂN FINITE STATE MACHINE (16 TRẠNG THÁI)
// -------------------------------------------------------------------------
switch (state) {

    // =====================================================================
    // 0. INTRO: Trồi lên từ ooze & Nạp đầy thanh máu
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
                nz_change_state(NZ_STATE.IDLE);
            }
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
    // 2. APPROACH: Chạy bộ áp sát người chơi
    // =====================================================================
    case NZ_STATE.APPROACH:
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
                nz_change_state((random(100) < 55) ? NZ_STATE.SABER_ATTACK : NZ_STATE.DASH);
            }
        } else {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 3. RETREAT: Lùi bước tạo khoảng cách
    // =====================================================================
    case NZ_STATE.RETREAT:
        if (anim_done) {
            anim_frame = 0;
            anim_done = false;
        }
        if (instance_exists(target)) {
            facing = (target.x >= x) ? 1 : -1;
            hsp = -facing * run_speed_p1 * 1.1;
        }
        if (state_timer >= 35 || place_meeting(x + hsp, y, oSolid)) {
            hsp = 0;
            nz_change_state((random(100) < 50) ? NZ_STATE.BUSTER_ATTACK : NZ_STATE.SABER_WAVE);
        }
        break;

    // =====================================================================
    // 4. JUMP: Nhảy cao & Bổ chém hào quang xanh (Air Dive Slash)
    // =====================================================================
    case NZ_STATE.JUMP:
        if (air_phase == 0) {
            // Giai đoạn A: Nhảy chéo lên không
            if (state_timer == 1) {
                vsp = air_jump_vsp;
                hsp = facing * 2.2;
                grounded = false;
            }
            vsp += grav;
            x += hsp;
            y += vsp;
            anim_frame = min(anim_frame, 3);
            if (vsp >= -0.5) air_phase = 1;
        } else if (air_phase == 1) {
            // Giai đoạn B: Bổ chém dốc xuống với hào quang xanh
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
                
                // Sinh sóng xung kích chấn động hai bên
                var _b1 = instance_create_layer(x - 24, y, "Instances", obj_nz_floor_burst);
                _b1.damage = dmg_floor_burst;
                var _b2 = instance_create_layer(x + 24, y, "Instances", obj_nz_floor_burst);
                _b2.damage = dmg_floor_burst;
                
                anim_frame = 9;
                state_timer = 0;
            } else {
                y += vsp;
            }
            
            // Va chạm gây sát thương lúc bổ xuống
            if (instance_exists(target) && place_meeting(x, y, target)) {
                if (target.iframes <= 0 && target.state != PLAYER_STATE.HURT && target.state != PLAYER_STATE.DEATH) {
                    player_take_damage(dmg_air_dive, facing);
                }
            }
        } else if (air_phase == 2) {
            hsp = 0;
            vsp = 0;
            if (state_timer >= 15) {
                nz_change_state(NZ_STATE.RECOVERY);
            }
        }
        break;

    // =====================================================================
    // 5. DASH: Lướt thấp tốc độ cao chém quét
    // =====================================================================
    case NZ_STATE.DASH:
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
                nz_change_state(NZ_STATE.SABER_ATTACK);
            } else {
                nz_change_state(NZ_STATE.RECOVERY);
            }
        }
        break;

    // =====================================================================
    // 6. TELEPORT_OUT: Kích hoạt khiên năng lượng, tàng hình biến mất
    // =====================================================================
    case NZ_STATE.TELEPORT_OUT:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        if (anim_done) {
            image_alpha = 0; // Tàng hình
            
            // Chọn tọa độ dịch chuyển an toàn bên trong đấu trường
            if (instance_exists(target)) {
                var _choice = irandom(2);
                var _dest = target.x;
                if (_choice == 0) {
                    _dest = target.x - target.facing * 56; // Sau lưng người chơi
                } else if (_choice == 1) {
                    _dest = (target.x > room_width * 0.5) ? 96 : room_width - 96; // Góc đối diện
                } else {
                    _dest = room_width * 0.5 + irandom_range(-30, 30); // Trung tâm sàn
                }
                
                _dest = clamp(_dest, 64, room_width - 64);
                teleport_dest_x = _dest;
                teleport_dest_y = target.y;
                
                // Căn chỉnh sát mặt sàn
                while (!place_meeting(teleport_dest_x, teleport_dest_y + 1, oSolid) && teleport_dest_y < room_height - 16) teleport_dest_y++;
                while (place_meeting(teleport_dest_x, teleport_dest_y, oSolid) && teleport_dest_y > 16) teleport_dest_y--;
            }
            
            nz_change_state(NZ_STATE.TELEPORT_IN);
        }
        break;

    // =====================================================================
    // 7. TELEPORT_IN: Tái xuất hiện tại tọa độ mới & Lập tức ra đòn
    // =====================================================================
    case NZ_STATE.TELEPORT_IN:
        x = teleport_dest_x;
        y = teleport_dest_y;
        if (instance_exists(target)) {
            facing = (target.x >= x) ? 1 : -1;
        }
        if (anim_done) {
            is_invulnerable = false;
            var _dist = (instance_exists(target)) ? abs(target.x - x) : 200;
            if (_dist < 110) {
                nz_change_state((random(100) < 55) ? NZ_STATE.SABER_ATTACK : NZ_STATE.DASH);
            } else {
                nz_change_state((random(100) < 50) ? NZ_STATE.BUSTER_ATTACK : NZ_STATE.SABER_WAVE);
            }
        }
        break;

    // =====================================================================
    // 8. BUSTER_ATTACK: Z-Buster - Double Buster Plasma siêu tốc
    // =====================================================================
    case NZ_STATE.BUSTER_ATTACK:
        hsp = 0;
        if (anim_frame == 1 && !action_triggered) {
            instance_create_layer(x + facing * 22, y - 28, "Instances", obj_nz_ring_fx);
        }
        if (anim_frame == 2) {
            burst_shot_timer++;
            if (burst_shot_count == 0) {
                burst_shot_count = 1;
                burst_shot_timer = 0;
                camera_shake(2, 6);
                var _b1 = instance_create_layer(x + facing * 26, y - 28, "Instances", obj_nz_drill);
                _b1.hsp = facing * 6.5;
                _b1.damage = dmg_buster;
                hsp = -facing * 1.5;
            } else if (burst_shot_count == 1 && burst_shot_timer >= 12) {
                burst_shot_count = 2;
                camera_shake(2, 6);
                var _b2 = instance_create_layer(x + facing * 26, y - 28, "Instances", obj_nz_drill);
                _b2.hsp = facing * 6.5;
                _b2.damage = dmg_buster;
                hsp = -facing * 1.0;
                
                // Cơ hội bắn kèm vòng năng lượng (Energy Ring)
                if (random(100) < 40) {
                    var _ring = instance_create_layer(x + facing * 26, y - 28, "Instances", obj_nz_ring_fx);
                    _ring.hsp = facing * 5.2;
                    _ring.damage = dmg_buster;
                }
            }
        }
        if (anim_done && burst_shot_count >= 2) {
            nz_change_state(NZ_STATE.RECOVERY);
        }
        break;

    // =====================================================================
    // 9. SABER_ATTACK: Z-Saber Slash - Chém cận chiến vòng cung lớn
    // =====================================================================
    case NZ_STATE.SABER_ATTACK:
        if (anim_frame <= 1) {
            hsp = -facing * 1.0;
        } else {
            hsp = 0;
        }
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(5, 10);
            var _hb = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_slash_hitbox);
            _hb.damage = (phase == 1) ? dmg_saber_slash : dmg_saber_slash + 1;
            _hb.source_boss = self;
            
            // Phase 2: Kèm theo kiếm khí trăng khuyết bay thẳng
            if (phase == 2) {
                var _c = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
                _c.hsp = facing * 4.5;
                _c.vsp = 0;
                _c.damage = dmg_saber_wave;
            }
        }
        if (anim_done) {
            if (phase == 2 && combo_count < max_combos) {
                combo_count++;
                nz_change_state(NZ_STATE.SABER_WAVE);
            } else {
                nz_change_state(NZ_STATE.RECOVERY);
            }
        }
        break;

    // =====================================================================
    // 10. SABER_WAVE: Phóng 1 luồng kiếm khí trăng khuyết bay ngang
    // =====================================================================
    case NZ_STATE.SABER_WAVE:
        hsp = 0;
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(3, 8);
            var _c1 = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
            _c1.hsp = facing * 4.2;
            _c1.vsp = 0;
            _c1.damage = dmg_saber_wave;
        }
        if (anim_done) {
            nz_change_state(NZ_STATE.RECOVERY);
        }
        break;

    // =====================================================================
    // 11. GENMU_ZERO_KAI: Đại kiếm khí trăng khuyết đa tầng (Special)
    // =====================================================================
    case NZ_STATE.GENMU_ZERO_KAI:
        hsp = 0;
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(4, 12);
            
            // Đạn 1: Ngang
            var _c1 = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
            _c1.hsp = facing * 4.5;
            _c1.vsp = 0;
            _c1.damage = dmg_genmu_kai;
            
            // Đạn 2: Chếch lên
            var _c2 = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
            _c2.hsp = facing * 4.0;
            _c2.vsp = -2.0;
            _c2.damage = dmg_genmu_kai;
            
            // Đạn 3: Chếch xuống kẹp góc
            var _c3 = instance_create_layer(x + facing * 24, y - 24, "Instances", obj_nz_crescent);
            _c3.hsp = facing * 4.0;
            _c3.vsp = 2.0;
            _c3.damage = dmg_genmu_kai;
        }
        if (anim_done) {
            nz_change_state(NZ_STATE.RECOVERY);
        }
        break;

    // =====================================================================
    // 12. SHIN_MESSENKOU: Cột gai năng lượng toàn sàn (Rekkoha)
    // =====================================================================
    case NZ_STATE.SHIN_MESSENKOU:
        hsp = 0;
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(6, 16);
            
            // Sinh các cột gai năng lượng trải khắp sàn đấu có khoảng cách an toàn
            var _spike_xs = [64, 128, 192, 256, 320, 384, 420];
            for (var _i = 0; _i < array_length(_spike_xs); _i++) {
                var _sx = _spike_xs[_i];
                var _sy = y;
                while (!place_meeting(_sx, _sy + 1, oSolid) && _sy < room_height - 16) _sy++;
                while (place_meeting(_sx, _sy, oSolid) && _sy > 16) _sy--;
                var _sp = instance_create_layer(_sx, _sy, "Instances", obj_nz_spike);
                _sp.damage = dmg_messenkou;
            }
        }
        if (anim_done) {
            nz_change_state(NZ_STATE.RECOVERY);
        }
        break;

    // =====================================================================
    // 13. SKULL_WAVE: Sóng kiếm đầu lâu bám sàn (Skull Wave)
    // =====================================================================
    case NZ_STATE.SKULL_WAVE:
        hsp = 0;
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(4, 10);
            var _sk = instance_create_layer(x + facing * 24, y - 8, "Instances", obj_nz_skull_wave);
            _sk.hsp = facing * 4.0;
            _sk.damage = dmg_floor_burst + 1;
        }
        if (anim_done) {
            nz_change_state(NZ_STATE.RECOVERY);
        }
        break;

    // =====================================================================
    // 13. RECOVERY: Khoảng nghỉ hồi phục (Thời cơ phản công cho người chơi)
    // =====================================================================
    case NZ_STATE.RECOVERY:
        hsp = 0;
        if (state_timer >= recovery_time) {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 14. HURT: Choáng đòn (Stagger) & Kích hoạt i-frames
    // =====================================================================
    case NZ_STATE.HURT:
        hsp *= 0.85;
        is_invulnerable = true;
        if (state_timer >= 22) {
            // Theo video X6: Boss sau khi bị bắn trúng sẽ lập tức teleport để phá thế ép góc
            if (random(100) < 80) {
                nz_change_state(NZ_STATE.TELEPORT_OUT);
            } else {
                nz_change_state(NZ_STATE.IDLE);
            }
        }
        break;

    // =====================================================================
    // 15. DEFEAT: Nổ liên hoàn, ooze tan rã, xóa object và mở cổng Boss
    // =====================================================================
    case NZ_STATE.DEFEAT:
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
