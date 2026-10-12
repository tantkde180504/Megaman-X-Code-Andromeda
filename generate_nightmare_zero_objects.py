import os
import json

base_dir = r'd:\MZ4\MegamanZ'
obj_dir = os.path.join(base_dir, 'objects')
yyp_path = os.path.join(base_dir, 'MegamanZ.yyp')

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
    print(f"Created object: {name}")

# =========================================================================
# 1. obj_boss_parent
# =========================================================================
boss_parent_create = '''/// @desc Boss Parent Base Initialization
event_inherited();

// Thống kê máu & Trạng thái Boss
max_hp = 64;
hp = max_hp;
hp_display = 0;       // Dùng cho hiệu ứng nạp đầy thanh máu lúc mở màn
intro_done = false;   // Đã hoàn thành intro spawn và nạp máu chưa
phase = 1;            // Phase 1 (HP > 50%), Phase 2 (HP <= 50%)
boss_name = "NIGHTMARE ZERO";

// Vật lý cơ bản
hsp = 0;
vsp = 0;
grav = 0.35;
grounded = true;
facing = -1;

// Hiệu ứng nhận đòn & Bất tử
flash_timer = 0;
invulnerability_timer = 0;
is_invulnerable = false;

// Sát thương va chạm cơ thể
contact_damage = 4;
is_dead = false;
'''

boss_parent_step = '''/// @desc Boss Parent Physics & Logic Update
// Đếm ngược hiệu ứng nhấp nháy trắng & bất tử
if (flash_timer > 0) flash_timer--;
if (invulnerability_timer > 0) invulnerability_timer--;

// Tìm kiếm mục tiêu người chơi
if (instance_exists(oPlayer)) {
    target = instance_nearest(x, y, oPlayer);
} else {
    target = noone;
}

// Kiểm tra chuyển Phase (khi máu giảm xuống <= 50%)
if (hp <= max_hp * 0.5 && phase == 1) {
    phase = 2;
}

// Xử lý vật lý trọng lực và va chạm với oSolid
vsp = min(vsp + grav, 10);

// Va chạm ngang với địa hình
if (place_meeting(x + hsp, y, oSolid)) {
    while (!place_meeting(x + sign(hsp), y, oSolid)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

// Va chạm dọc với địa hình
if (place_meeting(x, y + vsp, oSolid)) {
    while (!place_meeting(x, y + sign(vsp), oSolid)) {
        y += sign(vsp);
    }
    vsp = 0;
    grounded = true;
} else {
    grounded = false;
}
y += vsp;

// Sát thương va chạm (Contact Damage) với Người Chơi
if (!is_dead && !is_invulnerable && target != noone) {
    if (place_meeting(x, y, target)) {
        if (target.iframes <= 0 && target.state != PLAYER_STATE.HURT && target.state != PLAYER_STATE.DEATH) {
            var _kdir = (target.x >= x) ? 1 : -1;
            player_take_damage(contact_damage, _kdir);
        }
    }
}
'''

boss_parent_draw_64 = '''/// @desc Boss Health Bar HUD (Mega Man X Vertical Energy Bar)
if (is_dead) return;

var _bx = VIEW_WIDTH - 24;
var _by = 28;
var _bar_w = 8;
var _bar_h = 64;

// Hiệu ứng nạp máu lúc mở màn
if (!intro_done) {
    if (hp_display < hp) {
        hp_display += 1;
    } else {
        intro_done = true;
    }
} else {
    hp_display = hp;
}

// Viền đen và khung thanh máu bên ngoài
draw_set_color(c_black);
draw_rectangle(_bx - 2, _by - 2, _bx + _bar_w + 1, _by + _bar_h + 1, false);
draw_set_color(make_color_rgb(160, 170, 200));
draw_rectangle(_bx - 2, _by - 2, _bx + _bar_w + 1, _by + _bar_h + 1, true);

// Vẽ từng vạch năng lượng (64 vạch tương ứng max_hp)
var _ticks = max_hp;
var _tick_h = (_bar_h - 2) / max(1, _ticks);

for (var _i = 0; _i < _ticks; _i++) {
    var _ty = _by + _bar_h - 2 - ((_i + 1) * _tick_h);
    
    if (_i < hp_display) {
        if (flash_timer > 0) {
            draw_set_color(c_white); // Nháy trắng khi trúng đòn
        } else if (phase == 2) {
            // Phase 2: Thanh máu màu đỏ thẫm / tím ác mộng
            draw_set_color((_i % 2 == 0) ? make_color_rgb(255, 40, 100) : make_color_rgb(180, 20, 160));
        } else {
            // Phase 1: Màu tím Nightmare đặc trưng
            draw_set_color((_i % 2 == 0) ? make_color_rgb(170, 70, 230) : make_color_rgb(120, 40, 190));
        }
    } else {
        // Phần vạch đã mất
        draw_set_color(make_color_rgb(35, 30, 45));
    }
    
    draw_rectangle(_bx, _ty, _bx + _bar_w - 1, _ty + _tick_h - 1, false);
}

// Biểu tượng Boss trên đầu thanh máu
draw_set_color(make_color_rgb(220, 40, 70));
draw_circle(_bx + 3, _by - 8, 6, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(_bx + 3, _by - 15, "NZ");
draw_set_halign(fa_left);
'''

