/// @desc Input Management & Buffering System

// Initialize global input state
function input_init() {
    global.input = {
        left: false,
        right: false,
        up: false,
        down: false,
        
        left_pressed: false,
        right_pressed: false,
        up_pressed: false,
        down_pressed: false,
        
        jump: false,
        jump_pressed: false,
        jump_released: false,
        jump_buffer: 0,
        
        dash: false,
        dash_pressed: false,
        dash_buffer: 0,
        
        shoot: false,
        shoot_pressed: false,
        shoot_released: false,
        shoot_buffer: 0,
        
        special: false,
        special_pressed: false,
        
        tab_pressed: false,
        debug_pressed: false,
        restart_pressed: false
    };
    global.input_locked = false;
}

// Update input states every frame
function input_update() {
    if (!variable_global_exists("input")) {
        input_init();
    }
    
    // Keyboard inputs
    var _k_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
    var _k_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var _k_up    = keyboard_check(vk_up)    || keyboard_check(ord("W"));
    var _k_down  = keyboard_check(vk_down)  || keyboard_check(ord("S"));
    
    var _k_left_pressed  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
    var _k_right_pressed = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
    var _k_up_pressed    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
    var _k_down_pressed  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
    
    var _k_jump          = keyboard_check(ord("Z")) || keyboard_check(vk_space);
    var _k_jump_pressed  = keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_space);
    var _k_jump_released = keyboard_check_released(ord("Z")) || keyboard_check_released(vk_space);
    
    var _k_dash         = keyboard_check(ord("C")) || keyboard_check(vk_lshift) || keyboard_check(ord("K"));
    var _k_dash_pressed = keyboard_check_pressed(ord("C")) || keyboard_check_pressed(vk_lshift) || keyboard_check_pressed(ord("K"));
    
    var _k_shoot          = keyboard_check(ord("X")) || keyboard_check(ord("J"));
    var _k_shoot_pressed  = keyboard_check_pressed(ord("X")) || keyboard_check_pressed(ord("J"));
    var _k_shoot_released = keyboard_check_released(ord("X")) || keyboard_check_released(ord("J"));
    
    var _k_special         = keyboard_check(ord("V")) || keyboard_check(ord("L"));
    var _k_special_pressed = keyboard_check_pressed(ord("V")) || keyboard_check_pressed(ord("L"));
    
    // Gamepad (controller 0) support
    var _pad = 0;
    var _gp_connected = gamepad_is_connected(_pad);
    var _gp_left  = false;
    var _gp_right = false;
    var _gp_up    = false;
    var _gp_down  = false;
    var _gp_left_pressed  = false;
    var _gp_right_pressed = false;
    var _gp_up_pressed    = false;
    var _gp_down_pressed  = false;
    var _gp_jump  = false;
    var _gp_jump_pressed  = false;
    var _gp_jump_released = false;
    var _gp_dash  = false;
    var _gp_dash_pressed  = false;
    var _gp_shoot = false;
    var _gp_shoot_pressed = false;
    var _gp_shoot_released = false;
    var _gp_special = false;
    var _gp_special_pressed = false;
    var _gp_tab = false;
    
    if (_gp_connected) {
        var _axis_x = gamepad_axis_value(_pad, gp_axislh);
        var _axis_y = gamepad_axis_value(_pad, gp_axislv);
        
        _gp_left  = gamepad_button_check(_pad, gp_padl) || (_axis_x < -0.4);
        _gp_right = gamepad_button_check(_pad, gp_padr) || (_axis_x > 0.4);
        _gp_up    = gamepad_button_check(_pad, gp_padu) || (_axis_y < -0.4);
        _gp_down  = gamepad_button_check(_pad, gp_padd) || (_axis_y > 0.4);
        
        _gp_left_pressed  = gamepad_button_check_pressed(_pad, gp_padl);
        _gp_right_pressed = gamepad_button_check_pressed(_pad, gp_padr);
        _gp_up_pressed    = gamepad_button_check_pressed(_pad, gp_padu);
        _gp_down_pressed  = gamepad_button_check_pressed(_pad, gp_padd);
        
        _gp_jump          = gamepad_button_check(_pad, gp_face1);
        _gp_jump_pressed  = gamepad_button_check_pressed(_pad, gp_face1);
        _gp_jump_released = gamepad_button_check_released(_pad, gp_face1);
        
        _gp_dash         = gamepad_button_check(_pad, gp_face2) || gamepad_button_check(_pad, gp_shoulderl) || gamepad_button_check(_pad, gp_shoulderr);
        _gp_dash_pressed = gamepad_button_check_pressed(_pad, gp_face2) || gamepad_button_check_pressed(_pad, gp_shoulderl) || gamepad_button_check_pressed(_pad, gp_shoulderr);
        
        _gp_shoot          = gamepad_button_check(_pad, gp_face3);
        _gp_shoot_pressed  = gamepad_button_check_pressed(_pad, gp_face3);
        _gp_shoot_released = gamepad_button_check_released(_pad, gp_face3);
        
        _gp_special         = gamepad_button_check(_pad, gp_face4);
        _gp_special_pressed = gamepad_button_check_pressed(_pad, gp_face4);
        
        _gp_tab = gamepad_button_check_pressed(_pad, gp_select);
    }
    
    // Combine inputs
    global.input.left  = _k_left  || _gp_left;
    global.input.right = _k_right || _gp_right;
    global.input.up    = _k_up    || _gp_up;
    global.input.down  = _k_down  || _gp_down;
    
    global.input.left_pressed  = _k_left_pressed  || _gp_left_pressed;
    global.input.right_pressed = _k_right_pressed || _gp_right_pressed;
    global.input.up_pressed    = _k_up_pressed    || _gp_up_pressed;
    global.input.down_pressed  = _k_down_pressed  || _gp_down_pressed;
    
    global.input.jump          = _k_jump          || _gp_jump;
    global.input.jump_pressed  = _k_jump_pressed  || _gp_jump_pressed;
    global.input.jump_released = _k_jump_released || _gp_jump_released;
    
    global.input.dash         = _k_dash         || _gp_dash;
    global.input.dash_pressed = _k_dash_pressed || _gp_dash_pressed;
    
    global.input.shoot          = _k_shoot          || _gp_shoot;
    global.input.shoot_pressed  = _k_shoot_pressed  || _gp_shoot_pressed;
    global.input.shoot_released = _k_shoot_released || _gp_shoot_released;
    
    global.input.special         = _k_special         || _gp_special;
    global.input.special_pressed = _k_special_pressed || _gp_special_pressed;
    
    global.input.tab_pressed     = keyboard_check_pressed(vk_tab) || _gp_tab;
    global.input.debug_pressed   = keyboard_check_pressed(vk_f1);
    global.input.restart_pressed = keyboard_check_pressed(ord("R"));
    
    // Update input buffers
    if (global.input.jump_pressed) {
        global.input.jump_buffer = BUFFER_FRAMES;
    } else if (global.input.jump_buffer > 0) {
        global.input.jump_buffer--;
    }
    
    if (global.input.dash_pressed) {
        global.input.dash_buffer = BUFFER_FRAMES;
    } else if (global.input.dash_buffer > 0) {
        global.input.dash_buffer--;
    }
    
    if (global.input.shoot_pressed) {
        global.input.shoot_buffer = BUFFER_FRAMES;
    } else if (global.input.shoot_buffer > 0) {
        global.input.shoot_buffer--;
    }
    
    // Suppress action inputs when global.input_locked is active (dialogue, cutscenes)
    if (variable_global_exists("input_locked") && global.input_locked) {
        global.input.left = false;
        global.input.right = false;
        global.input.up = false;
        global.input.down = false;
        global.input.left_pressed = false;
        global.input.right_pressed = false;
        global.input.up_pressed = false;
        global.input.down_pressed = false;
        global.input.jump = false;
        global.input.jump_pressed = false;
        global.input.jump_released = false;
        global.input.jump_buffer = 0;
        global.input.dash = false;
        global.input.dash_pressed = false;
        global.input.dash_buffer = 0;
        global.input.shoot = false;
        global.input.shoot_pressed = false;
        global.input.shoot_released = false;
        global.input.shoot_buffer = 0;
        global.input.special = false;
        global.input.special_pressed = false;
    }
    
    // Web Bound Debuff (Section 4): Movement locked, button mashing breaks free faster
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        if (_p != noone && variable_instance_exists(_p, "is_web_bound") && _p.is_web_bound) {
            // Button mashing to break free
            if (global.input.left_pressed || global.input.right_pressed || global.input.jump_pressed || global.input.dash_pressed) {
                _p.web_bound_timer -= 5;
                if (object_exists(oFX_HitSpark)) {
                    instance_create_layer(_p.x, _p.y - 12, "Instances", oFX_HitSpark);
                }
            }
            
            // Suppress movement while bound in web
            global.input.left = false;
            global.input.right = false;
            global.input.dash = false;
            global.input.dash_pressed = false;
            global.input.jump = false;
            global.input.jump_pressed = false;
        }
    }
}

