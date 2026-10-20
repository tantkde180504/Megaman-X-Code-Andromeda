event_inherited();
charge_timer = 0;
charge_level = 0;
charge_anim_frame = 0.0;
charge_sound = noone;
shoot_anim_timer = 0;
muzzle_flash_sprite = noone;
muzzle_flash_frame = 0.0;
muzzle_flash_max = 0;

// Sprite Animation Variables
jump_frame = 0.0;
is_landing = false;
landing_frame = 8.0;
was_airborne = false;
prev_state = PLAYER_STATE.IDLE;

// Dash animation
dash_anim_frame = 0.0;
is_dash_recovering = false;
dash_recovery_frame = 4.0;

// Wall animation
wall_slide_anim_frame = 0.0;
wall_jump_anim_frame = 0.0;

// Ladder animation
ladder_anim_frame = 0.0;
is_ladder_exiting = false;
ladder_exit_frame = 0.0;

// Intro & Teleport animation
intro_phase = 0;
teleport_beam_y = 0;
teleport_sphere_frame = 1.0;
intro_anim_frame = 0.0;
intro_hold_timer = 0;
teleport_out_frame = 0.0;