create_gm_object('obj_boss_parent', parent_name='oEnemyParent', sprite_name=None, mask_name=None, events={
    '0_0': boss_parent_create,
    '3_0': boss_parent_step,
    '8_64': boss_parent_draw_64
})

# =========================================================================
# 2. obj_nz_slash_hitbox
# =========================================================================
slash_hitbox_create = '''/// @desc Melee Slash Hitbox Init
damage = 4;
knockback = 2.0;
life = 4;
source_boss = noone;
hit_done = false;
'''

slash_hitbox_step = '''/// @desc Hitbox Lifetime & Collision
life--;
if (life <= 0) {
    instance_destroy();
    return;
}

if (!hit_done && instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        var _dir = 1;
        if (source_boss != noone && instance_exists(source_boss)) {
            _dir = source_boss.facing;
        } else {
            _dir = (_p.x >= x) ? 1 : -1;
        }
        player_take_damage(damage, _dir);
        instance_create_layer(_p.x, _p.y - 16, "Instances", oFX_HitSpark);
        hit_done = true;
    }
}
'''

create_gm_object('obj_nz_slash_hitbox', parent_name=None, sprite_name='sEnemyMask', mask_name='sEnemyMask', events={
    '0_0': slash_hitbox_create,
    '3_0': slash_hitbox_step
})

# =========================================================================
# 3. obj_nz_crescent
# =========================================================================
crescent_create = '''/// @desc Crescent Blade Wave Init
sprite_index = spr_nz_crescent_proj;
image_speed = 0.3;
damage = 4;
hsp = 0;
vsp = 0;
life = 180;
'''

crescent_step = '''/// @desc Crescent Movement & Collision
x += hsp;
y += vsp;
life--;

image_xscale = (hsp >= 0) ? -1 : 1;

if (life <= 0 || x < -60 || x > room_width + 60 || y < -60 || y > room_height + 60) {
    instance_destroy();
    return;
}

if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        player_take_damage(damage, (hsp >= 0) ? 1 : -1);
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
        instance_destroy();
        return;
    }
}
'''

create_gm_object('obj_nz_crescent', parent_name=None, sprite_name='spr_nz_crescent_proj', mask_name='spr_nz_crescent_proj', events={
    '0_0': crescent_create,
    '3_0': crescent_step
})

# =========================================================================
# 4. obj_nz_spike
# =========================================================================
spike_create = '''/// @desc Ground Spike Init
sprite_index = spr_nz_ground_spike;
image_speed = 0.25;
damage = 4;
hit_done = false;
'''

spike_step = '''/// @desc Spike Animation & Damage Check
// Gây sát thương khi gai nhô cao (frame 2 đến 4)
if (image_index >= 2 && image_index <= 4.5 && !hit_done) {
    if (instance_exists(oPlayer)) {
        var _p = instance_place(x, y, oPlayer);
        if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
            player_take_damage(damage, (_p.x >= x) ? 1 : -1);
            instance_create_layer(_p.x, _p.y - 12, "Instances", oFX_HitSpark);
            hit_done = true;
        }
    }
}

// Tự hủy khi diễn hoạt hết 6 frame
if (image_index >= 5.8) {
    instance_destroy();
}
'''

create_gm_object('obj_nz_spike', parent_name=None, sprite_name='spr_nz_ground_spike', mask_name='spr_nz_ground_spike', events={
    '0_0': spike_create,
    '3_0': spike_step
})

