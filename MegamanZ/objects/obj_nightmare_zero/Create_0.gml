/// @desc Zero Nightmare (Nightmare Zero) - Complete State Machine & Configuration
event_inherited();

// -------------------------------------------------------------------------
// 1. FINITE STATE MACHINE ENUM (18 Trạng Thái Hoàn Chỉnh Theo Đặc Tả)
// -------------------------------------------------------------------------
enum NZ_STATE {
    INTRO,              // 0: Khởi đầu - WARNING + Ooze phồng lên hóa người (Hàng 1 + Hàng 2)
    IDLE,               // 1: Đứng chờ, tóc bay
    APPROACH,           // 2: Chạy bộ áp sát
    RETREAT,            // 3: Lùi bước
    JUMP,               // 4: Nhảy cao & Bổ chém hào quang xanh (Air Dive Slash)
    DASH,               // 5: Lướt thấp chém quét (Hàng 16)
    TELEPORT_OUT,       // 6: Kích hoạt khiên năng lượng, biến mất
    TELEPORT_IN,        // 7: Tái xuất hiện
    BUSTER_ATTACK,      // 8: Z-Buster (Hàng 10) bắn đạn Drill (Hàng 12) + Muzzle Ring
    SABER_ATTACK,       // 9: Z-Saber Slash (Hàng 4 + Hàng 5)
    SABER_WAVE,         // 10: Saber Wave - Phóng kiếm khí nhỏ (Hàng 7)
    GENMU_ZERO_KAI,     // 11: Đại kiếm chém (Hàng 8) phóng đại kiếm khí (Hàng 9 Frame 6)
    SHIN_MESSENKOU,     // 12: Đập đất (Hàng 13), cảnh báo sàn (Hàng 15) rồi bắn cột sáng (Hàng 14)
    SKULL_WAVE,         // 13: Sóng đầu lâu bám sàn
    FLOAT_PHASE2,       // 14: Bay lơ lửng (Hàng 19) + Nền hào quang (Hàng 20) lúc 50% HP
    RECOVERY,           // 15: Khoảng nghỉ hồi phục
    HURT,               // 16: Bị đánh choáng (Hàng 21) & i-frames
    DEFEAT              // 17: Nhấp nháy nổ (Hàng 20 Frame 2 -> Frame 3) rồi tan rã ooze
}

// -------------------------------------------------------------------------
// 2. CẤU HÌNH ĐỘ KHÓ (DIFFICULTY PRESETS: 0 = Easy, 1 = Normal, 2 = Hard)
// -------------------------------------------------------------------------
difficulty = 1; // Mặc định: Normal

// -------------------------------------------------------------------------
// 3. THÔNG SỐ CÂN BẰNG TÙY BIẾN (CONFIGURABLE VARIABLES)
// -------------------------------------------------------------------------
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
dmg_genmu_kai     = (difficulty == 0) ? 5 : 6;
dmg_buster        = (difficulty == 0) ? 3 : 4;
dmg_messenkou     = (difficulty == 0) ? 3 : 5;
dmg_air_dive      = (difficulty == 0) ? 4 : 5;
dmg_floor_burst   = (difficulty == 0) ? 2 : 3;

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
float_timer = 0;
phase2_triggered = false;
next_state_after_teleport = -1;

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
            anim_delay = 6;
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
            air_phase = 0;
            break;
            
        case NZ_STATE.DASH:
            anim_sprite = spr_nz_dash_slash; // Hàng 16
            anim_delay = 5;
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
            anim_sprite = spr_nz_shoot; // Hàng 10
            anim_delay = 6;
            hsp = 0;
            break;
            
        case NZ_STATE.SABER_ATTACK:
            anim_sprite = spr_nz_slash_big; // Hàng 4 + Hàng 5 (11 frames)
            anim_delay = 5;
            hsp = 0;
            break;
            
        case NZ_STATE.SABER_WAVE:
            anim_sprite = spr_nz_slash_big; // Hàng 4 + Hàng 5
            anim_delay = 5;
            hsp = 0;
            break;
            
        case NZ_STATE.GENMU_ZERO_KAI:
            anim_sprite = spr_nz_giant_sword; // Hàng 8 (height 192)
            anim_delay = 6;
            hsp = 0;
            break;
            
        case NZ_STATE.SHIN_MESSENKOU:
            anim_sprite = spr_nz_ground_charge; // Hàng 13 (11 frames)
            anim_delay = 6;
            hsp = 0;
            break;
            
        case NZ_STATE.SKULL_WAVE:
            anim_sprite = spr_nz_slash_big;
            anim_delay = 5;
            hsp = 0;
            break;
            
        case NZ_STATE.FLOAT_PHASE2:
            anim_sprite = spr_nz_float; // Hàng 19 (4 frames)
            anim_delay = 6;
            hsp = 0;
            vsp = 0;
            is_invulnerable = true;
            float_timer = 0;
            break;
            
        case NZ_STATE.RECOVERY:
            anim_sprite = spr_nz_idle;
            anim_delay = 8;
            hsp = 0;
            
            // Random phóng vòng tròn năng lượng (Hàng 11) sau khi dùng các chiêu cơ bản
            if (random(100) < 38) {
                var _rf = instance_create_layer(x + facing * 24, y - 26, "Instances", obj_nz_ring_fx);
                _rf.hsp = facing * 4.8;
                _rf.damage = 3;
            }
            break;
            
        case NZ_STATE.HURT:
            anim_sprite = spr_nz_hurt; // Hàng 21
            anim_delay = 6;
            hsp = -facing * 1.5;
            vsp = 0;
            is_invulnerable = true;
            invulnerability_timer = 45;
            flash_timer = 20;
            break;
            
        case NZ_STATE.DEFEAT:
            anim_sprite = spr_nz_defeat_burst; // Hàng 20 Frame 2 -> Frame 3
            anim_delay = 4;
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
            array_push(_attacks, NZ_STATE.GENMU_ZERO_KAI); array_push(_weights, 25);
            array_push(_attacks, NZ_STATE.SHIN_MESSENKOU);  array_push(_weights, 20);
            array_push(_attacks, NZ_STATE.SKULL_WAVE);      array_push(_weights, 15);
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
