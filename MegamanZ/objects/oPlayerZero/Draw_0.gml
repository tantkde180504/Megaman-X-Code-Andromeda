// Draw dash afterimages / ghost trail
player_draw_afterimages();

// Helper to track current sprite and frame for dash afterimages
var _draw_player = function(_spr, _sub, _dx, _dy, _xsc, _ysc, _rot, _col, _alp) {
    current_sprite = _spr;
    current_frame = _sub;
    draw_sprite_ext(_spr, _sub, _dx, _dy, _xsc, _ysc, _rot, _col, _alp);
};

// Death state handling
if (state == PLAYER_STATE.DEATH && death_phase < 2) {
    if (death_phase == 0 && death_timer > 50) {
        if (sprite_exists(sZero_Hurt)) {
            _draw_player(sZero_Hurt, 2, x, y, facing, 1, 0, c_white, 1);
        }
    }
    return;
}

// Iframes blinking (only after recovering from HURT state so damage animation remains visible)
if (state != PLAYER_STATE.HURT && iframes > 0 && (iframes div 3) % 2 == 0) return;

// Shadow (hide during beam drop)
if (state != PLAYER_STATE.INTRO || intro_phase > 0) {
    draw_set_color(c_black);
    draw_set_alpha(0.3);
    draw_ellipse(x - 8, y - 2, x + 8, y + 2, false);
    draw_set_alpha(1.0);
}

