/// @desc Web Spider Boss Health Bar & WARNING HUD
if (state == WS_STATE.DEATH) {
    // Hiệu ứng chớp trắng toàn màn hình khi đại nổ kết liễu
    if (death_timer <= 28 && death_timer > 6) {
        var _w_alpha = clamp((death_timer - 6) / 22.0, 0, 1.0) * 0.85;
        draw_set_color(c_white);
        draw_set_alpha(_w_alpha);
        draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
        draw_set_alpha(1.0);
    }
    if (death_timer < 30) return;
}

// Shared red WARNING sequence before the health fill.
if (state == WS_STATE.INTRO && warning_timer > 0) {
    boss_warning_draw(warning_timer);
    return;
}

if (intro_done) hp_display = hp;
hud_x4_draw_boss(hp_display, hp_max, X4_HUD_STYLE.BOSS_R, flash_timer > 0);
