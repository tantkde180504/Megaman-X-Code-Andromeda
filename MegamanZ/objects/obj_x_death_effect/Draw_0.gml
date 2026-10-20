/// @desc Vẽ hiệu ứng hạ gục (Draw Event)

// =========================================================================
// 1. GIAI ĐOẠN 1: HIT-FREEZE (Frame 0 -> 24)
// =========================================================================
if (timer <= 24) {
    if (instance_exists(player_id)) {
        var _spr = (character_type == "ZERO") ? sZero_Hurt : sX_Hurt;
        var _frame = (character_type == "ZERO") ? 2 : 0;
        var _px = player_id.x;
        var _py = player_id.y;
        var _pface = player_id.facing;
        
        // Vẽ tư thế trúng đòn bị khựng lại
        if (sprite_exists(_spr)) {
            // Nhấp nháy màu xanh/trắng (hoặc vàng/đỏ) xen kẽ mỗi 2 frames
            if ((timer div 2) % 2 == 0) {
                gpu_set_fog(true, col_fog, 0, 1);
                draw_sprite_ext(_spr, _frame, _px, _py, _pface, 1, 0, c_white, 1.0);
                gpu_set_fog(false, c_white, 0, 0);
            } else {
                draw_sprite_ext(_spr, _frame, _px, _py, _pface, 1, 0, c_white, 1.0);
            }
        }
    }
    
    // Vẽ các tia lửa điện nhấp nháy quanh thân
    gpu_set_blendmode(bm_add);
    for (var i = 0; i < array_length(sparks); i++) {
        var _sp = sparks[i];
        draw_set_color(_sp.col);
        draw_set_alpha(_sp.life / 4.0);
        var _x2 = _sp.x + lengthdir_x(_sp.len, _sp.angle);
        var _y2 = _sp.y + lengthdir_y(_sp.len, _sp.angle);
        draw_line_width(_sp.x, _sp.y, _x2, _y2, 1.8);
    }
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
}

// =========================================================================
// 2. GIAI ĐOẠN 2: CORE IMPLOSION (Frame 25 -> 32)
// =========================================================================
else if (timer <= 32) {
    if (use_procedural_draw || !sprite_exists(spr_x4_core_flash)) {
        draw_mmx4_core_plasma(origin_x, origin_y, core_scale, col_core, col_glow_mid, col_glow_outer, core_alpha);
    } else {
        var _cf_idx = clamp(floor(((timer - 25) / 8.0) * sprite_get_number(spr_x4_core_flash)), 0, sprite_get_number(spr_x4_core_flash) - 1);
        gpu_set_blendmode(bm_add);
        draw_sprite_ext(spr_x4_core_flash, _cf_idx, origin_x, origin_y, core_scale, core_scale, 0, c_white, core_alpha);
        gpu_set_blendmode(bm_normal);
    }
}

// =========================================================================
// 3. GIAI ĐOẠN 3 & 4: RING BURST (Frame 33 -> 140)
// =========================================================================
if (timer >= 33 && array_length(rings) > 0) {
    var _has_ring_spr = sprite_exists(spr_x4_death_ring) && !use_procedural_draw;
    
    if (_has_ring_spr) {
        gpu_set_blendmode(bm_add);
        var _sub = (timer div 2) % sprite_get_number(spr_x4_death_ring);
        for (var i = 0; i < array_length(rings); i++) {
            var _r = rings[i];
            var _sc = (_r.ring_size * 2.0) / sprite_get_width(spr_x4_death_ring);
            draw_sprite_ext(spr_x4_death_ring, _sub, _r.current_x, _r.current_y, _sc, _sc, _r.angle, c_white, _r.alpha);
        }
        gpu_set_blendmode(bm_normal);
    } else {
        // Procedural draw: vẽ vòng tròn rỗng phát sáng mượt mà bằng GML
        for (var i = 0; i < array_length(rings); i++) {
            var _r = rings[i];
            draw_mmx4_energy_ring(_r.current_x, _r.current_y, _r.ring_size, 3.5, col_core, col_glow_mid, _r.alpha);
        }
    }
}
