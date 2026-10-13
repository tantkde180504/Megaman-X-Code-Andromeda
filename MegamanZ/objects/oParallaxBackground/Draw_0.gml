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
    
    // 3. Hiển thị trực quan các khung va chạm (F1 Debug Overlay)
    if (variable_global_exists("debug_overlay") && global.debug_overlay) {
        var _x1 = _cx - 32;
        var _y1 = _cy - 32;
        var _x2 = _cx + _cw + 32;
        var _y2 = _cy + _ch + 32;
        
        // Sàn và tường cứng oSolid (Màu đỏ)
        with (oSolid) {
            if (bbox_right >= _x1 && bbox_left <= _x2 && bbox_bottom >= _y1 && bbox_top <= _y2) {
                draw_set_color(c_red);
                draw_set_alpha(0.35);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
                draw_set_alpha(0.9);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
            }
        }
        
        // Bậc nhảy 1 chiều oOneWayPlatform (Màu vàng)
        with (oOneWayPlatform) {
            if (bbox_right >= _x1 && bbox_left <= _x2 && bbox_bottom >= _y1 && bbox_top <= _y2) {
                draw_set_color(c_yellow);
                draw_set_alpha(0.35);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
                draw_set_alpha(0.9);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
            }
        }
        
        // Thang leo oLadder (Màu lục lam Cyan)
        with (oLadder) {
            if (bbox_right >= _x1 && bbox_left <= _x2 && bbox_bottom >= _y1 && bbox_top <= _y2) {
                draw_set_color(c_aqua);
                draw_set_alpha(0.35);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
                draw_set_alpha(0.9);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
            }
        }
        
        // Vùng nước oWater (Màu xanh dương Blue)
        with (oWater) {
            if (bbox_right >= _x1 && bbox_left <= _x2 && bbox_bottom >= _y1 && bbox_top <= _y2) {
                draw_set_color(c_blue);
                draw_set_alpha(0.3);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
                draw_set_alpha(0.8);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
            }
        }
        
        // Sàn trơn trượt oIceSurface (Màu trắng)
        with (oIceSurface) {
            if (bbox_right >= _x1 && bbox_left <= _x2 && bbox_bottom >= _y1 && bbox_top <= _y2) {
                draw_set_color(c_white);
                draw_set_alpha(0.4);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
                draw_set_alpha(0.9);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
            }
        }
        
        // Bệ lá rơi oPlatform_Falling (Màu cam)
        with (oPlatform_Falling) {
            if (bbox_right >= _x1 && bbox_left <= _x2 && bbox_bottom >= _y1 && bbox_top <= _y2) {
                draw_set_color(c_orange);
                draw_set_alpha(0.4);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
                draw_set_alpha(0.9);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
            }
        }
        
        draw_set_alpha(1.0);
        draw_set_color(c_white);
    }
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
