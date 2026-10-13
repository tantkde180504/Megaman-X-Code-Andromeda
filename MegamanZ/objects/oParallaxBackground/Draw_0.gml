if (room_get_name(room) == "rTitle") return;

if (room_get_name(room) == "rStage_WebSpider") {
    var _cx = camera_get_view_x(view_camera[0]);
    var _cy = camera_get_view_y(view_camera[0]);
    var _cw = camera_get_view_width(view_camera[0]);
    var _ch = camera_get_view_height(view_camera[0]);
    
    // 1. Tô nền đêm tím sẫm (midnight purple) phủ kín vùng nhìn của camera
    draw_set_color(make_color_rgb(16, 8, 48));
    draw_set_alpha(1.0);
    draw_rectangle(_cx, _cy, _cx + _cw, _cy + _ch, false);
    
    // 2. Vẽ toàn bộ bản đồ JungleMap nguyên bản sắc nét
    draw_sprite(JungleMap, 0, 0, 0);
    return;
}

if (room_get_name(room) == "rBoss_NightmareZero") return;

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