// 0. INTRO & TELEPORT (Stage Enter & Stage Clear)
if (state == PLAYER_STATE.INTRO) {
    if (intro_phase == 0 && sprite_exists(sZero_Teleport_In)) {
        // Phase 0: Vertical red beam descending from ceiling
        _draw_player(sZero_Teleport_In, 0, x, teleport_beam_y, 1, 1, 0, c_white, 1);
    } else if (intro_phase == 1 && sprite_exists(sZero_Teleport_In)) {
        // Phase 1: Red energy dome impact burst & expanding sphere (frames 1..7)
        var _sph_idx = clamp(floor(teleport_sphere_frame), 1, 7);
        _draw_player(sZero_Teleport_In, _sph_idx, x, y, 1, 1, 0, c_white, 1);
    } else if (intro_phase == 2 && sprite_exists(sZero_Intro)) {
        // Phase 2: Zero solidifies, steps forward and assumes battle ready pose (frames 0..8)
        var _in_idx = clamp(floor(intro_anim_frame), 0, 8);
        _draw_player(sZero_Intro, _in_idx, x, y, facing, 1, 0, c_white, 1);
    }
}
else if (state == PLAYER_STATE.TELEPORT_OUT && sprite_exists(sZero_Teleport_Out)) {
    var _to_idx = clamp(floor(teleport_out_frame), 0, 13);
    _draw_player(sZero_Teleport_Out, _to_idx, x, y, facing, 1, 0, c_white, 1);
}
// 1. HURT & DAMAGE STATE (Rows 20 & 21)
else if (state == PLAYER_STATE.HURT) {
    if (is_shocked && sprite_exists(sZero_Shock)) {
        var _shock_f = clamp(floor((1.0 - (hurt_timer / 18.0)) * 6), 0, 5);
        _draw_player(sZero_Shock, _shock_f, x, y, facing, 1, 0, c_white, 1);
    } else if (sprite_exists(sZero_Hurt)) {
        // 4-frame hurt impact recoil shudder and recovery
        var _hurt_f = clamp(floor((1.0 - (hurt_timer / 18.0)) * 4), 0, 3);
        _draw_player(sZero_Hurt, _hurt_f, x, y, facing, 1, 0, c_white, 1);
    }
}
// 1. SPECIAL TECHNIQUES (Authentic custom sprites: Ryuenjin, Hyouretsuzan, Kuuenbu, Raijingeki)
else if (technique_state == TECHNIQUE.RYUENJIN && sprite_exists(Ryuenjin)) {
    var _f_ryu = clamp(floor(technique_frame), 0, 15);
    _draw_player(Ryuenjin, _f_ryu, x, y, facing, 1, 0, c_white, 1);
}
else if (technique_state == TECHNIQUE.HYOURETSUZAN && sprite_exists(Hyouretsuzan)) {
    var _f_hyou = clamp(floor(technique_frame), 0, 8);
    _draw_player(Hyouretsuzan, _f_hyou, x, y, facing, 1, 0, c_white, 1);
}
else if (technique_state == TECHNIQUE.KUUENZAN && sprite_exists(Kuuenbu)) {
    var _f_kuu = clamp(floor(technique_frame), 0, 7);
    _draw_player(Kuuenbu, _f_kuu, x, y, facing, 1, 0, c_white, 1);
}
else if (technique_state == TECHNIQUE.RAIJINGEKI && sprite_exists(Raijingeki)) {
    var _f_rai = clamp(floor(technique_frame), 0, 23);
    _draw_player(Raijingeki, _f_rai, x, y, facing, 1, 0, c_white, 1);
}
// 2. Z-SABER COMBAT ATTACKS (Highest priority when slashing!)
else if (slash_anim_timer > 0) {
    var _f_slash = clamp(floor(slash_anim_frame), 0, 8);
    if (is_wall_slashing && sprite_exists(sZero_WallSlash)) {
        // Wall slash with Z-Saber (Hàng 17)
        _draw_player(sZero_WallSlash, _f_slash, x, y, facing, 1, 0, c_white, 1);
    } else if (is_ladder_slashing && sprite_exists(sZero_LadderSlash)) {
        // Ladder slash with Z-Saber (Hàng 19)
        _draw_player(sZero_LadderSlash, _f_slash, x, y, facing, 1, 0, c_white, 1);
    } else if (!grounded && sprite_exists(sZero_AirSlash)) {
        // Pure mid-air jump slash (Hàng 13)
        _draw_player(sZero_AirSlash, _f_slash, x, y, facing, 1, 0, c_white, 1);
    } else if (grounded && (is_air_slashing || is_dash_slashing || state == PLAYER_STATE.DASH) && sprite_exists(sZero_DashSlash)) {
        // Air-to-ground landing slash OR dash slash (Hàng 14)
        _draw_player(sZero_DashSlash, _f_slash, x, y, facing, 1, 0, c_white, 1);
    } else if (combo_step == 3 && sprite_exists(sZero_Slash3)) {
        var _f = clamp(floor(slash_anim_frame), 0, 13);
        _draw_player(sZero_Slash3, _f, x, y, facing, 1, 0, c_white, 1);
    } else if (combo_step == 2 && sprite_exists(sZero_Slash2)) {
        var _f = clamp(floor(slash_anim_frame), 0, 9);
        _draw_player(sZero_Slash2, _f, x, y, facing, 1, 0, c_white, 1);
    } else if (sprite_exists(sZero_Slash1)) {
        var _f = clamp(floor(slash_anim_frame), 0, 9);
        _draw_player(sZero_Slash1, _f, x, y, facing, 1, 0, c_white, 1);
    }
}
// 2. WALL SLIDE & WALL JUMP
else if (state == PLAYER_STATE.WALL_SLIDE && sprite_exists(sZero_WallSlide)) {
    var _slide_idx = clamp(floor(wall_slide_anim_frame), 1, 3);
    _draw_player(sZero_WallSlide, _slide_idx, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.WALL_JUMP && sprite_exists(sZero_WallSlide)) {
    if (wall_jump_anim_frame >= 3.0 && sprite_exists(sZero_Jump)) {
        var _j_idx = clamp(floor(jump_frame), 0, 6);
        _draw_player(sZero_Jump, _j_idx, x, y, facing, 1, 0, c_white, 1);
    } else {
        var _wj_f = (wall_jump_anim_frame < 1.5) ? 4 : 5;
        _draw_player(sZero_WallSlide, _wj_f, x, y, facing, 1, 0, c_white, 1);
    }
}
// 3. LADDER (Hàng 18: 14 frames)
else if (state == PLAYER_STATE.LADDER && sprite_exists(sZero_Ladder)) {
    if (is_ladder_exiting) {
        // Frames 10..13: Ladder top exit
        var _top_idx = 10 + clamp(floor(ladder_exit_frame), 0, 3);
        _draw_player(sZero_Ladder, _top_idx, x, y, 1, 1, 0, c_white, 1);
    } else {
        if (vsp != 0) {
            // Frames 2..9: Climbing cycle (8 frames)
            var _climb_idx = clamp(floor(ladder_anim_frame), 2, 9);
            _draw_player(sZero_Ladder, _climb_idx, x, y, 1, 1, 0, c_white, 1);
        } else {
            // Frame 0: Hold / rest on ladder
            _draw_player(sZero_Ladder, 0, x, y, 1, 1, 0, c_white, 1);
        }
    }
}
// 4. BASIC MOVEMENT
else if (is_landing && sprite_exists(sZero_Jump)) {
    // Landing frames: frames 8..10 (indices 8..10)
    var _landing_idx = clamp(floor(landing_frame), 8, 10);
    _draw_player(sZero_Jump, _landing_idx, x, y, facing, 1, 0, c_white, 1);
} else if (is_dash_recovering && sprite_exists(sZero_Dash)) {
    // Dash recovery: frames 4..5
    var _dash_rec_idx = clamp(floor(dash_recovery_frame), 4, 5);
    _draw_player(sZero_Dash, _dash_rec_idx, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.DASH && sprite_exists(sZero_Dash)) {
    // Active Dash: frames 0..3 (holds on frame index 3 with jet thrust while dashing)
    var _dash_idx = clamp(floor(dash_anim_frame), 0, 3);
    _draw_player(sZero_Dash, _dash_idx, x, y, facing, 1, 0, c_white, 1);
} else if ((state == PLAYER_STATE.JUMP || state == PLAYER_STATE.FALL) && sprite_exists(sZero_Jump)) {
    // Airborne jump & falling frames: holds on frame 6 (fall pose with ponytail streaming up)
    var _jump_idx = clamp(floor(jump_frame), 0, 6);
    _draw_player(sZero_Jump, _jump_idx, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.RUN && sprite_exists(sZero_Run)) {
    // 16-frame authentic Run animation
    var _run_frame = (anim_timer * 0.3) % 16;
    _draw_player(sZero_Run, _run_frame, x, y, facing, 1, 0, c_white, 1);
} else {
    // Check if low health (<= 30% HP) for exhausted idle animation (Hàng 20: 4 frame sau)
    if ((hp_current / hp_max) <= 0.30 && sprite_exists(sZero_LowHealth)) {
        var _low_frame = (anim_timer * 0.1) % 4;
        _draw_player(sZero_LowHealth, _low_frame, x, y, facing, 1, 0, c_white, 1);
    } else if (sprite_exists(sZero_Idle)) {
        // Combat ready breathing idle animation with full flowing ponytail
        var _idle_frame = (anim_timer * 0.1) % 5;
        _draw_player(sZero_Idle, _idle_frame, x, y, facing, 1, 0, c_white, 1);
    }
}

