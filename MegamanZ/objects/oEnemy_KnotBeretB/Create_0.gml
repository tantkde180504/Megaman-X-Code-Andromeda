event_inherited();
hp = 6;
max_hp = 6;
contact_damage = 3;
projectile_damage = 3;
is_invulnerable = false;
shield_direction = 0;

// States:
// 0: IDLE (Row 1) - Wait when player out of range
// 1: RUN (Row 3) - Run towards player
// 2: SHOOT_STRAIGHT (Row 2, 2 frames) - Shoot straight
// 3: SHOOT_DIAGONAL (Row 2, 2 frames) - Shoot diagonal
// 4: BOMB_THROW (Row 4) - Throw bomb
// 5: CLIFF_PEEK (Row 5, 2 frames) - Look down at edge
// 6: CLIFF_JUMP (Row 5, 2 frames) - Jump off ledge
// 7: FALL (Row 6, 2 frames) - Falling through air
// 8: LAND (Row 6, 3 frames) - Landing crouch & stand up
state = 0;
state_timer = 0;
move_speed = 1.8;
bullet_speed = 4.2;
grenade_speed_x = 3.6;
grenade_speed_y = -4.2;
grounded = true;

