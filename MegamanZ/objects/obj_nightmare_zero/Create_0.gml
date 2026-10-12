/// @desc Nightmare Zero Boss - Initialization & Config
event_inherited();

// -------------------------------------------------------------------------
// ENUM STATE MACHINE (13 Trạng thái)
// -------------------------------------------------------------------------
enum NZ_STATE {
    SPAWN,          // 0: Ooze trồi lên hóa thân thành người
    IDLE,           // 1: Đứng chờ, tóc bay, quan sát người chơi
    CHASE,          // 2: Chạy bộ áp sát mục tiêu
    SLASH_BIG,      // 3: Chém lớn tạo vòng cung khí (Phase 2 bắn thêm kiếm khí)
    DASH_SLASH,     // 4: Lướt thấp tốc độ cao chém quét
    CRESCENT_SHOT,  // 5: Bắn đạn trăng khuyết (1-3 đạn)
    GROUND_SPIKES,  // 6: Gồng cắm kiếm, gai trồi lên từ sàn
    BUSTER_DRILL,   // 7: Giơ Buster bắn mũi khoan tốc độ cao
    AIR_ATTACK,     // 8: Nhảy chém bổ chéo hào quang xanh, tiếp đất gây địa chấn
    DOME_TELEPORT,  // 9: (Phase 2) Khiên năng lượng, dịch chuyển sau lưng người chơi
    SKULL_WAVE,     // 10: (Phase 2) Sọ bóng tối chạy sàn kéo theo gai nổ
    HURT,           // 11: Bị đánh choáng nhẹ
    DEATH           // 12: Nổ liên hoàn, tan rã thành ooze, mở cổng boss
}

// -------------------------------------------------------------------------
// CÁC BIẾN CÓ THỂ ĐIỀU CHỈNH CÂN BẰNG (CUSTOMIZABLE VARIABLES)
// -------------------------------------------------------------------------
// 1. Chỉ số cơ bản & Máu
max_hp = 64;
hp = max_hp;
contact_damage = 4;

// 2. Tốc độ di chuyển
run_speed_p1 = 2.4;
run_speed_p2 = 3.2;
dash_speed_p1 = 5.8;
dash_speed_p2 = 7.4;
air_jump_vsp = -7.5;
air_dive_hsp = 4.2;
air_dive_vsp = 6.8;

// 3. Thời gian chờ giữa các đòn (Cooldown frames)
idle_wait_p1_min = 40;
idle_wait_p1_max = 60;
idle_wait_p2_min = 20;
idle_wait_p2_max = 35;

// 4. Sát thương từng kỹ năng
dmg_slash_big   = 5;
dmg_dash_slash  = 4;
dmg_crescent    = 4;
dmg_spike       = 4;
dmg_drill       = 5;
dmg_air_dive    = 5;
dmg_shockwave   = 3;
dmg_skull_wave  = 4;

// 5. Cảnh báo & Hiệu ứng
spike_warning_frames = 25;

// -------------------------------------------------------------------------
// ĐIỀU KHIỂN ANIMATION THỦ CÔNG (image_speed = 0)
// -------------------------------------------------------------------------
image_speed = 0;
anim_sprite = spr_nz_spawn;
anim_frame = 0;
anim_timer = 0;
anim_delay = 7;
anim_done = false;
action_triggered = false;

// -------------------------------------------------------------------------
// BIẾN QUẢN LÝ TRẠNG THÁI & AI
// -------------------------------------------------------------------------
state = NZ_STATE.SPAWN;
state_timer = 0;
attack_wait_timer = 50;
last_attack = -1;
repeat_attack_count = 0;

// Hệ thống combo trong Phase 2
combo_count = 0;
max_combos = 1; // Cho phép combo tối đa 2 đòn liên tiếp trong Phase 2

// Biến bổ trợ từng đòn
air_phase = 0;
teleport_phase = 0;
spike_counter = 0;
spike_timer = 0;
death_timer = 0;

// Mảng tàn ảnh (Afterimage trail)
afterimages = [];

