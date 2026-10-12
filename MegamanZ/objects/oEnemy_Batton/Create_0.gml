event_inherited();
hp = 4;
max_hp = 4;
contact_damage = 3;
projectile_damage = 3;
is_invulnerable = false;
shield_direction = 0;

// States:
// 0: WAIT (Row 1, 4 frame đầu) - Đang đợi trong khi giữ bom
// 1: DROP_BOMB (Row 1, frame 5, 6) - Mở móng thả bom và bắt đầu bay
// 2: SWOOP_FLIGHT (Row 2, 6 frame) - Bay tự do lượn quanh phát hiện địch
// 3: DESTROYED (Row 3: đầu rơi, Row 4: nổ tan xác) - Khi bị tiêu diệt
state = 0;
state_timer = 0;
start_y = y;
start_x = x;

// Destruction debris variables
skull_x = x;
skull_y = y;
skull_vsp = 0;
skull_hsp = 0;
