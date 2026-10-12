event_inherited();
beret_type = 0; // 0: Blue, 1: Green
hp = (beret_type == 0) ? 6 : 8;
max_hp = hp;
contact_damage = 3;
projectile_damage = 3;
is_invulnerable = false;
shield_direction = 0;

// States:
// 0: IDLE, 1: RUN, 2: SHOOT_STRAIGHT, 3: SHOOT_DIAGONAL, 4: BOMB_THROW,
// 5: CLIFF_PEEK, 6: CLIFF_JUMP, 7: FALL, 8: LAND
state = 0;
state_timer = 0;
move_speed = 1.8;
bullet_speed = 4.2;
grenade_speed_x = 3.6;
grenade_speed_y = -4.2;
grounded = true;
