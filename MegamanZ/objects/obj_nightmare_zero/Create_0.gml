/// @desc Zero Nightmare (Nightmare Zero) - Complete State Machine & Configuration
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
    SKULL_WAVE,         // 13: Skull Wave - Sóng kiếm đầu lâu bay bám sàn
    RECOVERY,           // 14: Trạng thái hồi phục sau đòn đánh (Cơ hội cho người chơi)
    HURT,               // 15: Bị đánh choáng (Stagger) & Khung bất tử i-frames
    DEFEAT              // 16: Nổ liên hoàn, tan rã ooze, mở cổng boss
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
warning_timer = 90;

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
            
        case NZ_STATE.SKULL_WAVE:
            anim_sprite = spr_nz_slash_big;
            anim_delay = 5;
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
        
        // Phase 2 hoặc khi máu dưới 50%: kích hoạt tuyệt kỹ Genmu Zero Kai, Messenkou & Skull Wave
        if (phase == 2) {
            array_push(_attacks, NZ_STATE.GENMU_ZERO_KAI); array_push(_weights, 20);
            array_push(_attacks, NZ_STATE.SHIN_MESSENKOU);  array_push(_weights, 15);
            array_push(_attacks, NZ_STATE.SKULL_WAVE);      array_push(_weights, 20);
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
