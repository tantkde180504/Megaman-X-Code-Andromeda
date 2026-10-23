if (instance_number(oGame) > 1) {
    instance_destroy();
    return;
}

// Authentic PlayStation 1 Display (320x240 native @ 4:3)
window_scale = 3; // 3x scale: 960x720 (4:3)
window_set_size(VIEW_WIDTH * window_scale, VIEW_HEIGHT * window_scale);
surface_resize(application_surface, VIEW_WIDTH, VIEW_HEIGHT);
display_set_gui_size(VIEW_WIDTH, VIEW_HEIGHT);
gpu_set_texfilter(false);

window_centered_timer = 2;
global.crt_filter = true; // CRT scanlines on by default (F2 to toggle)
global.osd_message = "PS1 MODE (4:3) | F2: CRT SCANLINES | F3: WINDOW SCALE | F4: FULLSCREEN";
global.osd_timer = 180;

global.current_char = CHAR_TYPE.X;
global.debug_overlay = false;
global.checkpoint_x = 64;
global.checkpoint_y = 440;
global.has_air_dash = false;
global.nz_dialogue_seen = false;
global.screen_fade_alpha = 0.0;
global.stage_ready = true;

if (!instance_exists(oInput)) instance_create_layer(0, 0, "Instances", oInput);
if (!instance_exists(oCamera)) instance_create_layer(0, 0, "Instances", oCamera);
if (!instance_exists(oUI_HUD)) instance_create_layer(0, 0, "Instances", oUI_HUD);
if (!instance_exists(oParallaxBackground)) instance_create_layer(0, 0, "Instances", oParallaxBackground);
