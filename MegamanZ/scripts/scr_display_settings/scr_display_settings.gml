/// @desc Windowed startup and shared display controls for Options/F3/F4.
function display_settings_is_web() {
    return os_browser != browser_not_a_browser || os_type == os_gxgames;
}

function display_settings_max_scale() {
    if (display_settings_is_web()) return 1;
    // Leave space for the title bar and taskbar on smaller desktops.
    return max(1, min(4, floor((display_get_width() - 32) / VIEW_WIDTH),
        floor((display_get_height() - 80) / VIEW_HEIGHT)));
}

function display_settings_apply(_fullscreen, _scale) {
    // The host page owns canvas sizing and user-gesture fullscreen on the web.
    if (display_settings_is_web()) {
        global.display_window_scale = 1;
        return;
    }
    global.display_window_scale = clamp(floor(_scale), 1, display_settings_max_scale());
    window_set_fullscreen(_fullscreen);
    if (!_fullscreen) {
        window_set_size(VIEW_WIDTH * global.display_window_scale,
            VIEW_HEIGHT * global.display_window_scale);
        // Resize/fullscreen changes settle before centering the window.
        with (oGame) window_centered_timer = 2;
    }
    ini_open("display.ini");
    ini_write_real("display", "window_scale", global.display_window_scale);
    ini_close();
}

function display_settings_init() {
    if (display_settings_is_web()) {
        global.display_window_scale = 1;
        return;
    }
    var _scale = 3;
    if (file_exists("display.ini")) {
        ini_open("display.ini");
        _scale = ini_read_real("display", "window_scale", 3);
        ini_close();
    }
    // Always launch windowed. Fullscreen is an explicit choice during play.
    display_settings_apply(false, _scale);
}

function display_settings_cycle_size(_direction = 1) {
    var _max = display_settings_max_scale();
    var _scale = ((global.display_window_scale - 1 + _direction + _max) mod _max) + 1;
    display_settings_apply(false, _scale);
}

function display_settings_toggle_fullscreen() {
    if (display_settings_is_web()) return;
    display_settings_apply(!window_get_fullscreen(), global.display_window_scale);
}

function display_settings_size_label() {
    if (display_settings_is_web()) return "AUTO FIT";
    return string(VIEW_WIDTH * global.display_window_scale) + " X "
        + string(VIEW_HEIGHT * global.display_window_scale);
}
