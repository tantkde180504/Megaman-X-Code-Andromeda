/// @desc Mini Spider Minion Draw
var _f = 0;
if (spider_state == SPIDER_MINION_STATE.AIR) {
    _f = 13 + (floor(anim_timer) % 5);
} else if (spider_state == SPIDER_MINION_STATE.FLOOR) {
    _f = floor(anim_timer) % 8;
} else {
    _f = 8 + (floor(anim_timer) % 5);
}

draw_web_spider_part(13, _f, x, y, facing, false);
