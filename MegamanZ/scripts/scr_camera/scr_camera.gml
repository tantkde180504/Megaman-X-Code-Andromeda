/// @desc Camera Tracking & Screenshake System

// Trigger screenshake
function camera_shake(_intensity, _duration) {
    if (instance_exists(oCamera)) {
        oCamera.shake_intensity = max(oCamera.shake_intensity, _intensity);
        oCamera.shake_timer = max(oCamera.shake_timer, _duration);
        oCamera.shake_duration = max(oCamera.shake_duration, _duration);
    }
}

// Sky limits are camera top-left coordinates for the native 320x240 view.
// Keep the horizontal route steady; only the statue shaft scrolls vertically.
function camera_get_sky_bounds(_target_x, _target_y) {
    if (_target_x >= 4480) {
        // Upper walkway: artwork ends at y=432 below the portal platform.
        return [4112, 4880 - VIEW_WIDTH, 192, 192];
    }
    if (_target_x >= 4160 && (_target_x >= 4208 || _target_y < 1008)) {
        // Frame both statue rails while climbing; hide the empty side areas.
        return [4112, 4480 - VIEW_WIDTH, 192, 1216 - VIEW_HEIGHT];
    }
    // The truck roof is higher than the road: preserve jump headroom there.
    if (_target_x >= 2080 && _target_x < 2560) {
        return [0, 4480 - VIEW_WIDTH, 912, 912];
    }
    // Raised road and broken supports need a higher frame than the low floors.
    if ((_target_x >= 672 && _target_x < 1376) || _target_x >= 3584) {
        return [0, 4480 - VIEW_WIDTH, 944, 944];
    }
    // Low street and corridor: leave visible floor below the player's feet.
    return [0, 4480 - VIEW_WIDTH, 976, 976];
}

function camera_clamp_sky_view(_view_x, _view_y, _target_x, _target_y) {
    var _bounds = camera_get_sky_bounds(_target_x, _target_y);
    return [clamp(_view_x, _bounds[0], _bounds[1]),
            clamp(_view_y, _bounds[2], _bounds[3])];
}

// Jungle chamber: x=5120..5440, ceiling bottom=1904, floor top=2096.
// Keep a little ceiling and floor in frame; never follow jumps inside the arena.
function camera_get_boss_view(_target_x) {
    if (room_get_name(room) == "rStage_WebSpider") {
        // Passing the threshold must not interrupt the scripted gate scroll.
        if (instance_exists(oCamera) && oCamera.gate_pan_active) return noone;
        var _locked = instance_exists(oCamera) && oCamera.boss_arena_locked;
        if (_locked || _target_x >= 5120) return [5120, 2096 + 16 - VIEW_HEIGHT];
    }
    return noone;
}

// Reset both the arena latch and its transition before framing a new life.
function camera_reset_follow(_player) {
    if (!instance_exists(oCamera)) return;
    oCamera.boss_arena_locked = false;
    oCamera.gate_pan_active = false;
    oCamera.gate_pan_frame = 0;
    oCamera.follow_target_id = _player.id;
    oCamera.shake_timer = 0;
    oCamera.shake_intensity = 0;
    oCamera.shake_duration = 0;
    var _pos = camera_update_follow(view_camera[0], _player.x, _player.y);
    oCamera.cam_x = _pos[0];
    oCamera.cam_y = _pos[1];
    camera_set_view_pos(view_camera[0], _pos[0], _pos[1]);
}

// Start only once the door is fully open; the player walks while the view scrolls.
function camera_begin_gate_pan(_player, _arena_door) {
    if (!instance_exists(oCamera) || room_get_name(room) != "rStage_WebSpider") return;
    oCamera.follow_target_id = _player.id;
    oCamera.boss_arena_locked = false;
    oCamera.gate_pan_active = true;
    oCamera.gate_pan_frame = 0;
    oCamera.gate_pan_from_x = oCamera.cam_x;
    oCamera.gate_pan_from_y = oCamera.cam_y;
    oCamera.gate_pan_to_x = _arena_door ? 5120 : 4800;
    oCamera.gate_pan_to_y = _arena_door ? 1872 : 1840;
    oCamera.gate_pan_locks_arena = _arena_door;
    oCamera.shake_timer = 0;
}

function camera_gate_pan_running() {
    return instance_exists(oCamera) && oCamera.gate_pan_active;
}

// Update camera position to follow player within stage boundaries.
function camera_update_follow(_cam, _target_x, _target_y) {
    var _cam_w = VIEW_WIDTH;
    var _cam_h = VIEW_HEIGHT;
    
    // Target camera top-left position
    var _dest_x = _target_x - (_cam_w * 0.5);
    var _dest_y = _target_y - (_cam_h * 0.5) - 16; // Slight offset upwards for better view

    if (room == rStage_Sky) {
        return camera_clamp_sky_view(_dest_x, _dest_y, _target_x, _target_y);
    }
    
    var _boss_view = camera_get_boss_view(_target_x);
    if (is_array(_boss_view)) return _boss_view;

    // The save corridor is a complete screen, including the next door on the right.
    if (room_get_name(room) == "rStage_WebSpider" && _target_x >= 4832 && _target_x < 5120) {
        return [4800, 1840];
    }

    // Clamp to room boundaries
    _dest_x = clamp(_dest_x, 0, max(0, room_width - _cam_w));
    _dest_y = clamp(_dest_y, 0, max(0, room_height - _cam_h));
    
    return [_dest_x, _dest_y];
}
