if (instance_exists(oPlayer)) {
    var _p = instance_find(oPlayer, 0);
    // A latch belongs to one player life. Also recover same-room checkpoint/debug
    // teleports, while allowing normal recoil a little beyond the closed door.
    if (follow_target_id != _p.id
        || (boss_arena_locked && _p.x < 5056)) {
        camera_reset_follow(_p);
    }
    var _boss_view = camera_get_boss_view(_p.x);
    if (gate_pan_active) {
        gate_pan_frame = min(gate_pan_frame + 1, gate_pan_duration);
        var _t = gate_pan_frame / gate_pan_duration;
        var _ease = _t * _t * (3 - 2 * _t);
        cam_x = lerp(gate_pan_from_x, gate_pan_to_x, _ease);
        cam_y = lerp(gate_pan_from_y, gate_pan_to_y, _ease);
        if (gate_pan_frame >= gate_pan_duration) {
            gate_pan_active = false;
            boss_arena_locked = gate_pan_locks_arena;
        }
    } else if (is_array(_boss_view)) {
        boss_arena_locked = true;
        cam_x = _boss_view[0];
        cam_y = _boss_view[1];
    }
    // Keep the stage in frame while the teleport beam exits upward.
    else if (_p.state != PLAYER_STATE.TELEPORT_OUT) {
        var _pos = camera_update_follow(view_camera[0], _p.x, _p.y);
        if (room == rStage_Sky) {
            // Ease into the next frame without a large first step at a zone edge.
            cam_x += clamp((_pos[0] - cam_x) * 0.10, -8, 8);
            cam_y += clamp((_pos[1] - cam_y) * 0.10, -8, 8);
        } else {
            cam_x = lerp(cam_x, _pos[0], 0.15);
            cam_y = lerp(cam_y, _pos[1], 0.15);
        }
    }
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

var _view_x = round(cam_x + _shk_x);
var _view_y = round(cam_y + _shk_y);
if (boss_arena_locked && room_get_name(room) == "rStage_WebSpider") {
    // Keep the fixed arena frame inside the chamber even during screen shake.
    _view_x = cam_x;
    _view_y = cam_y;
}
if (room == rStage_Sky && instance_exists(oPlayer)) {
    var _target = instance_find(oPlayer, 0);
    var _bounds = camera_get_sky_bounds(_target.x, _target.y);
    // During a transition the allowed frame includes the current eased position.
    // Clamping the base position to the new zone would bypass easing and snap.
    // Shake can move toward the new bounds, but cannot expose more of the outside.
    _view_x = clamp(_view_x, round(min(_bounds[0], cam_x)), round(max(_bounds[1], cam_x)));
    _view_y = clamp(_view_y, round(min(_bounds[2], cam_y)), round(max(_bounds[3], cam_y)));
}
camera_set_view_pos(view_camera[0], _view_x, _view_y);
