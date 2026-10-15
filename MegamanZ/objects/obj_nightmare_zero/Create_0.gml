/// @desc Zero Nightmare (Nightmare Zero) - Exact User Sequence State Machine
event_inherited();

// -------------------------------------------------------------------------
// 1. FINITE STATE MACHINE ENUM (Theo Đúng Đặc Tả Tuần Tự Của Người Dùng)
// -------------------------------------------------------------------------
enum NZ_STATE {
    SLEEP,              // -1: Chờ người chơi tới gần phòng đấu trùm trong map lớn
    INTRO,              // 0: Màn hình WARNING & Spawn Ooze -> Zero (hàng 1, 2: 15 frames)
    IDLE,               // 1: Đứng chờ giữa các cử động / nhịp nghỉ
    
    // CỬ ĐỘNG 1:
    ACT1_DASH,          // 2: Lướt tới gần nhân vật (hàng 19 7 frames)
    ACT1_SLASH,         // 3: Chém thường (hàng 4, 5: 11 frames)
    ACT1_SHOOT,         // 4: Bắn (hàng 10: 5 frames, đạn hàng 12: 2 phát thẳng hoặc 10 phát quạt)
    ACT1_WAVE,          // 5: Chém sóng kiếm nhỏ (hàng 7: 4 frames) bay theo hướng nhân vật
    
    // CỬ ĐỘNG 2:
    ACT2_TELEPORT,      // 6: Teleport (tái sử dụng animation lướt 7 frames)
    ACT2_SLASH,         // 7: Chém thường 2 lần theo hướng nhân vật (hàng 4, 5: 11 frames)
    
    // CỬ ĐỘNG 3:
    ACT3_MESSENKOU,     // 8: Shin Messenkou lúc 20% máu (hàng 13, 14: 16 frames dậm tay + hàng 18 đất 5 frames + hàng 17 tia 4 frames)
    
    // HỆ THỐNG:
    HURT,               // 9: Choáng đòn khi trúng Charged Buster (hàng cuối frame 1) & i-frames
    DEFEAT              // 10: Tiêu diệt (hàng cuối 2 frame cuối: frame 2 đang nổ -> frame cuối nằm gục)
}

// -------------------------------------------------------------------------
// 2. CHỈ SỐ MÁU & CƠ BẢN
// -------------------------------------------------------------------------
max_hp = 64;
hp = max_hp;
prev_hp = max_hp;
contact_damage = 4;
mask_index = spr_nz_mask_stand;

// -------------------------------------------------------------------------
// 3. ĐIỀU KHIỂN ANIMATION THỦ CÔNG (image_speed = 0)
// -------------------------------------------------------------------------
image_speed = 0;
anim_sprite = spr_nz_spawn;
anim_frame = 0;
anim_timer = 0;
anim_delay = 6;
anim_done = false;
action_triggered = false;

// -------------------------------------------------------------------------
// 4. BIẾN ĐIỀU KHIỂN CHU KỲ TUẦN TỰ & ARENA BOUNDARIES
// -------------------------------------------------------------------------
if (room_get_name(room) == "rStage_WebSpider") {
    if (x >= 4800) {
        arena_left = 4912;
        arena_right = 5424;
        arena_center = (arena_left + arena_right) * 0.5;
        
        // Nếu người chơi chưa tới gần phòng trùm, boss chờ (SLEEP)
        if (instance_exists(oPlayer) && instance_find(oPlayer, 0).x < 4850) {
            state = NZ_STATE.SLEEP;
            visible = false;
        } else {
            state = NZ_STATE.INTRO;
            visible = true;
        }
    } else {
        // Boss đặt tại khu vực khác để thử nghiệm trực tiếp
        arena_left = max(32, x - 250);
        arena_right = min(room_width - 32, x + 250);
        arena_center = (arena_left + arena_right) * 0.5;
        state = NZ_STATE.INTRO;
        visible = true;
    }
} else {
    arena_left = 32;
    arena_right = room_width - 32;
    arena_center = room_width * 0.5;
    state = NZ_STATE.INTRO;
    visible = true;
}
if (state == NZ_STATE.INTRO) {
    music_play_boss_nightmare_zero();
}
state_timer = 0;
warning_timer = 90;

