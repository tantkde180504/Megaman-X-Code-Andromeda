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

// Air & Dash slash tracking
is_air_slashing = false;
is_dash_slashing = false;
