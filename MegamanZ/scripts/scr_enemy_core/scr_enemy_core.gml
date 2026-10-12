/// @desc Enemy Core Helper Functions

function enemy_draw_part(_sheet, _src_x, _src_y, _w, _h, _x, _y, _facing = 1, _flash = false) {
    var _draw_x = (_facing == 1) ? floor(_x - _w / 2) : floor(_x + _w / 2);
    var _draw_y = floor(_y - _h);
    if (_flash) {
        gpu_set_fog(true, c_white, 0, 0);
        draw_sprite_part_ext(_sheet, 0, _src_x, _src_y, _w, _h, _draw_x, _draw_y, _facing, 1, c_white, 1.0);
        gpu_set_fog(false, c_white, 0, 0);
    } else {
        draw_sprite_part_ext(_sheet, 0, _src_x, _src_y, _w, _h, _draw_x, _draw_y, _facing, 1, c_white, 1.0);
    }
}

function enemy_draw_part_centered(_sheet, _src_x, _src_y, _w, _h, _x, _y, _facing = 1, _flash = false) {
    var _draw_x = (_facing == 1) ? floor(_x - _w / 2) : floor(_x + _w / 2);
    var _draw_y = floor(_y - _h / 2);
    if (_flash) {
        gpu_set_fog(true, c_white, 0, 0);
        draw_sprite_part_ext(_sheet, 0, _src_x, _src_y, _w, _h, _draw_x, _draw_y, _facing, 1, c_white, 1.0);
        gpu_set_fog(false, c_white, 0, 0);
    } else {
        draw_sprite_part_ext(_sheet, 0, _src_x, _src_y, _w, _h, _draw_x, _draw_y, _facing, 1, c_white, 1.0);
    }
}
