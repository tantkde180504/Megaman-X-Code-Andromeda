/// @desc Camera Tracking & Screenshake System

// Trigger screenshake
function camera_shake(_intensity, _duration) {
    if (instance_exists(oCamera)) {
        oCamera.shake_intensity = max(oCamera.shake_intensity, _intensity);
        oCamera.shake_timer = max(oCamera.shake_timer, _duration);
        oCamera.shake_duration = max(oCamera.shake_duration, _duration);
    }
}

// Update camera position to follow player with deadzone and boundaries
function camera_update_follow(_cam, _target_x, _target_y) {
    var _cam_w = VIEW_WIDTH;
    var _cam_h = VIEW_HEIGHT;
    
    // Target camera top-left position
    var _dest_x = _target_x - (_cam_w * 0.5);
    var _dest_y = _target_y - (_cam_h * 0.5) - 16; // Slight offset upwards for better view
    
    // Lock to Boss Arena in Jungle Stage when player enters boss room past Door 2
    if (room_get_name(room) == "rStage_WebSpider" && _target_x >= 5080) {
        _dest_x = clamp(_dest_x, 4976, max(4976, 5456 - _cam_w));
        _dest_y = clamp(_dest_y, 1856, max(1856, 2144 - _cam_h));
        return [_dest_x, _dest_y];
    }
    
    // Clamp to room boundaries
    _dest_x = clamp(_dest_x, 0, max(0, room_width - _cam_w));
    _dest_y = clamp(_dest_y, 0, max(0, room_height - _cam_h));
    
    return [_dest_x, _dest_y];
}
