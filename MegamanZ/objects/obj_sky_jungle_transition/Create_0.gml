/// @desc Persistent loading overlay; survives only the Sky -> Jungle handoff.
phase = 0; // Fade out, loading, fade in.
phase_tick = 0;
fade_alpha = 0;
depth = -20000;
global.input_locked = true;
global.stage_ready = false;
music_stop_all();
