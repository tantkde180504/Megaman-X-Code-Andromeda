event_inherited();
hp = 3;
max_hp = 3;
contact_damage = 2;
projectile_damage = 2;
is_invulnerable = true;
shield_direction = 0; // 360-degree hard hat protection

// States: 0: GUARD (helmet duck), 1: PEEK (vulnerable), 2: ATTACK (3-way shot), 3: WALK
state = 0;
state_timer = 0;
