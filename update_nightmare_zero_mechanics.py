import os
import json

base_dir = r'd:\MZ4\MegamanZ'
obj_dir = os.path.join(base_dir, 'objects')

def create_gm_object(name, parent_name=None, sprite_name=None, mask_name=None, events=None):
    folder = os.path.join(obj_dir, name)
    os.makedirs(folder, exist_ok=True)
    
    event_list = []
    if events:
        for ev_key, code in events.items():
            ev_type, ev_num = map(int, ev_key.split('_'))
            event_list.append({
                "$GMEvent": "v1",
                "%Name": "",
                "collisionObjectId": None,
                "eventNum": ev_num,
                "eventType": ev_type,
                "isDnD": False,
                "name": "",
                "resourceType": "GMEvent",
                "resourceVersion": "2.0"
            })
            if ev_type == 0:
                fname = f"Create_{ev_num}.gml"
            elif ev_type == 1:
                fname = f"Destroy_{ev_num}.gml"
            elif ev_type == 3:
                fname = f"Step_{ev_num}.gml"
            elif ev_type == 7:
                fname = f"Other_{ev_num}.gml"
            elif ev_type == 8:
                fname = "Draw_64.gml" if ev_num == 64 else f"Draw_{ev_num}.gml"
            elif ev_type == 12:
                fname = f"CleanUp_{ev_num}.gml"
            else:
                fname = f"Event_{ev_type}_{ev_num}.gml"
                
            with open(os.path.join(folder, fname), 'w', encoding='utf-8') as f:
                f.write(code)
                
    parent_obj = None
    if parent_name:
        parent_obj = {
            "name": parent_name,
            "path": f"objects/{parent_name}/{parent_name}.yy"
        }
        
    spr_obj = None
    if sprite_name:
        spr_obj = {
            "name": sprite_name,
            "path": f"sprites/{sprite_name}/{sprite_name}.yy"
        }
        
    mask_obj = None
    if mask_name:
        mask_obj = {
            "name": mask_name,
            "path": f"sprites/{mask_name}/{mask_name}.yy"
        }
    elif sprite_name:
        mask_obj = spr_obj
        
    yy_data = {
        "$GMObject": "",
        "%Name": name,
        "eventList": event_list,
        "managed": True,
        "name": name,
        "overriddenProperties": [],
        "parent": {
            "name": "Enemies",
            "path": "folders/Objects/Enemies.yy"
        },
        "parentObjectId": parent_obj,
        "persistent": False,
        "physicsAngularDamping": 0.1,
        "physicsDensity": 0.5,
        "physicsFriction": 0.2,
        "physicsGroup": 1,
        "physicsKinematic": False,
        "physicsLinearDamping": 0.1,
        "physicsObject": False,
        "physicsRestitution": 0.1,
        "physicsSensor": False,
        "physicsShape": 1,
        "physicsShapePoints": [],
        "physicsStartAwake": True,
        "properties": [],
        "resourceType": "GMObject",
        "resourceVersion": "2.0",
        "solid": False,
        "spriteId": spr_obj,
        "spriteMaskId": mask_obj,
        "visible": True
    }
    
    with open(os.path.join(folder, f"{name}.yy"), 'w', encoding='utf-8') as f:
        json.dump(yy_data, f, indent=2)
    print(f"Updated object: {name}")

