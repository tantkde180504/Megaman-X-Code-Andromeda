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

// Dash Afterimage / Ghost Trail variables
afterimages = [];
afterimage_timer = 0;
afterimage_interval = 3;
current_sprite = noone;
current_frame = 0;

// Intro & Teleport variables
intro_phase = 0;
teleport_beam_y = 0;
teleport_sphere_frame = 1.0;
intro_anim_frame = 0.0;
intro_hold_timer = 0;
teleport_out_frame = 0.0;

// Web binding debuff (from Lightning Web)
is_web_bound = false;
web_bound_timer = 0;
web_bound_damage_timer = 0;

