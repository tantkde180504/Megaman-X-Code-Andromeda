/// @desc Frame-Accurate Sub-Pixel Physics & Collision Engine

function player_physics_init() {
    hsp = 0;
    vsp = 0;
    x_subpixel = 0;
    y_subpixel = 0;
    
    facing = 1;              // 1 = Right, -1 = Left
    grounded = false;
    touching_wall = 0;       // -1 = Left wall, 1 = Right wall, 0 = None
    
    coyote_timer = 0;
    dash_timer = 0;
    dash_dir = 1;
    wall_jump_timer = 0;
    wall_slide_speed = WALL_SLIDE_SPEED;
    drop_through_timer = 0;
    
    // Phase 2: Abilities & Gimmicks
    has_air_dash = false;
    air_dash_used = false;
    in_water = false;
    on_ice = false;
    in_web = false;
}

function player_is_solid_at(_check_x, _check_y) {
    // Normal Solid
    if (place_meeting(_check_x, _check_y, oSolid)) return true;
    
    // Ice Surface
    if (object_exists(oIceSurface) && place_meeting(_check_x, _check_y, oIceSurface)) return true;
    
    // Closed Boss Gate
    if (object_exists(oTrigger_BossGate)) {
        var _gate = instance_place(_check_x, _check_y, oTrigger_BossGate);
        if (_gate != noone && (_gate.gate_state == GATE_STATE.CLOSED || _gate.gate_state == GATE_STATE.LOCKED)) {
            return true;
        }
    }
    
    return false;
}

function player_handle_movement_and_collision() {
    // ----------------------------------------------------
    // 1. Environmental Gimmick Checks
    // ----------------------------------------------------
    in_water = object_exists(oWater) && place_meeting(x, y, oWater);
    in_web = object_exists(oWebTrap) && place_meeting(x, y, oWebTrap);
    on_ice = object_exists(oIceSurface) && place_meeting(x, y + 1, oIceSurface);
    
    if (drop_through_timer > 0) {
        drop_through_timer--;
    }
    
    // ----------------------------------------------------
    // 2. Sub-pixel accumulator
    // ----------------------------------------------------
    x_subpixel += hsp;
    y_subpixel += vsp;
    
    var _hsp_int = round(x_subpixel);
    x_subpixel -= _hsp_int;
    
    var _vsp_int = round(y_subpixel);
    y_subpixel -= _vsp_int;
    
    // ----------------------------------------------------
    // 3. Horizontal Collision Step-by-Step with Slope Handling
    // ----------------------------------------------------
    repeat (abs(_hsp_int)) {
        var _step = sign(_hsp_int);
        
        // 1. Gặp vật cản phía trước: Kiểm tra leo dốc (Slope Climb / Step-Up)
        if (player_is_solid_at(x + _step, y)) {
            var _climbed = false;
            // Kiểm tra tối đa 8 pixel chiều cao (dốc hoặc bậc nhỏ)
            for (var _sub = 1; _sub <= 8; _sub++) {
                if (!player_is_solid_at(x + _step, y - _sub)) {
                    x += _step;
                    y -= _sub;
                    _climbed = true;
                    break;
                }
            }
            if (!_climbed) {
                hsp = 0;
                x_subpixel = 0;
                break;
            }
        } else {
            // 2. Không gặp vật cản: Kiểm tra xuống dốc bám sàn (Slope Descent / Snap-Down)
            var _descended = false;
            if (grounded && !player_is_solid_at(x + _step, y + 1)) {
                for (var _sub = 1; _sub <= 8; _sub++) {
                    if (player_is_solid_at(x + _step, y + _sub + 1)) {
                        x += _step;
                        y += _sub;
                        _descended = true;
                        break;
                    }
                }
            }
            if (!_descended) {
                x += _step;
            }
        }
    }
    
    // ----------------------------------------------------
    // 4. Vertical Collision Step-by-Step
    // ----------------------------------------------------
    repeat (abs(_vsp_int)) {
        var _step = sign(_vsp_int);
        
        // Solid block collision
        if (player_is_solid_at(x, y + _step)) {
            vsp = 0;
            y_subpixel = 0;
            break;
        }
        
        // One-way platform & Falling platform collision (only when falling downwards)
        if (_step > 0 && drop_through_timer <= 0) {
            var _plat = instance_place(x, y + _step, oOneWayPlatform);
            if (_plat == noone && object_exists(oPlatform_Falling)) {
                _plat = instance_place(x, y + _step, oPlatform_Falling);
            }
            
            if (_plat != noone) {
                if (bbox_bottom <= _plat.bbox_top + 1) {
                    y = _plat.bbox_top - (bbox_bottom - y) - 1;
                    vsp = 0;
                    y_subpixel = 0;
                    break;
                }
            }
        }
        
        x += 0;
        y += _step;
    }
    
    // ----------------------------------------------------
    // 5. Environmental State Checks
    // ----------------------------------------------------
    // Check Grounded
    var _standing_on_solid = player_is_solid_at(x, y + 1);
    var _standing_on_plat = false;
    if (drop_through_timer <= 0) {
        var _plat_below = instance_place(x, y + 1, oOneWayPlatform);
        if (_plat_below == noone && object_exists(oPlatform_Falling)) {
            _plat_below = instance_place(x, y + 1, oPlatform_Falling);
        }
        if (_plat_below != noone && bbox_bottom <= _plat_below.bbox_top + 1) {
            _standing_on_plat = true;
        }
    }
    grounded = _standing_on_solid || _standing_on_plat;
    
    // Reset air dash when landing
    if (grounded) {
        air_dash_used = false;
    }
    
    // Check Touching Wall
    touching_wall = 0;
    if (player_is_solid_at(x - 1, y)) {
        touching_wall = -1;
    } else if (player_is_solid_at(x + 1, y)) {
        touching_wall = 1;
    }
}
