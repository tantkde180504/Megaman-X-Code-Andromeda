// The boss WARNING owns the whole screen until the spawn sequence begins.
if (boss_warning_is_active()) return;
if (instance_exists(obj_stage_briefing) && obj_stage_briefing.active) return;
if (!instance_exists(oPlayer)) return;
var _p = instance_find(oPlayer, 0);
draw_set_alpha(1);
var _hud_style = global.current_char == CHAR_TYPE.ZERO ? X4_HUD_STYLE.ZERO : X4_HUD_STYLE.X;
hud_x4_draw_bar(8, 12, _p.hp_current, _p.hp_max, _hud_style, clamp(round(_p.hp_max), 1, 32));
var _title = "TRAINING";
if (room == rStage_Intro) _title = "RUINED HIGHWAY";
else if (room == rStage_Sky) _title = "SKY";
else if (room == rStage_WebSpider) _title = "DEEP JUNGLE";
else if (room == rBoss_NightmareZero) _title = "NIGHTMARE AREA";
// Reserve both screen edges for the player and boss health bars.
ps1_draw_centered(160, 2, _title, 240, c_yellow);
var _air_dash = _p.has_air_dash || global.has_air_dash;
var _double_jump = _p.has_double_jump;
var _ability = _air_dash && _double_jump ? "AIR DASH / D-JUMP"
    : (_air_dash ? "AIR DASH" : (_double_jump ? "DOUBLE JUMP" : ""));
ps1_draw_text(40, 22, _ability, 236, 16, c_aqua);
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, VIEW_HEIGHT - 18, VIEW_WIDTH, VIEW_HEIGHT, false);
draw_set_alpha(1);
ps1_draw_centered(160, VIEW_HEIGHT - 17, "Z:JUMP X:ATK C:DASH TAB:SWITCH", 312, c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

