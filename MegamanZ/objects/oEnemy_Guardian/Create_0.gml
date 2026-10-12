event_inherited();
hp = 8;
max_hp = 8;
contact_damage = 3;
projectile_damage = 2;
is_invulnerable = true;  // Frontal shield active in state 0 & 1
shield_direction = 1;   // 1: Directional front shield!

// States: 0: SHIELD_PATROL, 1: LOCK_CHARGE, 2: OPEN_ATTACK, 3: RECOVER
state = 0;
state_timer = 0;
start_x = x;
start_y = y;
