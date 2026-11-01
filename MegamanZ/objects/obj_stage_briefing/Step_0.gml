/// @desc Wait for entry animations, then read the briefing without gameplay input.
if (!instance_exists(oPlayerX)) {
    instance_destroy();
    exit;
}
var _player = instance_find(oPlayerX, 0);
if (_player.state == PLAYER_STATE.DEATH || _player.hp_current <= 0) {
    instance_destroy();
    exit;
}
global.input_locked = true;
if (!active) {
    if (instance_exists(obj_ready_intro) || !global.stage_ready
        || _player.state == PLAYER_STATE.INTRO) exit;
    active = true;
    owns_stage_lock = true;
    global.stage_ready = false; // Freeze enemies through their existing READY guard.
    advance_cooldown = 8;
}
_player.hsp = 0;
_player.vsp = 0;
_player.state = PLAYER_STATE.IDLE;
_player.iframes = max(_player.iframes, 2);
anim_timer++;
var _text = pages[page_index];
visible_chars = min(string_length(_text), visible_chars + 0.8);
if (advance_cooldown > 0) {
    advance_cooldown--;
    exit;
}
var _advance = keyboard_check_pressed(vk_enter) || input_keyboard_action(4, 1);
var _skip = keyboard_check_pressed(vk_escape);
for (var _pad = 0; _pad < 4; _pad++) {
    if (gamepad_is_connected(_pad)) {
        _advance = _advance || gamepad_button_check_pressed(_pad, gp_face1)
            || gamepad_button_check_pressed(_pad, gp_start);
    }
}
if (_skip) {
    instance_destroy();
    exit;
}
if (_advance) {
    if (visible_chars < string_length(_text)) {
        visible_chars = string_length(_text);
    } else if (page_index + 1 < array_length(pages)) {
        page_index++;
        visible_chars = 0;
    } else {
        instance_destroy();
        exit;
    }
    advance_cooldown = 8;
}