# =========================================================================
# 5. obj_nz_drill
# =========================================================================
drill_create = '''/// @desc High-Speed Buster Drill Init
sprite_index = spr_nz_drill_proj;
image_speed = 0.4;
damage = 5;
hsp = 0;
life = 120;
'''

drill_step = '''/// @desc Drill Movement & Collision
x += hsp;
life--;

image_xscale = (hsp >= 0) ? -1 : 1;

if (life <= 0 || place_meeting(x, y, oSolid)) {
    instance_create_layer(x, y, "Instances", oFX_HitSpark);
    instance_destroy();
    return;
}

if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        player_take_damage(damage, (hsp >= 0) ? 1 : -1);
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
        instance_destroy();
        return;
    }
}
'''

create_gm_object('obj_nz_drill', parent_name=None, sprite_name='spr_nz_drill_proj', mask_name='spr_nz_drill_proj', events={
    '0_0': drill_create,
    '3_0': drill_step
})

# =========================================================================
# 6. obj_nz_skull_wave
# =========================================================================
skull_wave_create = '''/// @desc Skull Wave Init
sprite_index = spr_nz_skull_wave;
image_speed = 0.25;
damage = 4;
hsp = 3.5;
life = 150;
burst_timer = 0;
'''

skull_wave_step = '''/// @desc Skull Movement & Floor Hugging
x += hsp;
life--;
burst_timer++;

image_xscale = (hsp >= 0) ? -1 : 1;

// Giữ đạn bám sát mặt đất
if (!place_meeting(x, y + 1, oSolid) && y < room_height - 16) {
    y += 2;
} else if (place_meeting(x, y, oSolid)) {
    y -= 1;
}

// Định kỳ sinh các đợt nổ bùng mặt đất phía sau
if (burst_timer >= 12) {
    burst_timer = 0;
    instance_create_layer(x - hsp * 2, y, "Instances", obj_nz_floor_burst);
}

if (life <= 0 || place_meeting(x + hsp, y, oSolid)) {
    instance_destroy();
    return;
}

if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        player_take_damage(damage, (hsp >= 0) ? 1 : -1);
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
        instance_destroy();
        return;
    }
}
'''

create_gm_object('obj_nz_skull_wave', parent_name=None, sprite_name='spr_nz_skull_wave', mask_name='spr_nz_skull_wave', events={
    '0_0': skull_wave_create,
    '3_0': skull_wave_step
})

# =========================================================================
# 7. obj_nz_ring_fx
# =========================================================================
ring_fx_create = '''/// @desc Buster Muzzle Ring FX Init
sprite_index = spr_nz_ring_fx;
image_speed = 0.35;
'''

ring_fx_step = '''/// @desc Ring Animation End
if (image_index >= 2.8) {
    instance_destroy();
}
'''

create_gm_object('obj_nz_ring_fx', parent_name=None, sprite_name='spr_nz_ring_fx', mask_name='spr_nz_ring_fx', events={
    '0_0': ring_fx_create,
    '3_0': ring_fx_step
})

# =========================================================================
# 8. obj_nz_floor_burst
# =========================================================================
floor_burst_create = '''/// @desc Floor Burst Shockwave Init
sprite_index = spr_nz_floor_burst;
image_speed = 0.35;
damage = 3;
hit_done = false;
'''

floor_burst_step = '''/// @desc Shockwave Burst Collision & Lifetime
if (image_index >= 1 && image_index <= 3.5 && !hit_done) {
    if (instance_exists(oPlayer)) {
        var _p = instance_place(x, y, oPlayer);
        if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
            player_take_damage(damage, (_p.x >= x) ? 1 : -1);
            instance_create_layer(_p.x, _p.y - 10, "Instances", oFX_HitSpark);
            hit_done = true;
        }
    }
}

if (image_index >= 4.8) {
    instance_destroy();
}
'''

create_gm_object('obj_nz_floor_burst', parent_name=None, sprite_name='spr_nz_floor_burst', mask_name='spr_nz_floor_burst', events={
    '0_0': floor_burst_create,
    '3_0': floor_burst_step
})

# =========================================================================
# 9. obj_nightmare_zero
# =========================================================================
nz_create = '''/// @desc Nightmare Zero Boss - Initialization & Config
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
'''

