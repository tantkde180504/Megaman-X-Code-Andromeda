/// @desc Boss Health Bar HUD (Mega Man X Vertical Energy Bar)
if (is_dead || (variable_instance_exists(id, "state") && (state == NZ_STATE.SLEEP || state == NZ_STATE.INTRO || state == NZ_STATE.DIALOGUE))) return;

if (intro_done) hp_display = hp;
hud_x4_draw_boss(hp_display, max_hp, X4_HUD_STYLE.BOSS_X, flash_timer > 0);
