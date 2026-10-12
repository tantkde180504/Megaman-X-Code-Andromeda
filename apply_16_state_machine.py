import os
import json

base_dir = r'd:\MZ4\MegamanZ'
obj_dir = os.path.join(base_dir, 'objects')
folder = os.path.join(obj_dir, 'obj_nightmare_zero')

# =========================================================================
# Create_0.gml
# =========================================================================
create_code = '''/// @desc Zero Nightmare (Nightmare Zero) - Complete State Machine & Configuration
event_inherited();

// -------------------------------------------------------------------------
// 1. FINITE STATE MACHINE ENUM (16 Trạng Thái Hoàn Chỉnh Theo Đặc Tả)
// -------------------------------------------------------------------------
enum NZ_STATE {
    INTRO,              // 0: Khởi đầu - Ooze phồng lên hóa người & nạp thanh máu
    IDLE,               // 1: Đứng chờ, tóc bay, quan sát và chọn đòn
    APPROACH,           // 2: Chạy bộ áp sát mục tiêu
    RETREAT,            // 3: Lùi bước tạo khoảng cách
    JUMP,               // 4: Nhảy cao & Bổ chém hào quang xanh (Air Dive Slash)
    DASH,               // 5: Lướt thấp tốc độ cao chém quét
    TELEPORT_OUT,       // 6: Kích hoạt khiên năng lượng, tàng hình biến mất
    TELEPORT_IN,        // 7: Tái xuất hiện tại tọa độ hợp lệ trong đấu trường
    BUSTER_ATTACK,      // 8: Z-Buster - Bắn Double Buster Plasma tốc độ cao
    SABER_ATTACK,       // 9: Z-Saber Slash - Chém lớn cận chiến vòng cung
    SABER_WAVE,         // 10: Saber Wave - Phóng 1 luồng kiếm khí trăng khuyết
    GENMU_ZERO_KAI,     // 11: Genmu Zero Kai - Đại kiếm khí trăng khuyết đa tầng
    SHIN_MESSENKOU,     // 12: Shin Messenkou (Rekkoha) - Cột gai năng lượng toàn sàn
    RECOVERY,           // 13: Trạng thái hồi phục sau đòn đánh (Cơ hội cho người chơi)
    HURT,               // 14: Bị đánh choáng (Stagger) & Khung bất tử i-frames
    DEFEAT              // 15: Nổ liên hoàn, tan rã ooze, mở cổng boss
}

// -------------------------------------------------------------------------
// 2. CẤU HÌNH ĐỘ KHÓ (DIFFICULTY PRESETS: 0 = Easy, 1 = Normal, 2 = Hard)
// -------------------------------------------------------------------------
difficulty = 1; // Mặc định: Normal

// -------------------------------------------------------------------------
// 3. THÔNG SỐ CÂN BẰNG TÙY BIẾN (CONFIGURABLE VARIABLES)
// -------------------------------------------------------------------------
// Chỉ số cơ bản & Máu
max_hp = 64;
hp = max_hp;
prev_hp = max_hp;
contact_damage = 4;

// Tốc độ di chuyển
run_speed_p1   = 2.4;
run_speed_p2   = 3.2;
dash_speed_p1  = 5.8;
dash_speed_p2  = 7.4;
air_jump_vsp   = -7.5;
air_dive_hsp   = 4.2;
air_dive_vsp   = 6.8;

// Thời gian chờ & Hồi chiêu (Cooldown frames)
idle_cooldown_min = (difficulty == 0) ? 45 : ((difficulty == 1) ? 35 : 20);
idle_cooldown_max = (difficulty == 0) ? 65 : ((difficulty == 1) ? 50 : 35);
recovery_time     = (difficulty == 0) ? 25 : ((difficulty == 1) ? 16 : 8);

// Sát thương từng đòn tấn công
dmg_saber_slash   = (difficulty == 0) ? 3 : 5;
dmg_dash_slash    = (difficulty == 0) ? 3 : 4;
dmg_saber_wave    = (difficulty == 0) ? 3 : 4;
dmg_genmu_kai     = (difficulty == 0) ? 4 : 5;
dmg_buster        = (difficulty == 0) ? 3 : 4;
dmg_messenkou     = (difficulty == 0) ? 3 : 4;
dmg_air_dive      = (difficulty == 0) ? 4 : 5;
dmg_floor_burst   = (difficulty == 0) ? 2 : 3;

// Cảnh báo & Hiệu ứng
spike_warning_frames = 20;

// -------------------------------------------------------------------------
// 4. ĐIỀU KHIỂN ANIMATION THỦ CÔNG (image_speed = 0)
// -------------------------------------------------------------------------
image_speed = 0;
anim_sprite = spr_nz_spawn;
anim_frame = 0;
anim_timer = 0;
anim_delay = 7;
anim_done = false;
action_triggered = false;

// -------------------------------------------------------------------------
// 5. BIẾN QUẢN LÝ TRẠNG THÁI & AI
// -------------------------------------------------------------------------
state = NZ_STATE.INTRO;
state_timer = 0;
attack_wait_timer = 45;
last_attack = -1;
repeat_attack_count = 0;

// Hệ thống combo trong Phase 2
combo_count = 0;
max_combos = (difficulty == 2) ? 2 : 1;

// Biến bổ trợ từng kỹ năng
air_phase = 0;
teleport_phase = 0;
teleport_dest_x = x;
teleport_dest_y = y;
burst_shot_count = 0;
burst_shot_timer = 0;
death_timer = 0;

// Mảng tàn ảnh (Afterimage trail)
afterimages = [];

// -------------------------------------------------------------------------
// 6. HÀM CHUYỂN TRẠNG THÁI (State Transition Controller)
// -------------------------------------------------------------------------
nz_change_state = function(_new_state) {
    state = _new_state;
    state_timer = 0;
    anim_frame = 0;
    anim_timer = 0;
    anim_done = false;
    action_triggered = false;
    is_invulnerable = false;
    burst_shot_count = 0;
    burst_shot_timer = 0;
    
    switch (state) {
        case NZ_STATE.INTRO:
            anim_sprite = spr_nz_spawn;
            anim_delay = 7;
            is_invulnerable = true;
            break;
            
        case NZ_STATE.IDLE:
            anim_sprite = spr_nz_idle;
            anim_delay = 8;
            hsp = 0;
            var _min_w = (phase == 1) ? idle_cooldown_min : floor(idle_cooldown_min * 0.65);
            var _max_w = (phase == 1) ? idle_cooldown_max : floor(idle_cooldown_max * 0.65);
            attack_wait_timer = irandom_range(_min_w, _max_w);
            break;
            
        case NZ_STATE.APPROACH:
            anim_sprite = spr_nz_run;
            anim_delay = 5;
            break;
            
        case NZ_STATE.RETREAT:
            anim_sprite = spr_nz_run;
            anim_delay = 5;
            break;
            
        case NZ_STATE.JUMP:
            anim_sprite = spr_nz_air;
            anim_delay = 5;
            air_phase = 0; // 0: Bay lên, 1: Bổ chém xuống, 2: Tiếp đất
            break;
            
        case NZ_STATE.DASH:
            anim_sprite = spr_nz_dash_slash;
            anim_delay = 6;
            hsp = 0;
            break;
            
        case NZ_STATE.TELEPORT_OUT:
            anim_sprite = spr_nz_dome;
            anim_delay = 5;
            hsp = 0;
            vsp = 0;
            is_invulnerable = true;
            break;
            
        case NZ_STATE.TELEPORT_IN:
            anim_sprite = spr_nz_dome;
            anim_delay = 5;
            hsp = 0;
            vsp = 0;
            is_invulnerable = true;
            image_alpha = 1;
            break;
            
        case NZ_STATE.BUSTER_ATTACK:
            anim_sprite = spr_nz_shoot;
            anim_delay = 6;
            hsp = 0;
            break;
            
        case NZ_STATE.SABER_ATTACK:
            anim_sprite = spr_nz_slash_big;
            anim_delay = 5;
            hsp = 0;
            break;
            
        case NZ_STATE.SABER_WAVE:
            anim_sprite = spr_nz_slash_big;
            anim_delay = 5;
            hsp = 0;
            break;
            
        case NZ_STATE.GENMU_ZERO_KAI:
            anim_sprite = spr_nz_slash_big;
            anim_delay = 5;
            hsp = 0;
            break;
            
        case NZ_STATE.SHIN_MESSENKOU:
            anim_sprite = spr_nz_ground_charge;
            anim_delay = 6;
            hsp = 0;
            break;
            
        case NZ_STATE.RECOVERY:
            anim_sprite = spr_nz_idle;
            anim_delay = 8;
            hsp = 0;
            break;
            
        case NZ_STATE.HURT:
            anim_sprite = spr_nz_hurt;
            anim_delay = 6;
            hsp = -facing * 1.5;
            vsp = 0;
            is_invulnerable = true;
            invulnerability_timer = 45;
            flash_timer = 20;
            break;
            
        case NZ_STATE.DEFEAT:
            anim_sprite = spr_nz_death_ooze;
            anim_delay = 10;
            hsp = 0;
            vsp = 0;
            is_invulnerable = true;
            death_timer = 0;
            break;
    }
};

// -------------------------------------------------------------------------
// 7. BỘ CHỌN ĐÒN TẤN CÔNG THEO TRỌNG SỐ & CỰ LY (Weighted Decision System)
// -------------------------------------------------------------------------
nz_choose_attack = function() {
    var _p_dist = 999;
    if (instance_exists(target)) {
        _p_dist = abs(target.x - x);
        facing = (target.x >= x) ? 1 : -1;
    }
    
    var _attacks = [];
    var _weights = [];
    
    if (_p_dist < 110) {
        // CỰ LY GẦN (< 110px)
        array_push(_attacks, NZ_STATE.SABER_ATTACK);  array_push(_weights, 35);
        array_push(_attacks, NZ_STATE.DASH);          array_push(_weights, 25);
        array_push(_attacks, NZ_STATE.TELEPORT_OUT);  array_push(_weights, 20);
        array_push(_attacks, NZ_STATE.SHIN_MESSENKOU);array_push(_weights, 10);
        array_push(_attacks, NZ_STATE.RETREAT);       array_push(_weights, 10);
    } else {
        // CỰ LY XA (>= 110px)
        array_push(_attacks, NZ_STATE.BUSTER_ATTACK); array_push(_weights, 25);
        array_push(_attacks, NZ_STATE.SABER_WAVE);    array_push(_weights, 25);
        array_push(_attacks, NZ_STATE.TELEPORT_OUT);  array_push(_weights, 20);
        array_push(_attacks, NZ_STATE.APPROACH);      array_push(_weights, 15);
        array_push(_attacks, NZ_STATE.JUMP);          array_push(_weights, 15);
        
        // Phase 2 hoặc khi máu dưới 50%: kích hoạt tuyệt kỹ Genmu Zero Kai & Messenkou
        if (phase == 2) {
            array_push(_attacks, NZ_STATE.GENMU_ZERO_KAI); array_push(_weights, 20);
            array_push(_attacks, NZ_STATE.SHIN_MESSENKOU);  array_push(_weights, 15);
        }
    }
    
    // Chống lặp chiêu thức quá 2 lần liên tiếp
    if (repeat_attack_count >= 2) {
        for (var _i = array_length(_attacks) - 1; _i >= 0; _i--) {
            if (_attacks[_i] == last_attack) {
                array_delete(_attacks, _i, 1);
                array_delete(_weights, _i, 1);
            }
        }
    }
    
    var _total_weight = 0;
    for (var _i = 0; _i < array_length(_weights); _i++) {
        _total_weight += _weights[_i];
    }
    
    var _roll = irandom_range(1, max(1, _total_weight));
    var _current_sum = 0;
    var _chosen = _attacks[0];
    
    for (var _i = 0; _i < array_length(_attacks); _i++) {
        _current_sum += _weights[_i];
        if (_roll <= _current_sum) {
            _chosen = _attacks[_i];
            break;
        }
    }
    
    if (_chosen == last_attack) {
        repeat_attack_count++;
    } else {
        last_attack = _chosen;
        repeat_attack_count = 1;
    }
    
    combo_count = 0;
    nz_change_state(_chosen);
};
'''