nz_step = '''/// @desc Nightmare Zero - Step Event (Full State Machine)
// -------------------------------------------------------------------------
// 1. Kiểm tra Tử Trận (Death Trigger)
// -------------------------------------------------------------------------
if (hp <= 0 && state != NZ_STATE.DEATH) {
    nz_change_state(NZ_STATE.DEATH);
}

// Gọi Step cơ sở của obj_boss_parent (Trừ khi đang ở AIR_ATTACK hay DOME_TELEPORT tự điều khiển physics)
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
// 4. State Machine (13 Trạng thái)
// -------------------------------------------------------------------------
switch (state) {

    // =====================================================================
    // 0. SPAWN: Ooze phồng lên rồi hóa thành người
    // =====================================================================
    case NZ_STATE.SPAWN:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        // Đợi animation hoàn thành VÀ thanh máu nạp đầy đủ
        if (anim_done && intro_done) {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 1. IDLE: Đứng chờ, tóc bay, hướng về người chơi
    // =====================================================================
    case NZ_STATE.IDLE:
        hsp = 0;
        // Lặp lại 4 frame tóc bay
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
            
            // Nếu đã áp sát mục tiêu (< 80px) hoặc chạy quá 60 frame -> tấn công cận chiến
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
            // Lùi nhẹ chuẩn bị chém
            hsp = -facing * 1.0;
        } else {
            hsp = 0;
        }
        
        // Frame 2: Tung đòn chém
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(5, 10);
            
            // Hitbox chém cận chiến vòng cung phía trước
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
            // Kiểm tra nối combo Phase 2
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
            // Trượt dừng
            hsp *= 0.55;
        }
        
        if (anim_done) {
            // Phase 2 combo nối sang SLASH_BIG
            if (phase == 2 && combo_count < max_combos) {
                combo_count++;
                nz_change_state(NZ_STATE.SLASH_BIG);
            } else {
                nz_change_state(NZ_STATE.IDLE);
            }
        }
        break;

    // =====================================================================
    // 5. CRESCENT_SHOT: Bắn 1-3 đạn trăng khuyết ngang hoặc chếch
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
            
            // Đạn 3 (Phase 2): Chếch xuống
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
    // 6. GROUND_SPIKES: Gồng cắm kiếm xuống đất, gai trồi lên tuần tự
    // =====================================================================
    case NZ_STATE.GROUND_SPIKES:
        hsp = 0;
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(4, 12);
        }
        
        // Gai trồi lên sau thời gian cảnh báo
        if (action_triggered) {
            spike_timer++;
            if (spike_timer >= 6 && spike_counter < 6) {
                spike_timer = 0;
                var _sx = x + facing * (30 + spike_counter * 28);
                var _sy = y;
                
                // Căn chỉnh tọa độ sát mặt nền
                while (!place_meeting(_sx, _sy + 1, oSolid) && _sy < room_height - 16) _sy++;
                while (place_meeting(_sx, _sy, oSolid) && _sy > 16) _sy--;
                
                var _sp = instance_create_layer(_sx, _sy, "Instances", obj_nz_spike);
                _sp.damage = dmg_spike;
                spike_counter++;
            }
        }
        
        if (anim_done && spike_counter >= 6) {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 7. BUSTER_DRILL: Vòng năng lượng hiện ra, bắn mũi khoan siêu tốc
    // =====================================================================
    case NZ_STATE.BUSTER_DRILL:
        if (anim_frame == 1 && !action_triggered) {
            instance_create_layer(x + facing * 22, y - 28, "Instances", obj_nz_ring_fx);
        }
        
        if (anim_frame == 2 && !action_triggered) {
            action_triggered = true;
            camera_shake(3, 8);
            
            var _drill = instance_create_layer(x + facing * 26, y - 28, "Instances", obj_nz_drill);
            _drill.hsp = facing * 6.5;
            _drill.damage = dmg_drill;
            
            // Giật lùi nhẹ do phản lực buster
            hsp = -facing * 1.5;
        }
        
        if (anim_done) {
            nz_change_state(NZ_STATE.IDLE);
        }
        break;

    // =====================================================================
    // 8. AIR_ATTACK: Nhảy lên, lao chém chéo viền xanh, hạ cánh nổ địa chấn
    // =====================================================================
    case NZ_STATE.AIR_ATTACK:
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
            if (vsp >= -0.5) {
                air_phase = 1; // Chuyển sang bổ chém xuống
            }
        } else if (air_phase == 1) {
            // Giai đoạn B: Bổ chém xuống theo đường chéo
            vsp = air_dive_vsp;
            hsp = facing * air_dive_hsp;
            anim_frame = clamp(anim_frame, 4, 8);
            
            // Va chạm địa hình khi bổ xuống
            if (place_meeting(x + hsp, y, oSolid)) {
                while (!place_meeting(x + sign(hsp), y, oSolid)) x += sign(hsp);
                hsp = 0;
            }
            x += hsp;
            
            if (place_meeting(x, y + vsp, oSolid)) {
                while (!place_meeting(x, y + sign(vsp), oSolid)) y += sign(vsp);
                vsp = 0;
                grounded = true;
                air_phase = 2; // Tiếp đất
                camera_shake(6, 14);
                
                // Sinh sóng xung kích nổ mặt sàn hai bên
                var _b1 = instance_create_layer(x - 24, y, "Instances", obj_nz_floor_burst);
                _b1.damage = dmg_shockwave;
                var _b2 = instance_create_layer(x + 24, y, "Instances", obj_nz_floor_burst);
                _b2.damage = dmg_shockwave;
                
                anim_frame = 9;
                state_timer = 0;
            } else {
                y += vsp;
            }
            
            // Gây sát thương nếu va phải người chơi lúc bổ xuống
            if (instance_exists(target) && place_meeting(x, y, target)) {
                if (target.iframes <= 0 && target.state != PLAYER_STATE.HURT && target.state != PLAYER_STATE.DEATH) {
                    player_take_damage(dmg_air_dive, facing);
                }
            }
        } else if (air_phase == 2) {
            // Giai đoạn C: Hạ cánh khựng phục hồi
            hsp = 0;
            vsp = 0;
            if (state_timer >= 15) {
                nz_change_state(NZ_STATE.IDLE);
            }
        }
        break;

    // =====================================================================
    // 9. DOME_TELEPORT: Tạo khiên bất tử, dịch chuyển sau lưng người chơi
    // =====================================================================
    case NZ_STATE.DOME_TELEPORT:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        
        if (teleport_phase == 0) {
            // Khiên mở rộng
            if (anim_done) {
                teleport_phase = 1;
                state_timer = 0;
                image_alpha = 0; // Biến mất
            }
        } else if (teleport_phase == 1) {
            // Ẩn thân và di chuyển tức thời ra sau lưng người chơi
            if (state_timer >= 15) {
                if (instance_exists(target)) {
                    var _dest_x = target.x - target.facing * 52;
                    _dest_x = clamp(_dest_x, 64, room_width - 64);
                    x = _dest_x;
                    y = target.y;
                    
                    // Căn chỉnh mặt sàn
                    while (!place_meeting(x, y + 1, oSolid) && y < room_height - 16) y++;
                    while (place_meeting(x, y, oSolid) && y > 16) y--;
                    
                    facing = (target.x >= x) ? 1 : -1;
                }
                image_alpha = 1; // Xuất hiện trở lại
                anim_frame = 0;
                anim_done = false;
                teleport_phase = 2;
            }
        } else if (teleport_phase == 2) {
            // Khiên thu nhỏ kết thúc
            if (anim_done) {
                is_invulnerable = false;
                // Tấn công ngay lập tức sau khi dịch chuyển!
                nz_change_state((random(100) < 60) ? NZ_STATE.SLASH_BIG : NZ_STATE.DASH_SLASH);
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
    // 11. HURT: Nháy người, khựng phục hồi
    // =====================================================================
    case NZ_STATE.HURT:
        hsp *= 0.8;
        if (anim_done) {
            nz_change_state(NZ_STATE.IDLE);
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
        
        // Vụ nổ nhỏ liên hoàn khắp thân thể
        if (death_timer % 6 == 0 && death_timer < 70) {
            var _ex = x + irandom_range(-24, 24);
            var _ey = y - irandom_range(8, 50);
            instance_create_layer(_ex, _ey, "Instances", oFX_EnemyExplosion);
            camera_shake(3, 6);
        }
        
        // Chuyển sang sprite vũng bùn ooze tan biến
        if (death_timer == 45) {
            anim_sprite = spr_nz_death_ooze;
            anim_frame = 0;
            anim_delay = 12;
            anim_done = false;
        }
        
        // Hoàn tất tử trận
        if (death_timer >= 95) {
            instance_create_layer(x, y - 24, "Instances", oFX_EnemyExplosion);
            camera_shake(6, 16);
            
            // Mở tất cả các cổng boss trong phòng
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

// 3. Hiệu ứng nháy trắng khi nhận sát thương
if (flash_timer > 0) {
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

print("All 9 objects created successfully!")
