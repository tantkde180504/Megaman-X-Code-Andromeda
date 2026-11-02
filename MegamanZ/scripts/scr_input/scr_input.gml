/// @desc Input Management & Buffering System

// Three keyboard slots per action preserve the original alternate controls.
function input_bindings_defaults() {
    return [
        [vk_left, ord("A"), 0], [vk_right, ord("D"), 0],
        [vk_up, ord("W"), 0], [vk_down, ord("S"), 0],
        [ord("Z"), vk_space, 0], [ord("C"), vk_lshift, ord("K")],
        [ord("X"), ord("J"), 0], [ord("V"), ord("L"), 0],
        [vk_tab, 0, 0]
    ];
}

function input_binding_key_valid(_key) {
    // Enter/Escape always remain available for menu navigation; F-keys are debug/display.
    return is_real(_key) && _key == floor(_key) && _key > 7 && _key <= 255
        && _key != vk_enter && _key != vk_escape
        && !(_key >= vk_f1 && _key <= vk_f12);
}

function input_bindings_init() {
    if (variable_global_exists("key_bindings")) return;
    global.key_actions = ["left", "right", "up", "down", "jump", "dash", "shoot", "special", "switch"];
    global.key_labels = ["LEFT", "RIGHT", "UP", "DOWN", "JUMP", "DASH", "ATTACK", "SPECIAL", "SWITCH"];
    global.key_bindings = input_bindings_defaults();
    if (!file_exists("controls.ini")) return;

    var _loaded = input_bindings_defaults();
    var _seen = [];
    var _valid = true;
    ini_open("controls.ini");
    for (var _a = 0; _a < array_length(_loaded); _a++) {
        var _has_key = false;
        for (var _s = 0; _s < 3; _s++) {
            var _key = ini_read_real(global.key_actions[_a], string(_s), _loaded[_a][_s]);
            _loaded[_a][_s] = _key;
            if (_key == 0) continue;
            if (!input_binding_key_valid(_key) || array_contains(_seen, _key)) _valid = false;
            array_push(_seen, _key);
            _has_key = true;
        }
        if (!_has_key) _valid = false;
    }
    ini_close();
    // A damaged/incompatible config cannot leave an action unreachable.
    if (_valid) global.key_bindings = _loaded;
}

function input_bindings_save() {
    ini_open("controls.ini");
    for (var _a = 0; _a < array_length(global.key_actions); _a++) {
        for (var _s = 0; _s < 3; _s++) {
            ini_write_real(global.key_actions[_a], string(_s), global.key_bindings[_a][_s]);
        }
    }
    ini_close();
}

// mode: 0 = held, 1 = pressed, 2 = released.
function input_keyboard_action(_action, _mode = 0) {
    var _keys = global.key_bindings[_action];
    for (var _s = 0; _s < 3; _s++) {
        var _key = _keys[_s];
        if (_key == 0) continue;
        if (_mode == 0 && keyboard_check(_key)) return true;
        if (_mode == 1 && keyboard_check_pressed(_key)) return true;
        if (_mode == 2 && keyboard_check_released(_key)) return true;
    }
    return false;
}

function input_key_is_bound(_key) {
    input_bindings_init();
    for (var _a = 0; _a < array_length(global.key_bindings); _a++) {
        if (array_contains(global.key_bindings[_a], _key)) return true;
    }
    return false;
}

function input_debug_key_pressed(_key) {
    if (instance_exists(obj_stage_briefing)) return false;
    if (instance_exists(obj_sky_jungle_transition)) return false;
    return keyboard_check_pressed(_key) && !input_key_is_bound(_key);
}

function input_key_name(_key) {
    switch (_key) {
        case 0: return "-";
        case vk_left: return "LEFT";
        case vk_right: return "RIGHT";
        case vk_up: return "UP";
        case vk_down: return "DOWN";
        case vk_space: return "SPACE";
        case vk_tab: return "TAB";
        case vk_shift: return "SHIFT";
        case vk_lshift: return "LSHIFT";
        case vk_rshift: return "RSHIFT";
        case vk_control: return "CTRL";
        case vk_lcontrol: return "LCTRL";
        case vk_rcontrol: return "RCTRL";
        case vk_alt: return "ALT";
        case vk_lalt: return "LALT";
        case vk_ralt: return "RALT";
        case vk_backspace: return "BKSP";
        case vk_delete: return "DEL";
        case vk_insert: return "INS";
        case vk_home: return "HOME";
        case vk_end: return "END";
        case vk_pageup: return "PGUP";
        case vk_pagedown: return "PGDN";
    }
    if (_key >= ord("A") && _key <= ord("Z")) return chr(_key);
    if (_key >= ord("0") && _key <= ord("9")) return chr(_key);
    return "KEY " + string(_key);
}

// Initialize global input state
function input_init() {
    input_bindings_init();
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
    var _k_left  = input_keyboard_action(0);
    var _k_right = input_keyboard_action(1);
    var _k_up    = input_keyboard_action(2);
    var _k_down  = input_keyboard_action(3);
    
    var _k_left_pressed  = input_keyboard_action(0, 1);
    var _k_right_pressed = input_keyboard_action(1, 1);
    var _k_up_pressed    = input_keyboard_action(2, 1);
    var _k_down_pressed  = input_keyboard_action(3, 1);
    
    var _k_jump          = input_keyboard_action(4);
    var _k_jump_pressed  = input_keyboard_action(4, 1);
    var _k_jump_released = input_keyboard_action(4, 2);
    
    var _k_dash         = input_keyboard_action(5);
    var _k_dash_pressed = input_keyboard_action(5, 1);
    
    var _k_shoot          = input_keyboard_action(6);
    var _k_shoot_pressed  = input_keyboard_action(6, 1);
    var _k_shoot_released = input_keyboard_action(6, 2);
    
    var _k_special         = input_keyboard_action(7);
    var _k_special_pressed = input_keyboard_action(7, 1);
    
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
    
    global.input.tab_pressed     = input_keyboard_action(8, 1) || _gp_tab;
    global.input.debug_pressed   = keyboard_check_pressed(vk_f1);
    global.input.restart_pressed = input_debug_key_pressed(ord("R"));
    
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
    var _boss_warning = boss_warning_is_active();
    if ((variable_global_exists("input_locked") && global.input_locked) || _boss_warning) {
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
        if (_boss_warning || instance_exists(obj_stage_briefing)) {
            global.input.tab_pressed = false;
            global.input.restart_pressed = false;
        }
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