# =========================================================================
# obj_nightmare_zero (Mega Man X6 Video Mechanics)
# =========================================================================
nz_create = '''/// @desc Nightmare Zero Boss - Initialization & Config (Mega Man X6 Mechanics)
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
    CRESCENT_SHOT,  // 5: Bắn đạn trăng khuyết (Genmurei / Denharei)
    GROUND_SPIKES,  // 6: Shin Messenkou (Rekkoha) - Gai năng lượng trải khắp phòng
    BUSTER_DRILL,   // 7: Bắn Double Buster Shot tốc độ cao
    AIR_ATTACK,     // 8: Nhảy chém bổ chéo hào quang xanh, tiếp đất gây địa chấn
    DOME_TELEPORT,  // 9: Khiên năng lượng, dịch chuyển tức thời chiến thuật
    SKULL_WAVE,     // 10: (Phase 2) Sọ bóng tối chạy sàn kéo theo gai nổ
    HURT,           // 11: Bị đánh choáng (Stagger) & Nhận i-frames
    DEATH           // 12: Nổ liên hoàn, tan rã thành ooze, mở cổng boss
}

// -------------------------------------------------------------------------
// CÁC BIẾN CÓ THỂ ĐIỀU CHỈNH CÂN BẰNG (CUSTOMIZABLE VARIABLES)
// -------------------------------------------------------------------------
// 1. Chỉ số cơ bản & Máu
max_hp = 64;
hp = max_hp;
prev_hp = max_hp;
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
idle_wait_p1_min = 35;
idle_wait_p1_max = 50;
idle_wait_p2_min = 18;
idle_wait_p2_max = 30;

// 4. Sát thương từng kỹ năng
dmg_slash_big   = 5;
dmg_dash_slash  = 4;
dmg_crescent    = 4;
dmg_spike       = 4;
dmg_drill       = 4;
dmg_air_dive    = 5;
dmg_shockwave   = 3;
dmg_skull_wave  = 4;

// 5. Cảnh báo & Hiệu ứng
spike_warning_frames = 20;

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
attack_wait_timer = 45;
last_attack = -1;
repeat_attack_count = 0;

// Hệ thống combo trong Phase 2
combo_count = 0;
max_combos = 1; // Cho phép combo tối đa 2 đòn liên tiếp trong Phase 2

// Biến bổ trợ từng đòn
air_phase = 0;
teleport_phase = 0;
burst_shot_count = 0;
burst_shot_timer = 0;
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
    burst_shot_count = 0;
    burst_shot_timer = 0;
    
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
            break;
            
        case NZ_STATE.BUSTER_DRILL:
            anim_sprite = spr_nz_shoot;
            anim_delay = 6;
            hsp = 0;
            break;
            
        case NZ_STATE.AIR_ATTACK:
            anim_sprite = spr_nz_air;
            anim_delay = 5;
            air_phase = 0; // 0: Nhảy lên, 1: Bổ xuống, 2: Tiếp đất
            break;
            
        case NZ_STATE.DOME_TELEPORT:
            anim_sprite = spr_nz_dome;
            anim_delay = 5;
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
            anim_delay = 6;
            hsp = -facing * 1.5;
            vsp = 0;
            is_invulnerable = true;
            invulnerability_timer = 45; // Khung bất tử i-frames
            flash_timer = 20;
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
// HÀM CHỌN ĐÒN TẤN CÔNG THEO TRỌNG SỐ (Weighted Attack Chooser - MM X6 Style)
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
        // CỰ LY GẦN (< 110px): Ưu tiên chém, lướt quét, hoặc teleport né
        array_push(_attacks, NZ_STATE.SLASH_BIG);     array_push(_weights, 35);
        array_push(_attacks, NZ_STATE.DASH_SLASH);    array_push(_weights, 30);
        array_push(_attacks, NZ_STATE.DOME_TELEPORT); array_push(_weights, 20);
        array_push(_attacks, NZ_STATE.GROUND_SPIKES); array_push(_weights, 15);
    } else {
        // CỰ LY XA (>= 110px): Bắn kiếm khí, Double Buster, hoặc bay chém/teleport
        array_push(_attacks, NZ_STATE.CRESCENT_SHOT); array_push(_weights, 30);
        array_push(_attacks, NZ_STATE.BUSTER_DRILL);  array_push(_weights, 30);
        array_push(_attacks, NZ_STATE.DOME_TELEPORT); array_push(_weights, 25);
        array_push(_attacks, NZ_STATE.AIR_ATTACK);    array_push(_weights, 15);
        if (phase == 2) {
            array_push(_attacks, NZ_STATE.SKULL_WAVE);    array_push(_weights, 20);
            array_push(_attacks, NZ_STATE.GROUND_SPIKES); array_push(_weights, 20);
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
'''

nz_step = '''/// @desc Nightmare Zero - Step Event (Mega Man X6 Video Mechanics)
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
'''

nz_draw = '''/// @desc Nightmare Zero - Draw Event (Manual Frame, Afterimage, Aura & Hurt Flash)
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

if (phase == 2 && state != NZ_STATE.DEATH) {
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

nz_cleanup = '''/// @desc Cleanup Data Structures
afterimages = [];
'''

create_gm_object('obj_nightmare_zero', parent_name='obj_boss_parent', sprite_name='spr_nz_idle', mask_name='sEnemyMask', events={
    '0_0': nz_create,
    '3_0': nz_step,
    '8_0': nz_draw,
    '12_0': nz_cleanup
})

print("Updated obj_nightmare_zero successfully with MM X6 mechanics!")
