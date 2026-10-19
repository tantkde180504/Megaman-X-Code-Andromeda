/// @desc Giant Web Network Step
anim_timer += 0.2;
pulse_timer++;

if (build_phase < 1.0) {
    build_phase = min(1.0, build_phase + (1.0 / 60.0));
} else {
    is_active = true;
}
