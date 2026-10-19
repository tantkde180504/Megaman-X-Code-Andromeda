/// @desc Web Leaf Telegraph Create
timer = irandom(60);
start_x = x;
y_floor = room_height - 32;
leaf_frame = irandom(6);
anim_timer = 0;
image_speed = 0;

// Scan down for floor
var _scan = y;
while (_scan < room_height && !place_meeting(x, _scan, oSolid)) {
    _scan += 8;
}
if (_scan < room_height) y_floor = _scan;
