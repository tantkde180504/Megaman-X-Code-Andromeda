/// @desc Giant Web Network Draw (Authentic Mega Man X4 Phase 2 Web)
var _pulse = (pulse_timer % 16 < 8);
var _web_col1 = _pulse ? make_color_rgb(120, 220, 255) : make_color_rgb(60, 160, 240);
var _web_col2 = make_color_rgb(20, 80, 180);

var _cur_radius = radius * build_phase;

// 1. Draw 8 Spoke Lines from Center to Outer Nodes
for (var i = 1; i <= 8; i++) {
    var _nx = cx + lengthdir_x(_cur_radius, (i - 1) * 45);
    var _ny = cy + lengthdir_y(_cur_radius, (i - 1) * 45);
    
    draw_set_color(_web_col1);
    draw_line_width(cx, cy, _nx, _ny, 2);
    draw_set_color(c_white);
    draw_line(cx, cy, _nx, _ny);
}

// 2. Draw Outer Octagon Ring
if (build_phase >= 0.4) {
    for (var i = 1; i <= 8; i++) {
        var _ang1 = (i - 1) * 45;
        var _ang2 = (i % 8) * 45;
        var _x1 = cx + lengthdir_x(_cur_radius, _ang1);
        var _y1 = cy + lengthdir_y(_cur_radius, _ang1);
        var _x2 = cx + lengthdir_x(_cur_radius, _ang2);
        var _y2 = cy + lengthdir_y(_cur_radius, _ang2);
        
        draw_set_color(_web_col1);
        draw_line_width(_x1, _y1, _x2, _y2, 2);
        draw_set_color(c_white);
        draw_line(_x1, _y1, _x2, _y2);
    }
}

// 3. Draw Inner Diamond Ring
if (build_phase >= 0.7) {
    var _inner_r = _cur_radius * 0.55;
    for (var i = 1; i <= 8; i++) {
        var _ang1 = (i - 1) * 45;
        var _ang2 = (i % 8) * 45;
        var _x1 = cx + lengthdir_x(_inner_r, _ang1);
        var _y1 = cy + lengthdir_y(_inner_r, _ang1);
        var _x2 = cx + lengthdir_x(_inner_r, _ang2);
        var _y2 = cy + lengthdir_y(_inner_r, _ang2);
        
        draw_set_color(_web_col2);
        draw_line(_x1, _y1, _x2, _y2);
    }
}

// 4. Center Core Sprite Overlay (Row 10 Diamond Web & Row 11 Octagon)
if (build_phase >= 0.8) {
    draw_web_spider_part(10, 1, cx, cy, 1, false);
}
draw_web_spider_part(11, clamp(floor(build_phase * 3), 0, 3), cx, cy, 1, false);

// 5. Draw Glowing Node Anchors
draw_set_color(_pulse ? c_white : make_color_rgb(180, 240, 255));
draw_circle(cx, cy, 4, false);
for (var i = 1; i <= 8; i++) {
    var _nx = cx + lengthdir_x(_cur_radius, (i - 1) * 45);
    var _ny = cy + lengthdir_y(_cur_radius, (i - 1) * 45);
    draw_circle(_nx, _ny, 3, false);
}
