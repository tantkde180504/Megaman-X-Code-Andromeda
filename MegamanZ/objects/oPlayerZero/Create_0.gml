event_inherited();
combo_step = 0;
combo_timer = 0;
slash_anim_timer = 0;
slash_anim_frame = 0.0;
slash_total_frames = 10;
technique_state = TECHNIQUE.NONE;
technique_timer = 0;

// Movement animation variables
jump_frame = 0.0;
is_landing = false;
landing_frame = 8.0;
was_airborne = false;
prev_state = PLAYER_STATE.IDLE;

// Dash animation variables
dash_anim_frame = 0.0;
is_dash_recovering = false;
dash_recovery_frame = 4.0;

// Wall animation variables
wall_slide_anim_frame = 0.0;
wall_jump_anim_frame = 0.0;

// Air, Dash, Wall & Ladder slash tracking
is_air_slashing = false;
is_dash_slashing = false;
is_wall_slashing = false;
is_ladder_slashing = false;
ladder_anim_frame = 2.0;

// Damage status tracking
is_shocked = false;

// Active saber hitbox instance reference
current_saber_hitbox = noone;
