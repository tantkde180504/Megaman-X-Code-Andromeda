/// @desc Zero Nightmare - Draw Event (Manual Frame, Afterimage, Aura & Hurt Flash)
var _draw_facing = -facing; // Sprite gốc quay trái -> facing = 1 thì scale = -1

// 1. Vẽ các tàn ảnh phía sau
for (var _i = 0; _i < array_length(afterimages); _i++) {
    var _ai = afterimages[_i];
    if (_ai.alpha > 0) {
        var _blend = (phase == 2) ? make_color_rgb(180, 80, 220) : make_color_rgb(80, 160, 255);
        draw_sprite_ext(_ai.sprite, _ai.frame, _ai.x, _ai.y, _ai.facing, 1, 0, _blend, _ai.alpha);
    }
}

// 2. Nền hào quang (Hàng 20) phía sau boss khi bay lơ lửng lúc 50% HP
if (state == NZ_STATE.FLOAT_PHASE2) {
    var _aura_frame = (state_timer div 6) % 4;
    var _aura_pulse = 0.7 + 0.3 * sin(current_time * 0.01);
    draw_sprite_ext(spr_nz_float_aura, _aura_frame, x, y, _draw_facing, 1, 0, c_white, _aura_pulse);
}

// 3. Tông màu cho Phase 2 (Pulsing Purple/Crimson Nightmare Aura)
var _blend_col = c_white;
if (phase == 2 && state != NZ_STATE.DEFEAT) {
    var _pulse = 0.5 + 0.5 * sin(current_time * 0.008);
    _blend_col = merge_color(c_white, make_color_rgb(255, 120, 180), _pulse * 0.6);
}

// 4. Hiệu ứng nháy trắng khi nhận sát thương hoặc đang trong i-frames
if (flash_timer > 0 || (state == NZ_STATE.HURT && (state_timer % 4 < 2))) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(anim_sprite, anim_frame, x, y, _draw_facing, 1, 0, c_white, 1);
    gpu_set_fog(false, c_white, 0, 0);
} else {
    draw_sprite_ext(anim_sprite, anim_frame, x, y, _draw_facing, 1, 0, _blend_col, image_alpha);
}
