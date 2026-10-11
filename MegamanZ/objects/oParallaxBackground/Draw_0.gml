var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);

// Draw Far Mountain Background
var _far_x = (_cx * 0.15) mod VIEW_WIDTH;
draw_sprite(sBG_Far, 0, _cx - _far_x, _cy);
draw_sprite(sBG_Far, 0, _cx - _far_x + VIEW_WIDTH, _cy);

// Draw Mid Hills / Forest Background
var _mid_x = (_cx * 0.45) mod VIEW_WIDTH;
draw_sprite(sBG_Mid, 0, _cx - _mid_x, _cy);
draw_sprite(sBG_Mid, 0, _cx - _mid_x + VIEW_WIDTH, _cy);
