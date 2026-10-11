// Iframes blinking (only after recovering from HURT state so damage animation remains visible)
if (state != PLAYER_STATE.HURT && iframes > 0 && (iframes div 3) % 2 == 0) return;

// Shadow
draw_set_color(c_black);
draw_set_alpha(0.3);
draw_ellipse(x - 8, y - 2, x + 8, y + 2, false);
draw_set_alpha(1.0);

// 1. Z-SABER COMBAT ATTACKS (Highest priority when slashing!)
if (slash_anim_timer > 0) {
    var _f_slash = clamp(floor(slash_anim_frame), 0, 8);
    if (!grounded && sprite_exists(sZero_AirSlash)) {
        // Pure mid-air jump slash (Hàng 13)
        draw_sprite_ext(sZero_AirSlash, _f_slash, x, y, facing, 1, 0, c_white, 1);
    } else if (grounded && (is_air_slashing || is_dash_slashing || state == PLAYER_STATE.DASH) && sprite_exists(sZero_DashSlash)) {
        // Air-to-ground landing slash OR dash slash (Hàng 14)
        draw_sprite_ext(sZero_DashSlash, _f_slash, x, y, facing, 1, 0, c_white, 1);
    } else if (combo_step == 3 && sprite_exists(sZero_Slash3)) {
        var _f = clamp(floor(slash_anim_frame), 0, 13);
        draw_sprite_ext(sZero_Slash3, _f, x, y, facing, 1, 0, c_white, 1);
    } else if (combo_step == 2 && sprite_exists(sZero_Slash2)) {
        var _f = clamp(floor(slash_anim_frame), 0, 9);
        draw_sprite_ext(sZero_Slash2, _f, x, y, facing, 1, 0, c_white, 1);
    } else if (sprite_exists(sZero_Slash1)) {
        var _f = clamp(floor(slash_anim_frame), 0, 9);
        draw_sprite_ext(sZero_Slash1, _f, x, y, facing, 1, 0, c_white, 1);
    }
}
// 2. WALL SLIDE & WALL JUMP
else if (state == PLAYER_STATE.WALL_SLIDE && sprite_exists(sZero_WallSlide)) {
    var _slide_idx = clamp(floor(wall_slide_anim_frame), 1, 3);
    draw_sprite_ext(sZero_WallSlide, _slide_idx, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.WALL_JUMP && sprite_exists(sZero_WallSlide)) {
    if (wall_jump_anim_frame >= 3.0 && sprite_exists(sZero_Jump)) {
        var _j_idx = clamp(floor(jump_frame), 0, 6);
        draw_sprite_ext(sZero_Jump, _j_idx, x, y, facing, 1, 0, c_white, 1);
    } else {
        var _wj_f = (wall_jump_anim_frame < 1.5) ? 4 : 5;
        draw_sprite_ext(sZero_WallSlide, _wj_f, x, y, facing, 1, 0, c_white, 1);
    }
}
// 3. BASIC MOVEMENT
else if (is_landing && sprite_exists(sZero_Jump)) {
    // Landing frames: frames 8..10 (indices 8..10)
    var _landing_idx = clamp(floor(landing_frame), 8, 10);
    draw_sprite_ext(sZero_Jump, _landing_idx, x, y, facing, 1, 0, c_white, 1);
} else if (is_dash_recovering && sprite_exists(sZero_Dash)) {
    // Dash recovery: frames 4..5
    var _dash_rec_idx = clamp(floor(dash_recovery_frame), 4, 5);
    draw_sprite_ext(sZero_Dash, _dash_rec_idx, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.DASH && sprite_exists(sZero_Dash)) {
    // Active Dash: frames 0..3 (holds on frame index 3 with jet thrust while dashing)
    var _dash_idx = clamp(floor(dash_anim_frame), 0, 3);
    draw_sprite_ext(sZero_Dash, _dash_idx, x, y, facing, 1, 0, c_white, 1);
} else if ((state == PLAYER_STATE.JUMP || state == PLAYER_STATE.FALL) && sprite_exists(sZero_Jump)) {
    // Airborne jump & falling frames: holds on frame 6 (fall pose with ponytail streaming up)
    var _jump_idx = clamp(floor(jump_frame), 0, 6);
    draw_sprite_ext(sZero_Jump, _jump_idx, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.RUN && sprite_exists(sZero_Run)) {
    // 16-frame authentic Run animation
    var _run_frame = (anim_timer * 0.3) % 16;
    draw_sprite_ext(sZero_Run, _run_frame, x, y, facing, 1, 0, c_white, 1);
} else if (sprite_exists(sZero_Idle)) {
    // Combat ready breathing idle animation with full flowing ponytail
    var _idle_frame = (anim_timer * 0.1) % 5;
    draw_sprite_ext(sZero_Idle, _idle_frame, x, y, facing, 1, 0, c_white, 1);
}

// Technique VFX Overlays
if (technique_state == TECHNIQUE.RYUENJIN) {
    draw_set_color(make_color_rgb(255, 120, 20)); // Flame
    draw_set_alpha(0.8);
    draw_ellipse(x - 8, y - 40, x + 8, y, false);
    draw_set_alpha(1.0);
} else if (technique_state == TECHNIQUE.HYOURETSUZAN) {
    draw_set_color(make_color_rgb(100, 220, 255)); // Ice
    draw_set_alpha(0.8);
    draw_triangle(x - 6, y - 10, x + 6, y - 10, x, y + 16, false);
    draw_set_alpha(1.0);
} else if (technique_state == TECHNIQUE.KUUENZAN) {
    var _c_saber = make_color_rgb(40, 255, 120);     // Green Saber
    draw_set_color(_c_saber);
    draw_set_alpha(0.7);
    draw_circle(x, y - 16, 22, true);
    draw_set_alpha(1.0);
} else if (technique_state == TECHNIQUE.RAIJINGEKI) {
    draw_set_color(make_color_rgb(255, 255, 80)); // Lightning
    draw_set_alpha(0.8);
    draw_line_width(x, y - 16, x + (facing * 36), y - 16, 4);
    draw_set_alpha(1.0);
}
