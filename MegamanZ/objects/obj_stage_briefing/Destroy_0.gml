/// @desc Release only the locks owned by this briefing (including room changes).
if (variable_instance_exists(id, "previous_input_lock")) {
    global.input_locked = previous_input_lock;
}
if (variable_instance_exists(id, "owns_stage_lock") && owns_stage_lock) {
    global.stage_ready = true;
}
