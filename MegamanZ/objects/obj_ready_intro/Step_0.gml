/// @desc Timeline completion signal; input lock ownership stays with controller.
ready_frame++;
if (ready_frame >= 100) {
    global.stage_ready = true;
    instance_destroy();
    exit;
}
