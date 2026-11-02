if (instance_number(oGame) > 1) {
    instance_destroy();
    return;
}

// Authentic PlayStation 1 Display (320x240 native @ 4:3)
display_settings_init();
surface_resize(application_surface, VIEW_WIDTH, VIEW_HEIGHT);
display_set_gui_size(VIEW_WIDTH, VIEW_HEIGHT);
gpu_set_texfilter(false);

window_centered_timer = display_settings_is_web() ? 0 : 2;
global.osd_message = display_settings_is_web()
    ? "CLICK GAME TO PLAY | FULLSCREEN: PAGE BUTTON"
    : "WINDOWED | OPTIONS: DISPLAY | F3: SIZE | F4: FULLSCREEN";
global.osd_timer = 180;

global.current_char = CHAR_TYPE.X;
global.debug_overlay = false;
global.checkpoint_x = 64;
global.checkpoint_y = 368;
global.has_air_dash = false;
global.nz_dialogue_seen = false;
global.screen_fade_alpha = 0.0;
global.stage_ready = true;
global.pending_respawn = noone;
global.sky_jungle_briefing_pending = false;

if (!instance_exists(oInput)) instance_create_layer(0, 0, "Instances", oInput);
if (!instance_exists(oCamera)) instance_create_layer(0, 0, "Instances", oCamera);
if (!instance_exists(oUI_HUD)) instance_create_layer(0, 0, "Instances", oUI_HUD);
if (!instance_exists(oParallaxBackground)) instance_create_layer(0, 0, "Instances", oParallaxBackground);
