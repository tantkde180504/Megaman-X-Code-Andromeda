/// @desc Ensure stage_ready is restored if overlay is destroyed
// A rejected duplicate must not complete the READY instance still playing.
if (instance_number(obj_ready_intro) <= 1) global.stage_ready = true;
