/// @desc Mini Spider Minion Create
event_inherited();

hp = 2;
damage = 4;
hsp = 0;
vsp = 0;
grav = 0.28;
spider_state = SPIDER_MINION_STATE.AIR;
crawl_dir = 1; // -1: crawls to left wall, 1: crawls to right wall
crawl_speed = 1.5; // Tốc độ bò dưới đất
wall_climb_speed = -1.8; // Tốc độ bò từ từ lên tường
floor_crawl_timer = 0;
floor_crawl_min_time = 90; // Phải bò dưới đất trước ít nhất 90 ticks (1.5 giây)
facing = 1;
anim_timer = 0;
is_invulnerable = false;
image_xscale = 1.0;
image_yscale = 1.0;

// Scan down for floor
y_floor = room_height - 32;
var _scan = y;
while (_scan < room_height && !place_meeting(x, _scan, oSolid)) {
    _scan += 8;
}
if (_scan < room_height) y_floor = _scan;

// Scan up for ceiling
y_ceiling = 32;
var _scan_up = y;
while (_scan_up > 0 && !place_meeting(x, _scan_up, oSolid)) {
    _scan_up -= 8;
}
if (_scan_up > 0) y_ceiling = _scan_up + 16;

// Scan left and right walls
left_wall_x = 32;
var _scan_l = x;
while (_scan_l > 0 && !place_meeting(_scan_l, y, oSolid)) {
    _scan_l -= 16;
}
if (_scan_l > 0) left_wall_x = _scan_l + 16;

right_wall_x = room_width - 32;
var _scan_r = x;
while (_scan_r < room_width && !place_meeting(_scan_r, y, oSolid)) {
    _scan_r += 16;
}
if (_scan_r < room_width) right_wall_x = _scan_r - 16;
