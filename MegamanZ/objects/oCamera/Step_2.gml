if (instance_exists(oPlayer)) {
    var _p = instance_find(oPlayer, 0);
    var _pos = camera_update_follow(view_camera[0], _p.x, _p.y);
    cam_x = lerp(cam_x, _pos[0], 0.15);
    cam_y = lerp(cam_y, _pos[1], 0.15);
}

var _shk_x = 0;
var _shk_y = 0;
if (shake_timer > 0) {
    var _curr_intensity = shake_intensity * (shake_timer / max(1, shake_duration));
    _shk_x = random_range(-_curr_intensity, _curr_intensity);
    _shk_y = random_range(-_curr_intensity, _curr_intensity);
    shake_timer--;
} else {
    shake_intensity = 0;
}

camera_set_view_pos(view_camera[0], round(cam_x + _shk_x), round(cam_y + _shk_y));
