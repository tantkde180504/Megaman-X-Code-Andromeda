/// @desc Hệ Thống Hiệu Ứng Hạ Gục Mega Man X4 (Player Death / Defeat VFX)
/// Chuẩn kỹ thuật PS1 (Mega Man X4/X5/X6) & tùy chọn cổ điển SNES (Mega Man X1)

// =========================================================================
// 1. STRUCT / CONSTRUCTOR: DeathRing
// =========================================================================
function DeathRing(_wave, _idx, _ox, _oy, _death_style = "MMX4_PS1", _char_type = "X", _custom_angle = undefined) constructor {
    wave = _wave;
    index = _idx;
    origin_x = _ox;
    origin_y = _oy;
    death_style = _death_style;
    char_type = _char_type;
    
    angle = is_undefined(_custom_angle) ? (_idx * 45.0) : _custom_angle;
    radius = 0.0;
    y_arc_offset = 0.0;
    ring_timer = 0;
    alpha = 1.0;
    current_x = _ox;
    current_y = _oy;
    is_active = true;
    
    // Wave parameters
    if (_death_style == "MMX4_PS1") {
        if (_wave == 0) {
            spd_radial = 3.2;  // Đợt 1: Bán kính nở nhanh nhất
            arc_vsp = -3.8;    // Vận tốc vọt lên ban đầu
            base_size = 12.0;
        } else if (_wave == 1) {
            spd_radial = 2.4;  // Đợt 2: Vừa
            arc_vsp = -2.8;
            base_size = 11.0;
        } else {
            spd_radial = 1.6;  // Đợt 3: Nhỏ & chậm
            arc_vsp = -1.8;
            base_size = 10.0;
        }
        grav = 0.16;          // Trọng lực rơi vòm Parabol
        angular_spd = 2.5;    // Xoay nhẹ 2.5 độ/frame tạo bông hoa 8 cánh xoắn
    } else {
        // MMX1_SNES: Bay thẳng đều theo 8 hướng không chịu trọng lực
        spd_radial = (_wave == 0) ? 4.5 : 2.0;
        arc_vsp = 0.0;
        grav = 0.0;
        angular_spd = 0.0;
        base_size = (_wave == 0) ? 8.0 : 5.5;
    }
    
    ring_size = base_size;
    
    static update = function() {
        ring_timer++;
        
        if (death_style == "MMX4_PS1") {
            // 1. Chuyển động xoắn bông hoa đồng tâm (Frame 0 -> 15 của mỗi Ring)
            radius += spd_radial;
            angle += angular_spd;
            
            // 2. Chuyển động bung vòm Parabol rơi theo trọng lực (Từ Frame 12 trở đi)
            if (ring_timer >= 12) {
                y_arc_offset += arc_vsp;
                arc_vsp += grav;
            }
            
            // Vị trí thực tế theo công thức chuẩn Mega Man X4:
            current_x = origin_x + lengthdir_x(radius, angle);
            current_y = origin_y + lengthdir_y(radius * 0.65, angle) + y_arc_offset;
            
            // 3. Hiệu ứng co giãn & nhấp nháy xung điện của vòng tròn
            ring_size = max(2.0, base_size + sin(ring_timer * 0.4) * 2.0);
            
            // Fade-out mượt khi gần chạm mép màn hình
            if (ring_timer > 48) {
                alpha = max(0.0, alpha - 0.035);
                if (alpha <= 0.0) is_active = false;
            }
        } else {
            // MMX1_SNES: Quỹ đạo bay thẳng không trọng lực
            radius += spd_radial;
            current_x = origin_x + lengthdir_x(radius, angle);
            current_y = origin_y + lengthdir_y(radius, angle);
            
            if (ring_timer > 40) {
                alpha = max(0.0, alpha - 0.04);
                if (alpha <= 0.0) is_active = false;
            }
        }
    };
}

// =========================================================================
// 2. PROCEDURAL DRAW FUNCTIONS (VẼ VÒNG TRÒN NĂNG LƯỢNG RỖNG PHÁT SÁNG)
// =========================================================================

/// @desc Vẽ vòng tròn năng lượng rỗng ruột phát sáng theo phong cách PS1 Mega Man X4
/// @param {Real} _x Tọa độ X tâm vòng tròn
/// @param {Real} _y Tọa độ Y tâm vòng tròn
/// @param {Real} _radius Bán kính vòng tròn
/// @param {Real} _thickness Độ dày vành phát sáng
/// @param {Color} _core_col Màu lõi sáng nhất (thường là c_white)
/// @param {Color} _glow_col Màu viền hào quang (cyan #00E5FF cho X, vàng cam #FFC300 cho Zero)
/// @param {Real} _alpha Độ trong suốt (0.0 -> 1.0)
function draw_mmx4_energy_ring(_x, _y, _radius, _thickness, _core_col, _glow_col, _alpha) {
    if (_alpha <= 0.0 || _radius <= 1.0) return;
    
    var _old_blend = gpu_get_blendmode();
    gpu_set_blendmode(bm_add);
    draw_set_circle_precision(48);
    
    var _half_t = _thickness * 0.5;
    
    // Lớp 1: Hào quang ngoài cùng dịu nhẹ (Outer soft glow)
    draw_set_color(_glow_col);
    draw_set_alpha(_alpha * 0.25);
    draw_circle(_x, _y, _radius + _half_t + 2.0, true);
    draw_circle(_x, _y, max(0.5, _radius - _half_t - 2.0), true);
    
    // Lớp 2: Vành phát sáng chính (Mid glowing ring)
    draw_set_alpha(_alpha * 0.65);
    draw_circle(_x, _y, _radius + _half_t, true);
    draw_circle(_x, _y, max(0.5, _radius - _half_t), true);
    draw_circle(_x, _y, _radius + _half_t * 0.5, true);
    draw_circle(_x, _y, max(0.5, _radius - _half_t * 0.5), true);
    
    // Lớp 3: Vành lõi cường độ cao sáng rực (Core intense ring)
    draw_set_color(_core_col);
    draw_set_alpha(_alpha * 0.95);
    draw_circle(_x, _y, _radius, true);
    draw_circle(_x, _y, _radius + 0.6, true);
    draw_circle(_x, _y, max(0.5, _radius - 0.6), true);
    
    // Trả lại trạng thái vẽ mặc định
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    gpu_set_blendmode(_old_blend);
}

