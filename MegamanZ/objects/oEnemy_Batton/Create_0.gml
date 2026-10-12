event_inherited();
hp = 4;
max_hp = 4;
contact_damage = 3;
projectile_damage = 3;
is_invulnerable = true; // Wings shield while perched
shield_direction = 0;

// States: 0: CEILING_PERCH, 1: WAKE, 2: SWOOP_FLIGHT, 3: DROP_BOMB, 4: RETURN_CEILING
state = 0;
state_timer = 0;
start_y = y;
