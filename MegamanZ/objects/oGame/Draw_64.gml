if (global.debug_overlay) {
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(VIEW_WIDTH - 150, 4, VIEW_WIDTH - 4, 115, false);
    draw_set_alpha(1.0);
    draw_set_color(c_yellow);
    draw_text(VIEW_WIDTH - 146, 6, "DEBUG OVERLAY (F1)");
    draw_set_color(c_white);
    draw_text(VIEW_WIDTH - 146, 20, "FPS: " + string(fps) + " (" + string(fps_real) + ")");
    var _c_name = (global.current_char == CHAR_TYPE.X) ? "X" : "ZERO";
    draw_text(VIEW_WIDTH - 146, 34, "Char: " + _c_name + " [TAB]");
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        var _state_names = ["IDLE", "RUN", "JUMP", "FALL", "DASH", "WALL_SLIDE", "WALL_JUMP", "LADDER", "HURT", "DEATH", "INTRO", "TELEPORT_OUT", "STAGE_CLEAR"];
        var _s_str = (_p.state < array_length(_state_names)) ? _state_names[_p.state] : string(_p.state);
        draw_text(VIEW_WIDTH - 146, 48, "State: " + _s_str);
        draw_text(VIEW_WIDTH - 146, 62, "Pos: " + string(round(_p.x)) + ", " + string(round(_p.y)));
        draw_text(VIEW_WIDTH - 146, 76, "Spd: " + string(_p.hsp) + ", " + string(_p.vsp));
        draw_text(VIEW_WIDTH - 146, 90, "Gnd: " + string(_p.grounded) + " | Wall: " + string(_p.touching_wall));
    }
}

// Fullscreen Black Screen Fade Overlay (Death, Respawn, Stage Transition)
if (variable_global_exists("screen_fade_alpha") && global.screen_fade_alpha > 0.0) {
    draw_set_alpha(global.screen_fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
    draw_set_alpha(1.0);
}

// Display notification (F3 window scale / F4 fullscreen).
if (variable_global_exists("osd_timer") && global.osd_timer > 0) {
    var _cx = VIEW_WIDTH * 0.5;
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    var _osd_rows = min(4, array_length(ps1_text_lines(global.osd_message, VIEW_WIDTH - 32)));
    draw_rectangle(8, 4, VIEW_WIDTH - 8, 12 + _osd_rows * 16, false);
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(255, 220, 60));
    ps1_draw_text(16, 8, global.osd_message, VIEW_WIDTH - 32, _osd_rows * 16,
        make_color_rgb(255, 220, 60));
    draw_set_halign(fa_left);
}
