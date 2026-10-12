event_inherited();
hp = 5;
max_hp = 5;
contact_damage = 3;
projectile_damage = 2;
is_invulnerable = false;
shield_direction = 0;

// States: 0: PATROL_HOVER, 1: AIM, 2: FIRE, 3: RECOVER
state = 0;
state_timer = 0;
start_y = y;
start_x = x;
patrol_radius = 48;
fire_interval = 90;
bullet_speed = 3.2;