/// @desc Vẽ quả cầu năng lượng lõi phình to ở tâm (Core Plasma Sphere) tại Frame 25..32
function draw_mmx4_core_plasma(_x, _y, _scale, _col_core, _col_glow, _col_outer, _alpha) {
    if (_alpha <= 0.0 || _scale <= 0.0) return;
    
    var _old_blend = gpu_get_blendmode();
    gpu_set_blendmode(bm_add);
    draw_set_circle_precision(48);
    
    var _r = 20.0 * _scale;
    
    // Vầng hào quang ngoài (Outer halo)
    draw_set_color(_col_outer);
    draw_set_alpha(_alpha * 0.35);
    draw_circle(_x, _y, _r * 1.5, false);
    
    // Quả cầu năng lượng giữa (Mid plasma)
    draw_set_color(_col_glow);
    draw_set_alpha(_alpha * 0.7);
    draw_circle(_x, _y, _r, false);
    
    // Lõi rực sáng ở tâm (Core white blast)
    draw_set_color(_col_core);
    draw_set_alpha(_alpha * 1.0);
    draw_circle(_x, _y, _r * 0.45, false);
    
    // Các tia sáng chớp chữ thập / ngôi sao lóe sáng (Cross flare streaks)
    var _ray_len = _r * 2.2;
    var _ray_thick = max(1.5, 3.0 * _scale);
    draw_set_color(_col_core);
    draw_set_alpha(_alpha * 0.85);
    draw_line_width(_x - _ray_len, _y, _x + _ray_len, _y, _ray_thick);
    draw_line_width(_x, _y - _ray_len, _x, _y + _ray_len, _ray_thick);
    
    var _dray = _ray_len * 0.65;
    draw_line_width(_x - _dray, _y - _dray, _x + _dray, _y + _dray, _ray_thick * 0.7);
    draw_line_width(_x - _dray, _y + _dray, _x + _dray, _y - _dray, _ray_thick * 0.7);
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    gpu_set_blendmode(_old_blend);
}

// =========================================================================
// 3. HÀM KÍCH HOẠT HẠ GỤC: player_trigger_death
// =========================================================================
/// @desc Kích hoạt toàn bộ chuỗi hiệu ứng nhân vật bị hạ gục chuẩn Mega Man X4
/// @param {Id.Instance} _player_id Instance của người chơi (mặc định instance_find(oPlayer, 0))
/// @param {String} _character_type "X" hoặc "ZERO" (tự động nhận diện nếu không truyền)
/// @param {String} _death_style "MMX4_PS1" (mặc định) hoặc "MMX1_SNES"
function player_trigger_death(_player_id = noone, _character_type = undefined, _death_style = "MMX4_PS1") {
    if (_player_id == noone || !instance_exists(_player_id)) {
        if (instance_exists(oPlayer)) {
            _player_id = instance_find(oPlayer, 0);
        } else {
            return noone;
        }
    }
    
    // Ngăn chặn tạo trùng lặp nếu đang trong hiệu ứng hạ gục
    if (instance_exists(obj_x_death_effect)) {
        return instance_find(obj_x_death_effect, 0);
    }
    
    // Tự động nhận diện nhân vật (X hoặc Zero)
    if (is_undefined(_character_type)) {
        if (_player_id.object_index == oPlayerZero || (variable_global_exists("current_char") && global.current_char == CHAR_TYPE.ZERO)) {
            _character_type = "ZERO";
        } else {
            _character_type = "X";
        }
    }
    
    // Khóa trạng thái, vận tốc và hình ảnh của nhân vật
    _player_id.state = PLAYER_STATE.DEATH;
    _player_id.hsp = 0;
    _player_id.vsp = 0;
    _player_id.image_speed = 0;
    _player_id.death_timer = 170;
    _player_id.death_phase = 0;
    
    // Tọa độ spawn
    var _spawn_x = _player_id.x;
    var _spawn_y = _player_id.y;
    
    // Tạo đối tượng quản lý hiệu ứng trên layer Effects hoặc Instances
    var _layer_name = layer_exists("Effects") ? "Effects" : (layer_exists("Instances") ? "Instances" : layer_get_name(layer_get_all()[0]));
    var _fx = instance_create_layer(_spawn_x, _spawn_y, _layer_name, obj_x_death_effect);
    with (_fx) {
        player_id = _player_id;
        character_type = _character_type;
        death_style = _death_style;
    }
    
    return _fx;
}
