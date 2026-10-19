/// @desc Giant Web Network Draw (Authentic Mega Man X4 Phase 2 Web)
var _p = clamp(build_timer / max(1, build_duration), 0, 1.0);
// Cubic ease-out expansion curve
var _ease = 1.0 - power(1.0 - _p, 3);
var _cur_radius = radius * _ease;

var _pulse = (pulse_timer % 16 < 8);
var _glow_col = _pulse ? make_color_rgb(140, 240, 255) : make_color_rgb(60, 180, 255);
var _base_col = make_color_rgb(0, 100, 220);

// =============================================================================
// 1. Draw 8 Spoke Lines radiating from Center to Outer Nodes
// =============================================================================
for (var i = 1; i <= 8; i++) {
    var _ang = (i - 1) * 45;
    var _nx = cx + lengthdir_x(_cur_radius, _ang);
    var _ny = cy + lengthdir_y(_cur_radius, _ang);
    
    // Outer electric glow
    draw_set_color(_glow_col);
    draw_line_width(cx, cy, _nx, _ny, 3);
    
    // Inner core white/bright filament
    draw_set_color(c_white);
    draw_line(cx, cy, _nx, _ny);
    
    // Expanding tip orbs during build
    if (!is_active) {
        draw_set_color(_glow_col);
        draw_circle(_nx, _ny, 4, false);
        draw_set_color(c_white);
        draw_circle(_nx, _ny, 2, false);
    }
}

// =============================================================================
// 2. Center Electric Flare Flash upon initial burst (Row 10 Frame 2)
// =============================================================================
if (_p >= 0.15 && _p <= 0.55) {
    var _flare_alpha = 1.0 - abs((_p - 0.35) / 0.20);
    draw_web_spider_part(10, 2, cx, cy, 1, false, _flare_alpha, 1.8, 1.4);
}

// =============================================================================
// 3. Inner Diamond Web Ring (Row 10 Frame 0 / 1)
// =============================================================================
if (_p >= 0.25) {
    var _d_prog = clamp((_p - 0.25) / 0.50, 0, 1.0);
    var _d_scale = lerp(0.2, 1.85, 1.0 - power(1.0 - _d_prog, 2));
    var _df = (_pulse) ? 1 : 0;
    var _d_alpha = clamp(_d_prog * 1.5, 0, 0.95);
    draw_web_spider_part(10, _df, cx, cy, 1, false, _d_alpha, _d_scale, _d_scale);
}

// =============================================================================
// 4. Outer Octagon Web Ring (Row 11 Frames 0..3)
// =============================================================================
if (_p >= 0.35) {
    var _oct_prog = clamp((_p - 0.35) / 0.65, 0, 1.0);
    var _oct_scale = lerp(0.3, 1.88, 1.0 - power(1.0 - _oct_prog, 2));
    
    var _of = 0;
    if (_p < 0.60) {
        _of = 0; // Small ring
    } else if (_p < 0.82) {
        _of = 1; // Medium ring
    } else if (_p < 1.0) {
        _of = 2; // Large ring
    } else {
        _of = (_pulse) ? 3 : 2; // Electrified pulsing ring in combat
    }
    
    var _oct_alpha = clamp(_oct_prog * 1.6, 0, 1.0);
    draw_web_spider_part(11, _of, cx, cy, 1, false, _oct_alpha, _oct_scale, _oct_scale);
}

// =============================================================================
// 5. Connecting Outer Polygon Strands (Double width electric perimeter)
// =============================================================================
if (_p >= 0.40) {
    for (var i = 1; i <= 8; i++) {
        var _ang1 = (i - 1) * 45;
        var _ang2 = (i % 8) * 45;
        var _x1 = cx + lengthdir_x(_cur_radius, _ang1);
        var _y1 = cy + lengthdir_y(_cur_radius, _ang1);
        var _x2 = cx + lengthdir_x(_cur_radius, _ang2);
        var _y2 = cy + lengthdir_y(_cur_radius, _ang2);
        
        draw_set_color(_glow_col);
        draw_line_width(_x1, _y1, _x2, _y2, 2);
        draw_set_color(c_white);
        draw_line(_x1, _y1, _x2, _y2);
    }
}

// =============================================================================
// 6. Glowing Anchor Nodes at Vertices and Center
// =============================================================================
// Center hub
draw_set_color(_pulse ? c_white : make_color_rgb(180, 240, 255));
draw_circle(cx, cy, 6, false);
draw_set_color(c_white);
draw_circle(cx, cy, 3, false);

// 8 Outer nodes
for (var i = 1; i <= 8; i++) {
    var _ang = (i - 1) * 45;
    var _nx = cx + lengthdir_x(_cur_radius, _ang);
    var _ny = cy + lengthdir_y(_cur_radius, _ang);
    
    var _r_outer = is_active ? (_pulse ? 5 : 4) : max(1, 4 * _ease);
    draw_set_color(_pulse ? c_white : make_color_rgb(140, 240, 255));
    draw_circle(_nx, _ny, _r_outer, false);
    draw_set_color(c_white);
    draw_circle(_nx, _ny, max(1, _r_outer - 2), false);
}

// =============================================================================
// 7. Ambient Electric Arc Crackles (Random sparks across strands when active)
// =============================================================================
if (is_active && (pulse_timer % 6 < 3)) {
    var _node_a = (pulse_timer % 8) + 1;
    var _node_b = (_node_a % 8) + 1;
    var _ax = web_nodes[_node_a][0];
    var _ay = web_nodes[_node_a][1];
    var _bx = web_nodes[_node_b][0];
    var _by = web_nodes[_node_b][1];
    var _mid_x = ((_ax + _bx) * 0.5) + irandom_range(-6, 6);
    var _mid_y = ((_ay + _by) * 0.5) + irandom_range(-6, 6);
    
    draw_set_color(c_white);
    draw_line(_ax, _ay, _mid_x, _mid_y);
    draw_line(_mid_x, _mid_y, _bx, _by);
}
