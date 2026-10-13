/// @desc Zero Nightmare - Draw Event (Manual Frame, Afterimage & Hurt Flash)
var _draw_facing = -facing; // Sprite gốc quay trái -> facing = 1 thì scale = -1
var _draw_x = round(x);
var _draw_y = round(y);

// 1. Vẽ các tàn ảnh phía sau lúc Lướt & Teleport
for (var _i = 0; _i < array_length(afterimages); _i++) {
    var _ai = afterimages[_i];
    if (_ai.alpha > 0) {
        var _blend = (hp <= max_hp * 0.5) ? make_color_rgb(180, 80, 220) : make_color_rgb(80, 160, 255);
        draw_sprite_ext(_ai.sprite, _ai.frame, round(_ai.x), round(_ai.y), _ai.facing, 1, 0, _blend, _ai.alpha);
    }
}

// 2. Tông màu cho Phase 2 (< 50% HP: Pulsing Purple/Crimson Nightmare Aura)
var _blend_col = c_white;
if (hp <= max_hp * 0.5 && state != NZ_STATE.DEFEAT) {
    var _pulse = 0.5 + 0.5 * sin(current_time * 0.008);
    _blend_col = merge_color(c_white, make_color_rgb(255, 120, 180), _pulse * 0.6);
}

// 3. Hiệu ứng nháy trắng khi nhận sát thương, i-frames hoặc đang nổ (Defeat frame 2)
var _is_flashing = (flash_timer > 0) || 
                   (state == NZ_STATE.HURT && (state_timer % 4 < 2)) ||
                   (state == NZ_STATE.DEFEAT && death_timer < 55 && (death_timer % 4 < 2));

if (_is_flashing) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(anim_sprite, anim_frame, _draw_x, _draw_y, _draw_facing, 1, 0, c_white, 1);
    gpu_set_fog(false, c_white, 0, 0);
} else {
    draw_sprite_ext(anim_sprite, anim_frame, _draw_x, _draw_y, _draw_facing, 1, 0, _blend_col, image_alpha);
}
