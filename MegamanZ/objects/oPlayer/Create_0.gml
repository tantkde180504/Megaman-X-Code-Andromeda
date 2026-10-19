player_physics_init();
state = PLAYER_STATE.IDLE;
hp_max = 16;
hp_current = 16;
iframes = 0;
hurt_timer = 0;
death_timer = 0;
death_phase = 0;
is_dash_jumping = false;
anim_timer = 0;
is_ladder_exiting = false;
ladder_exit_frame = 0.0;

// Intro & Teleport variables
intro_phase = 0;
teleport_beam_y = 0;
teleport_sphere_frame = 1.0;
intro_anim_frame = 0.0;
intro_hold_timer = 0;
teleport_out_frame = 0.0;
