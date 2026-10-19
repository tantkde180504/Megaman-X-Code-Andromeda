/// @desc Giant Web Network Create (Phase 2 Arena Web)
depth = 50; // In front of background, behind boss and player

cx = x;
cy = y;
radius = 88;
anim_timer = 0;
build_phase = 0.0;
is_active = false;
pulse_timer = 0;

// Initialize 9 nodes: 1 center, 8 octagon vertices
web_nodes = array_create(9);
web_nodes[0] = [cx, cy];

for (var i = 0; i < 8; i++) {
    var _ang = i * 45;
    web_nodes[i + 1] = [cx + lengthdir_x(radius, _ang), cy + lengthdir_y(radius, _ang)];
}
