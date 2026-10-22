if (instance_number(oGame) > 1) {
    instance_destroy();
    return;
}

window_set_size(VIEW_WIDTH * 2, VIEW_HEIGHT * 2);
surface_resize(application_surface, VIEW_WIDTH, VIEW_HEIGHT);
display_set_gui_size(VIEW_WIDTH, VIEW_HEIGHT);
gpu_set_texfilter(false);

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
