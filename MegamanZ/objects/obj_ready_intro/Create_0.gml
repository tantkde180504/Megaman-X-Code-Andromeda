/// @desc READY overlay. One Step = one frame at 60 FPS.
if (instance_number(obj_ready_intro) > 1) {
    instance_destroy();
    exit;
}

ready_sprite = spr_ready_intro;
sprite_index = spr_ready_intro;
image_speed = 0;

ready_frame = -1;
ready_duration = 138; // Reference: about 2.3 seconds at 60 FPS.
teleport_start_frame = 126; // The beam enters as READY splits away.
global.stage_ready = false;
gui_scale = 1;
auto_gui_scale = true; // Set false after creation to use a manual integer scale.
depth = -10000;
