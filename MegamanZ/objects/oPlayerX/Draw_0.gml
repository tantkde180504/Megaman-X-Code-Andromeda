// Draw dash afterimages / ghost trail
player_draw_afterimages();

// Death state handling (managed exclusively by obj_x_death_effect)
if (state == PLAYER_STATE.DEATH) {
    return;
}

// Helper to track current sprite and frame for dash afterimages
var _draw_player = function(_spr, _sub, _dx, _dy, _xsc, _ysc, _rot, _col, _alp) {
    current_sprite = _spr;
    current_frame = _sub;
    draw_sprite_ext(_spr, _sub, _dx, _dy, _xsc, _ysc, _rot, _col, _alp);
};

// Iframes blinking (only after recovering from HURT state so the damage animation remains visible)
if (state != PLAYER_STATE.HURT && iframes > 0 && (iframes div 3) % 2 == 0) return;

var _is_shooting = (shoot_anim_timer > 0);

// Real extracted sprites from Mega Man X spritesheet:
if (state == PLAYER_STATE.HURT && sprite_exists(sX_Hurt)) {
    var _hurt_f = 0;
    if (!grounded) {
        // Airborne hurt recoil: frames 4 & 5
        _hurt_f = ((hurt_timer div 3) % 2 == 0) ? 4 : 5;
    } else {
        // Ground hurt recoil & electric sparks: frames 0..3
        _hurt_f = (hurt_timer div 3) % 4;
    }
    _draw_player(sX_Hurt, _hurt_f, x, y, facing, 1, 0, c_white, 1);
} else if (is_landing && sprite_exists(sX_Jump)) {
    // Landing frames: frames 8..10 (1-indexed frames 9..11: touchdown, crouch, recover)
    var _landing_idx = clamp(floor(landing_frame), 8, 10);
    _draw_player(sX_Jump, _landing_idx, x, y, facing, 1, 0, c_white, 1);
} else if (is_dash_recovering && sprite_exists(sX_Dash)) {
    // Dash recovery: frames 4..7 (1-indexed frames 5..8: decelerate, brake, stop, stand)
    var _dash_rec_idx = clamp(floor(dash_recovery_frame), 4, 7);
    var _d_rec_spr = (_is_shooting && sprite_exists(sX_Dash_Shoot)) ? sX_Dash_Shoot : sX_Dash;
    _draw_player(_d_rec_spr, _dash_rec_idx, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.DASH && sprite_exists(sX_Dash)) {
    // Active Dash: frames 0..3 (holds on frame index 3 / 1-indexed frame 4 with speed streaks while dashing)
    var _dash_idx = clamp(floor(dash_anim_frame), 0, 3);
    var _d_spr = (_is_shooting && sprite_exists(sX_Dash_Shoot)) ? sX_Dash_Shoot : sX_Dash;
    _draw_player(_d_spr, _dash_idx, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.WALL_SLIDE && sprite_exists(sX_WallSlide)) {
    if (_is_shooting && sprite_exists(sX_WallSlide_Shoot)) {
        var _w_shoot_idx = (shoot_anim_timer > 10) ? 1 : 0;
        _draw_player(sX_WallSlide_Shoot, _w_shoot_idx, x, y, facing, 1, 0, c_white, 1);
    } else {
        var _slide_idx = clamp(floor(wall_slide_anim_frame), 1, 3);
        _draw_player(sX_WallSlide, _slide_idx, x, y, facing, 1, 0, c_white, 1);
    }
} else if (state == PLAYER_STATE.WALL_JUMP && sprite_exists(sX_WallSlide)) {
    // Wall Jump: plays frames 1, 5, 6 (indexes 0, 4, 5) then blends into jump
    if (wall_jump_anim_frame >= 3.0 && sprite_exists(sX_Jump)) {
        var _j_idx = clamp(floor(jump_frame), 0, 7);
        var _j_spr = (_is_shooting && sprite_exists(sX_Jump_Shoot)) ? sX_Jump_Shoot : sX_Jump;
        _draw_player(_j_spr, _j_idx, x, y, facing, 1, 0, c_white, 1);
    } else {
        var _wj_f = 0;
        if (wall_jump_anim_frame < 1.0) {
            _wj_f = 0; // Frame 1: cling prep
        } else if (wall_jump_anim_frame < 2.0) {
            _wj_f = 4; // Frame 5: wall kick push-off
        } else {
            _wj_f = 5; // Frame 6: wall leap
        }
        _draw_player(sX_WallSlide, _wj_f, x, y, facing, 1, 0, c_white, 1);
    }
} else if ((state == PLAYER_STATE.JUMP || state == PLAYER_STATE.FALL) && sprite_exists(sX_Jump)) {
    // Airborne jump & falling frames: holds on frame 7 (1-indexed frame 8) in air
    var _jump_idx = clamp(floor(jump_frame), 0, 7);
    var _j_spr = (_is_shooting && sprite_exists(sX_Jump_Shoot)) ? sX_Jump_Shoot : sX_Jump;
    _draw_player(_j_spr, _jump_idx, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.RUN && sprite_exists(sX_Run)) {
    // 16-frame authentic Run / Run-Shoot animation
    var _run_frame = (anim_timer * 0.3) % 16;
    var _r_spr = (_is_shooting && sprite_exists(sX_Run_Shoot)) ? sX_Run_Shoot : sX_Run;
    _draw_player(_r_spr, _run_frame, x, y, facing, 1, 0, c_white, 1);
} else if (state == PLAYER_STATE.IDLE) {
    if (_is_shooting && sprite_exists(sX_Idle_Shoot)) {
        var _prog = (14 - shoot_anim_timer) / 14;
        var _idle_shoot_idx = clamp(floor(_prog * 8), 0, 7);
        _draw_player(sX_Idle_Shoot, _idle_shoot_idx, x, y, facing, 1, 0, c_white, 1);
    } else if (sprite_exists(sX_Idle)) {
        var _idle_frame = (anim_timer * 0.12) % 5;
        _draw_player(sX_Idle, _idle_frame, x, y, facing, 1, 0, c_white, 1);
    }
} else if (state == PLAYER_STATE.LADDER && sprite_exists(sX_Ladder)) {
    if (is_ladder_exiting) {
        // Frames 10, 11, 12: ladder top exit (sprite index 9, 10, 11)
        var _top_idx = 9 + clamp(floor(ladder_exit_frame), 0, 2);
        _draw_player(sX_Ladder, _top_idx, x, y, 1, 1, 0, c_white, 1);
    } else if (_is_shooting) {
        // Frames 13, 14, 15: ladder shoot
        var _shoot_f = 0;
        if (shoot_anim_timer > 10) {
            _shoot_f = 1; // Frame 14: muzzle flash firing
        } else if (shoot_anim_timer > 5) {
            _shoot_f = 2; // Frame 15: recoil / hold
        } else {
            _shoot_f = 0; // Frame 13: prep / recovery
        }
        
        if (sprite_exists(sX_Ladder_Shoot)) {
            _draw_player(sX_Ladder_Shoot, _shoot_f, x, y, facing, 1, 0, c_white, 1);
        } else {
            _draw_player(sX_Ladder, 12 + _shoot_f, x, y, facing, 1, 0, c_white, 1);
        }
    } else {
        // Non-shooting ladder pose
        if (vsp != 0) {
            // Frames 2..9: climbing cycle (sprite index 1..8)
            var _climb_idx = clamp(floor(ladder_anim_frame), 1, 8);
            _draw_player(sX_Ladder, _climb_idx, x, y, 1, 1, 0, c_white, 1);
        } else {
            // Stopped on ladder:
            // If just grabbed (ladder_anim_frame < 1.0), draw Frame 1: cling (index 0)
            // Otherwise, hold current climbing frame
            var _hold_idx = (ladder_anim_frame < 1.0) ? 0 : clamp(floor(ladder_anim_frame), 1, 8);
            _draw_player(sX_Ladder, _hold_idx, x, y, 1, 1, 0, c_white, 1);
        }
    }
} else if (state == PLAYER_STATE.INTRO) {
    if (intro_phase == 0 && sprite_exists(sX_Teleport_In)) {
        // Phase 0: Vertical beam descending
        _draw_player(sX_Teleport_In, 0, x, teleport_beam_y, 1, 1, 0, c_white, 1);
    } else if (intro_phase == 1 && sprite_exists(sX_Teleport_In)) {
        // Phase 1: Energy sphere impact & burst
        var _sph_idx = clamp(floor(teleport_sphere_frame), 1, 7);
        _draw_player(sX_Teleport_In, _sph_idx, x, y, 1, 1, 0, c_white, 1);
    } else if (intro_phase == 2 && sprite_exists(sX_Intro)) {
        // Phase 2: X materializes, rises and assumes battle ready pose
        var _in_idx = clamp(floor(intro_anim_frame), 0, 8);
        _draw_player(sX_Intro, _in_idx, x, y, facing, 1, 0, c_white, 1);
    }
} else if (state == PLAYER_STATE.TELEPORT_OUT && sprite_exists(sX_Teleport_Out)) {
    var _to_idx = clamp(floor(teleport_out_frame), 0, 4);
    _draw_player(sX_Teleport_Out, _to_idx, x, y, 1, 1, 0, c_white, 1);
} else {
    // Procedural fallback representation for other states until their sprites are imported
    var _c_primary = make_color_rgb(0, 140, 240);    // X Blue
    var _c_secondary = make_color_rgb(0, 210, 255);  // Cyan trim
    var _c_skin = make_color_rgb(255, 215, 175);
    var _c_white = c_white;

    // Feet / Shadow
    draw_set_color(c_black);
    draw_set_alpha(0.3);
    draw_ellipse(x - 8, y - 2, x + 8, y + 2, false);
    draw_set_alpha(1.0);

    // Torso / Body
    var _body_y = y - 22;
    draw_set_color(_c_primary);
    draw_rectangle(x - 6, _body_y, x + 6, y - 10, false);
    draw_set_color(_c_secondary);
    draw_circle(x, _body_y + 4, 3, false); // Chest core gem

    // Legs
    draw_set_color(_c_primary);
    draw_rectangle(x - 6, y - 10, x - 1, y, false);
    draw_rectangle(x + 1, y - 10, x + 6, y, false);

    // Helmet & Face
    var _head_y = y - 28;
    draw_set_color(_c_primary);
    draw_circle(x, _head_y, 7, false);
    draw_set_color(_c_skin);
    draw_rectangle(x - (facing * 2), _head_y - 2, x + (facing * 5), _head_y + 4, false);
    draw_set_color(c_red);
    draw_circle(x, _head_y - 3, 2, false); // Helmet forehead gem

    // Buster Arm
    var _arm_x = x + (facing * 8);
    var _arm_y = y - 16;
    draw_set_color(_c_primary);
    draw_rectangle(_arm_x - 3, _arm_y - 3, _arm_x + 6, _arm_y + 3, false);
    draw_set_color(_c_secondary);
    draw_rectangle(_arm_x + 4, _arm_y - 2, _arm_x + 7, _arm_y + 2, false);
}

// -------------------------------------------------------------
// Authentic 13-Frame Energy Charge Effect & Glowing Body Aura
// -------------------------------------------------------------
if (charge_timer >= 15 && sprite_exists(sFX_X_Charge)) {
    var _cf = clamp(floor(charge_anim_frame), 0, 12);
    var _cx = x;
    var _cy = y - 18;
    
    // 1. Charge flash on X's body (matching upload1.webp & original MMX)
    if (charge_level == 2) {
        if (((anim_timer div 3) % 4) == 0 && sprite_exists(current_sprite)) {
            gpu_set_fog(true, make_color_rgb(50, 220, 255), 0, 0);
            gpu_set_blendmode(bm_add);
            draw_sprite_ext(current_sprite, current_frame, x, y, facing, 1, 0, c_white, 0.75);
            gpu_set_blendmode(bm_normal);
            gpu_set_fog(false, c_white, 0, 0);
        }
    } else if (charge_level == 1) {
        if (((anim_timer div 4) % 3) == 0 && sprite_exists(current_sprite)) {
            gpu_set_fog(true, make_color_rgb(80, 255, 140), 0, 0);
            gpu_set_blendmode(bm_add);
            draw_sprite_ext(current_sprite, current_frame, x, y, facing, 1, 0, c_white, 0.6);
            gpu_set_blendmode(bm_normal);
            gpu_set_fog(false, c_white, 0, 0);
        }
    }
    
    // 2. 13-Frame Energy Particles & Flare Pulses in ONE clean continuous direction
    gpu_set_blendmode(bm_add);
    if (charge_level == 2) {
        // Full charge: Intense electric cyan aura
        draw_sprite_ext(sFX_X_Charge, _cf, _cx, _cy, 1, 1, 0, make_color_rgb(100, 225, 255), 1.0);
    } else if (charge_level == 1) {
        // Semi charge: Greenish-cyan charge energy
        draw_sprite_ext(sFX_X_Charge, _cf, _cx, _cy, 1, 1, 0, make_color_rgb(120, 255, 170), 0.9);
    } else {
        // Initial charge gathering (timer 15..29): Subtle incoming blue particles
        draw_sprite_ext(sFX_X_Charge, _cf % 8, _cx, _cy, 1, 1, 0, make_color_rgb(100, 210, 255), 0.7);
    }
    gpu_set_blendmode(bm_normal);
}

// -------------------------------------------------------------
// Dynamic Buster Muzzle Flash (perfectly attached to X's buster)
// -------------------------------------------------------------
if (muzzle_flash_sprite != noone && sprite_exists(muzzle_flash_sprite)) {
    var _dx = 31;
    var _dy = -31;
    
    if (is_dash_recovering) {
        _dx = 22;
        _dy = -30;
    } else if (is_landing) {
        _dx = 20;
        _dy = -24;
    } else {
        switch (state) {
            case PLAYER_STATE.IDLE:
                _dx = 31;
                _dy = -31;
                break;
                
            case PLAYER_STATE.RUN:
                var _rf = floor((anim_timer * 0.3) % 16);
                if (_rf >= 6 && _rf <= 11) {
                    _dx = 35;
                } else if (_rf >= 12 && _rf <= 13) {
                    _dx = 31;
                } else if (_rf >= 14 || _rf <= 1) {
                    _dx = 28;
                } else {
                    _dx = 27;
                }
                _dy = -31;
                break;
                
            case PLAYER_STATE.JUMP:
            case PLAYER_STATE.FALL:
            case PLAYER_STATE.WALL_JUMP:
                _dx = 17;
                _dy = -40;
                break;
                
            case PLAYER_STATE.DASH:
                _dx = 32;
                _dy = -17;
                break;
                
            case PLAYER_STATE.WALL_SLIDE:
                _dx = 32;
                _dy = -39;
                break;
                
            case PLAYER_STATE.LADDER:
                _dx = 28;
                _dy = -40;
                break;
        }
    }
    
    var _bx = x + (facing * _dx);
    var _by = y + _dy;
    
    var _mf = clamp(floor(muzzle_flash_frame), 0, sprite_get_number(muzzle_flash_sprite) - 1);
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(muzzle_flash_sprite, _mf, _bx, _by, facing, 1, 0, c_white, 1.0);
    gpu_set_blendmode(bm_normal);
}
