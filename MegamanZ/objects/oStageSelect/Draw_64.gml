/// @desc Native PS1 layout: all panels and labels fit inside 320x240.
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
if (sprite_exists(StageSelectBkGrd)) {
    draw_sprite_part(StageSelectBkGrd, 0, 5, clamp(scroll_y, 5, scroll_max),
        VIEW_WIDTH, VIEW_HEIGHT, 0, 0);
}
if (state == STAGE_SELECT_STATE.ELEVATOR_SCROLL) {
    draw_set_color(c_aqua);
    draw_set_alpha(0.25);
    for (var _i = 0; _i < 6; _i++) {
        var _x = 24 + _i * 52;
        var _y = (anim_timer * 12 + _i * 40) mod VIEW_HEIGHT;
        draw_line(_x, _y, _x, min(VIEW_HEIGHT - 1, _y + 24));
    }
    draw_set_alpha(1);
    ps1_draw_panel(8, 8, 304, 24);
    ps1_draw_centered(160, 12, "HUNTER BASE - DESCENDING", 288, c_aqua);
    if ((anim_timer div 15) mod 2 == 0)
        ps1_draw_centered(160, 220, "ENTER: FAST DESCENT", 296, c_yellow);
} else {
    if (sprite_exists(StageX)) {
        var _box = r1_boxes[0];
        if (x_anim_state == "normal") _box = r1_boxes[floor(x_frame_idx) mod 6];
        else if (x_anim_state == "boss_map") _box = r2_boss_boxes[floor(x_frame_idx) mod 3];
        else if (x_anim_state == "launch") _box = r2_launch_box;
        draw_sprite_part(StageX, 0, _box[0], _box[1], _box[2], _box[3], x_pos, y_base - _box[3]);
        if (x_anim_state == "launch") {
            draw_set_alpha(teleport_beam_alpha * 0.7);
            draw_set_color(c_aqua);
            draw_rectangle(x_pos - 4, 0, x_pos + 62, 145, false);
            draw_set_color(c_white);
            draw_rectangle(x_pos + 16, 0, x_pos + 24, 145, false);
            draw_set_alpha(1);
        }
    }
    ps1_draw_panel(96, 8, 216, 136);
    if (state == STAGE_SELECT_STATE.BRIEFING) {
        ps1_draw_centered(204, 16, "TACTICAL FEED", 200, c_aqua);
        for (var _b = 0; _b < 18; _b++) {
            var _height = dialogue_is_typing ? 4 + 16 * abs(sin(anim_timer * 0.18 + _b * 0.35)) : 3;
            draw_set_color(c_aqua);
            draw_rectangle(108 + _b * 10, 72 - _height, 113 + _b * 10, 72 + _height, false);
        }
        ps1_draw_text(104, 104, "MAVERICKS DETECTED\nPRIORITY: S-RANK", 200, 32, c_yellow);
    } else {
        ps1_draw_centered(204, 12, "STAGE SELECT", 200, c_aqua);
        for (var _s = 0; _s < stage_count; _s++) {
            var _y = 36 + _s * 22;
            var _selected = _s == selected_stage;
            if (_selected) {
                draw_set_color(make_color_rgb(12, 68, 128));
                draw_rectangle(101, _y - 1, 306, _y + 18, false);
            }
            ps1_draw_text(106, _y, stages[_s].name, 196, 16, _selected ? c_yellow : c_white);
        }
        ps1_draw_text(104, 126, stages[selected_stage].code, 200, 16, c_aqua);
    }

    ps1_draw_panel(8, 152, 304, 72, c_white);
    if (state == STAGE_SELECT_STATE.BRIEFING) {
        var _dialogue = dialogue_sentences[dialogue_idx];
        ps1_draw_text(16, 156, _dialogue.speaker, 288, 16, c_yellow);
        ps1_draw_text(16, 176, _dialogue.text, 288, 32, c_white, floor(dialogue_char_idx));
        ps1_draw_centered(160, 224, dialogue_is_typing ? "ENTER: SHOW ALL" : "ENTER: NEXT", 304, c_aqua);
    } else {
        var _stage = stages[selected_stage];
        if (state == STAGE_SELECT_STATE.LAUNCH) {
            ps1_draw_text(16, 156, "TARGET CONFIRMED", 288, 16, c_aqua);
            ps1_draw_text(16, 176, _stage.name, 288, 16, c_yellow);
            ps1_draw_text(16, 198, "COMMENCING MISSION", 288, 16);
        } else {
            ps1_draw_text(16, 156, _stage.boss, 288, 16, c_red);
            ps1_draw_text(16, 172, _stage.danger, 288, 16, c_yellow);
            ps1_draw_text(16, 190, _stage.desc, 288, 32);
            ps1_draw_centered(160, 224, "ARROWS: SELECT Z:LAUNCH", 304, c_aqua);
        }
    }
}
if (flash_alpha > 0) {
    draw_set_color(c_white);
    draw_set_alpha(flash_alpha);
    draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
}
if (fade_alpha > 0) {
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
}
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
