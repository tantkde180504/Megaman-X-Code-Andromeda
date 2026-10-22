/// @desc READY overlay. One Step = one frame at 60 FPS.
if (instance_number(obj_ready_intro) > 1) {
    instance_destroy();
    exit;
}

ready_sprite = asset_get_index("spr_ready_intro");
if (!sprite_exists(ready_sprite)) ready_sprite = asset_get_index("ReadyIntro");

// Fail open if the sheet is missing, so the controller can resume play.
if (!sprite_exists(ready_sprite)) {
    show_debug_message("obj_ready_intro: missing spr_ready_intro / ReadyIntro");
    global.stage_ready = true;
    instance_destroy();
    exit;
}

ready_frame = -1; // First Step displays frame 0; finish at frame 100.
global.stage_ready = false;
gui_scale = 1;
auto_gui_scale = true; // Set false after creation to use a manual integer scale.
depth = -10000;

// Source rectangles: left, top, width, height.
ready_main = [7, 20, 182, 31];
ready_flash_1 = [5, 55, 184, 31];
ready_flash_2 = [0, 89, 184, 31];
ready_shadow = [197, 22, 182, 31];
ready_bars = [230, 244, 316, 87];

draw_ready_part = function(_rect, _cx, _cy, _sx, _sy, _alpha) {
    draw_sprite_part_ext(ready_sprite, 0,
        _rect[0], _rect[1], _rect[2], _rect[3],
        round(_cx - _rect[2] * _sx * 0.5),
        round(_cy - _rect[3] * _sy * 0.5),
        _sx, _sy, c_white, _alpha);
};
