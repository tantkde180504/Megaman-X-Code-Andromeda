global.input_locked = true;
phase_tick++;
switch (phase) {
    case 0:
        fade_alpha = min(1, phase_tick / 24);
        if (phase_tick >= 24) {
            phase = 1;
            phase_tick = 0;
        }
        break;
    case 1:
        // Leave the loading card visible for a full second before changing rooms.
        if (phase_tick >= 60) {
            global.current_char = CHAR_TYPE.ZERO;
            global.checkpoint_x = 64;
            global.checkpoint_y = 368;
            global.pending_respawn = noone;
            global.sky_jungle_briefing_pending = true;
            phase = 2;
            phase_tick = 0;
            room_goto(rStage_WebSpider);
        }
        break;
    case 2:
        fade_alpha = max(0, 1 - phase_tick / 24);
        if (phase_tick >= 24) {
            // The queued briefing owns the lock until its final page closes.
            if (!instance_exists(obj_stage_briefing)) global.input_locked = false;
            instance_destroy();
        }
        break;
}
