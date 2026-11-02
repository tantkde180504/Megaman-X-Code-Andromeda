/// @desc Character monologue, queued until READY and teleport-in finish.
if (instance_number(obj_stage_briefing) > 1) {
    instance_destroy();
    exit;
}
active = false;
owns_stage_lock = false;
previous_input_lock = global.input_locked;
global.input_locked = true;
depth = -11000;
anim_timer = 0;
page_index = 0;
visible_chars = 0;
advance_cooldown = 8;
panel_frame = 0;
closing = false;
close_frame = 0;
pages = [];
speaker_is_zero = (global.current_char == CHAR_TYPE.ZERO);
speaker_name = speaker_is_zero ? "ZERO" : "X";
player_object = speaker_is_zero ? oPlayerZero : oPlayerX;
var _lines = [
    "Mavericks are attacking the city!",
    "I'm picking up a strange signal from the top of Sky Tower. I'll head up and investigate.",
    "Zero is investigating the forest. I'll handle things here in the city."
];
if (speaker_is_zero) {
    _lines = [
        "X... How are things going over there in the city?",
        "That signal from Sky Tower worries me. Be careful, X.",
        "I'd better find out what's happening in this jungle."
    ];
}
for (var _line = 0; _line < array_length(_lines); _line++) {
    var _wrapped = ps1_text_pages(_lines[_line], 240, 2, MMX_FONT.MEDIUM);
    for (var _page = 0; _page < array_length(_wrapped); _page++) {
        array_push(pages, _wrapped[_page]);
    }
}
