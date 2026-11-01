/// @desc Timeline completion signal; input lock ownership stays with controller.
ready_frame++;
if (ready_frame >= ready_duration) {
    global.stage_ready = true;
    instance_destroy();
    exit;
}
