/// @desc Mini Spider Minion Create
event_inherited();

hp = 2;
damage = 4;
hsp = 0;
vsp = 0;
grav = 0.25;
spider_state = SPIDER_MINION_STATE.AIR;
facing = 1;
anim_timer = 0;
y_floor = room_height - 32;
is_invulnerable = false;
image_xscale = 1.0;
image_yscale = 1.0;

// Scan down for floor
var _scan = y;
while (_scan < room_height && !place_meeting(x, _scan, oSolid)) {
    _scan += 8;
}
if (_scan < room_height) y_floor = _scan;