// -------------------------------------------------------------------------
// HÀM CHUYỂN TRẠNG THÁI (State Transition Helper)
// -------------------------------------------------------------------------
nz_change_state = function(_new_state) {
    state = _new_state;
    state_timer = 0;
    anim_frame = 0;
    anim_timer = 0;
    anim_done = false;
    action_triggered = false;
    is_invulnerable = false;
    
    switch (state) {
        case NZ_STATE.SPAWN:
            anim_sprite = spr_nz_spawn;
            anim_delay = 7;
            is_invulnerable = true;
            break;
            
        case NZ_STATE.IDLE:
            anim_sprite = spr_nz_idle;
            anim_delay = 8;
            hsp = 0;
            if (phase == 1) {
                attack_wait_timer = irandom_range(idle_wait_p1_min, idle_wait_p1_max);
            } else {
                attack_wait_timer = irandom_range(idle_wait_p2_min, idle_wait_p2_max);
            }
            break;
            
        case NZ_STATE.CHASE:
            anim_sprite = spr_nz_run;
            anim_delay = 5;
            break;
            
        case NZ_STATE.SLASH_BIG:
            anim_sprite = spr_nz_slash_big;
            anim_delay = 5;
            hsp = 0;
            break;
            
        case NZ_STATE.DASH_SLASH:
            anim_sprite = spr_nz_dash_slash;
            anim_delay = 6;
            hsp = 0;
            break;
            
        case NZ_STATE.CRESCENT_SHOT:
            anim_sprite = spr_nz_slash_big;
            anim_delay = 5;
            hsp = 0;
            break;
            
        case NZ_STATE.GROUND_SPIKES:
            anim_sprite = spr_nz_ground_charge;
            anim_delay = 6;
            hsp = 0;
            spike_counter = 0;
            spike_timer = 0;
            break;
            
        case NZ_STATE.BUSTER_DRILL:
            anim_sprite = spr_nz_shoot;
            anim_delay = 7;
            hsp = 0;
            break;
            
        case NZ_STATE.AIR_ATTACK:
            anim_sprite = spr_nz_air;
            anim_delay = 5;
            air_phase = 0; // 0: Nhảy lên, 1: Bổ xuống, 2: Tiếp đất
            break;
            
        case NZ_STATE.DOME_TELEPORT:
            anim_sprite = spr_nz_dome;
            anim_delay = 6;
            hsp = 0;
            vsp = 0;
            teleport_phase = 0;
            is_invulnerable = true;
            break;
            
        case NZ_STATE.SKULL_WAVE:
            anim_sprite = spr_nz_ground_charge;
            anim_delay = 6;
            hsp = 0;
            break;
            
        case NZ_STATE.HURT:
            anim_sprite = spr_nz_hurt;
            anim_delay = 8;
            hsp = -facing * 1.5;
            break;
            
        case NZ_STATE.DEATH:
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
// HÀM CHỌN ĐÒN TẤN CÔNG THEO TRỌNG SỐ (Weighted Attack Chooser)
// -------------------------------------------------------------------------
nz_choose_attack = function() {
    var _p_dist = 999;
    if (instance_exists(target)) {
        _p_dist = abs(target.x - x);
        facing = (target.x >= x) ? 1 : -1;
    }
    
    var _attacks = [];
    var _weights = [];
    
    if (_p_dist < 120) {
        // CỰ LY GẦN (< 120px)
        array_push(_attacks, NZ_STATE.SLASH_BIG);     array_push(_weights, 35);
        array_push(_attacks, NZ_STATE.DASH_SLASH);    array_push(_weights, 30);
        array_push(_attacks, NZ_STATE.GROUND_SPIKES); array_push(_weights, 20);
        array_push(_attacks, NZ_STATE.AIR_ATTACK);    array_push(_weights, 15);
        if (phase == 2) {
            array_push(_attacks, NZ_STATE.DOME_TELEPORT); array_push(_weights, 25);
        }
    } else {
        // CỰ LY XA (>= 120px)
        array_push(_attacks, NZ_STATE.CHASE);         array_push(_weights, 25);
        array_push(_attacks, NZ_STATE.CRESCENT_SHOT); array_push(_weights, 30);
        array_push(_attacks, NZ_STATE.BUSTER_DRILL);  array_push(_weights, 25);
        array_push(_attacks, NZ_STATE.AIR_ATTACK);    array_push(_weights, 20);
        if (phase == 2) {
            array_push(_attacks, NZ_STATE.DOME_TELEPORT); array_push(_weights, 25);
            array_push(_attacks, NZ_STATE.SKULL_WAVE);    array_push(_weights, 20);
        }
    }
    
    // Loại trừ đòn bị lặp lại quá 2 lần liên tiếp
    if (repeat_attack_count >= 2) {
        for (var _i = array_length(_attacks) - 1; _i >= 0; _i--) {
            if (_attacks[_i] == last_attack) {
                array_delete(_attacks, _i, 1);
                array_delete(_weights, _i, 1);
            }
        }
    }
    
    // Tính tổng trọng số
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
    
    // Cập nhật bộ đếm lặp đòn
    if (_chosen == last_attack) {
        repeat_attack_count++;
    } else {
        last_attack = _chosen;
        repeat_attack_count = 1;
    }
    
    combo_count = 0;
    nz_change_state(_chosen);
};