// Cử động 1 counters:
act1_loop_count = 0;            // Đếm số lần lặp Cử động 1 (cần lặp 2 lần: 0 và 1)
act1_shoot_wave_step = 0;       // Đếm số lần lặp combo "bắn rồi chém" (cần lặp 2 lần: 0 và 1)

// Bắn đạn:
shoot_burst_count = 0;
shoot_burst_timer = 0;
shoot_max_burst = 2;            // >50% HP: 2 phát thẳng; <=50% HP: 10 phát quạt

// Cử động 2 counters:
act2_teleport_count = 0;        // Teleport 2 lần tới gần nhân vật (1, 2) và 1 lần sau khi chém (3)
act2_slash_count = 0;           // Chém thường 2 lần theo hướng nhân vật (1, 2)
teleport_phase = 0;             // 0: mờ ảo biến mất, 1: tàng hình chọn vị trí, 2: tái xuất hiện
teleport_dest_x = x;
teleport_dest_y = y;

// Cử động 3 (Shin Messenkou lúc 20% máu):
messenkou_done = false;

// Tử trận:
death_timer = 0;

// Mảng tàn ảnh
afterimages = [];

// -------------------------------------------------------------------------
// 5. HÀM CHUYỂN TRẠNG THÁI
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
        case NZ_STATE.INTRO:
            anim_sprite = spr_nz_spawn; // Hàng 1, 2 (15 frames)
            anim_delay = 6;
            is_invulnerable = true;
            music_play_boss_nightmare_zero();
            break;
            
        case NZ_STATE.IDLE:
            anim_sprite = spr_nz_idle;
            anim_delay = 8;
            hsp = 0;
            break;
            
        case NZ_STATE.ACT1_DASH:
            anim_sprite = spr_nz_dash_slash; // Hàng 19 7 frames đầy đủ
            anim_delay = 4;
            hsp = 0;
            break;
            
        case NZ_STATE.ACT1_SLASH:
            anim_sprite = spr_nz_slash_big; // Hàng 4, 5 (11 frames đầy đủ)
            anim_delay = 4;
            hsp = 0;
            break;
            
        case NZ_STATE.ACT1_SHOOT:
            anim_sprite = spr_nz_shoot; // Hàng 10 (5 frames đầy đủ)
            anim_delay = 6;
            hsp = 0;
            shoot_burst_count = 0;
            shoot_burst_timer = 0;
            break;
            
        case NZ_STATE.ACT1_WAVE:
            anim_sprite = spr_nz_slash_big; // Hàng 4, 5 (11 frames) phóng sóng kiếm hàng 7 (4 frames)
            anim_delay = 4;
            hsp = 0;
            break;
            
        case NZ_STATE.ACT2_TELEPORT:
            anim_sprite = spr_nz_dash_slash; // Tái sử dụng animation lướt 7 frames
            anim_delay = 3;
            hsp = 0;
            vsp = 0;
            teleport_phase = 0;
            is_invulnerable = true;
            break;
            
        case NZ_STATE.ACT2_SLASH:
            anim_sprite = spr_nz_slash_big; // Hàng 4, 5 (11 frames đầy đủ)
            anim_delay = 4;
            hsp = 0;
            break;
            
        case NZ_STATE.ACT3_MESSENKOU:
            anim_sprite = spr_nz_ground_charge; // Hàng 13, 14 (16 frames đầy đủ)
            anim_delay = 5;
            hsp = 0;
            is_invulnerable = true;
            break;
            
        case NZ_STATE.HURT:
            anim_sprite = spr_nz_hurt; // Hàng cuối frame 1
            anim_delay = 6;
            hsp = -facing * 1.2;
            vsp = 0;
            is_invulnerable = true;
            invulnerability_timer = 40;
            flash_timer = 20;
            break;
            
        case NZ_STATE.DEFEAT:
            anim_sprite = spr_nz_defeat_burst; // Hàng cuối 2 frame cuối (frame 2 đang nổ -> frame cuối nằm gục)
            anim_frame = 0;
            anim_delay = 6;
            hsp = 0;
            vsp = 0;
            is_invulnerable = true;
            death_timer = 0;
            break;
    }
};
