event_inherited();
beret_type = 0; // 0: Blue, 1: Green
hp_max = (beret_type == 0) ? 6 : 8;
hp = hp_max;
contact_damage = 3;
is_deflecting = false;
facing = -1;
state = 0; // 0: PATROL, 1: AIM, 2: SHOOT
state_timer = 0;
