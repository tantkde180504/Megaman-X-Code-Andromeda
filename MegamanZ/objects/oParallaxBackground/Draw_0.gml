if (room_get_name(room) == "rTitle") return;

if (room_get_name(room) == "rStage_WebSpider") {
    // 1. Tô nền đêm tím sẫm (midnight purple) phủ kín toàn bộ phòng
    draw_clear_alpha(make_color_rgb(16, 8, 48), 1);
    
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
