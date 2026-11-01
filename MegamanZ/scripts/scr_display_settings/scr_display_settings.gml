/// @desc Windowed startup and shared display controls for Options/F3/F4.
function display_settings_max_scale() {
    // Leave space for the title bar and taskbar on smaller desktops.
    return max(1, min(4, floor((display_get_width() - 32) / VIEW_WIDTH),
        floor((display_get_height() - 80) / VIEW_HEIGHT)));
}

function display_settings_apply(_fullscreen, _scale) {
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
    display_settings_apply(!window_get_fullscreen(), global.display_window_scale);
}

function display_settings_size_label() {
    return string(VIEW_WIDTH * global.display_window_scale) + " X "
        + string(VIEW_HEIGHT * global.display_window_scale);
}