# =========================================================================
# Step_0.gml
# =========================================================================
step_code = '''/// @desc Zero Nightmare (Nightmare Zero) - Complete Step Logic (Mega Man X6)
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
'''

# =========================================================================
# Draw_0.gml
# =========================================================================
draw_code = '''/// @desc Zero Nightmare - Draw Event (Manual Frame, Afterimage, Aura & Hurt Flash)
// 1. Vẽ các tàn ảnh phía sau
for (var _i = 0; _i < array_length(afterimages); _i++) {
    var _ai = afterimages[_i];
    if (_ai.alpha > 0) {
        var _blend = (phase == 2) ? make_color_rgb(180, 80, 220) : make_color_rgb(80, 160, 255);
        draw_sprite_ext(_ai.sprite, _ai.frame, _ai.x, _ai.y, _ai.facing, 1, 0, _blend, _ai.alpha);
    }
}

// 2. Tông màu cho Phase 2 (Pulsing Purple/Crimson Nightmare Aura)
var _draw_facing = -facing; // Sprite gốc quay trái -> facing = 1 thì scale = -1
var _blend_col = c_white;

if (phase == 2 && state != NZ_STATE.DEFEAT) {
    var _pulse = 0.5 + 0.5 * sin(current_time * 0.008);
    _blend_col = merge_color(c_white, make_color_rgb(255, 120, 180), _pulse * 0.6);
}

// 3. Hiệu ứng nháy trắng khi nhận sát thương hoặc đang trong i-frames
if (flash_timer > 0 || (state == NZ_STATE.HURT && (state_timer % 4 < 2))) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(anim_sprite, anim_frame, x, y, _draw_facing, 1, 0, c_white, 1);
    gpu_set_fog(false, c_white, 0, 0);
} else {
    draw_sprite_ext(anim_sprite, anim_frame, x, y, _draw_facing, 1, 0, _blend_col, image_alpha);
}
'''

# =========================================================================
# CleanUp_0.gml
# =========================================================================
cleanup_code = '''/// @desc Cleanup Data Structures & Projectiles
afterimages = [];
'''

with open(os.path.join(folder, "Create_0.gml"), 'w', encoding='utf-8') as f:
    f.write(create_code)

with open(os.path.join(folder, "Step_0.gml"), 'w', encoding='utf-8') as f:
    f.write(step_code)

with open(os.path.join(folder, "Draw_0.gml"), 'w', encoding='utf-8') as f:
    f.write(draw_code)

with open(os.path.join(folder, "CleanUp_0.gml"), 'w', encoding='utf-8') as f:
    f.write(cleanup_code)

print("Updated obj_nightmare_zero GML event files with 16-state machine successfully!")
