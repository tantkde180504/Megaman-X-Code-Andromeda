/// @desc X4/X5-inspired red WARNING title over the stage before boss intros.
#macro BOSS_WARNING_FRAMES 360

// READY owns the intro until its instance is gone and its completion flag agrees.
function boss_warning_can_start() {
    if (instance_exists(obj_ready_intro)) return false;
    return !variable_global_exists("stage_ready") || global.stage_ready;
}

function boss_warning_is_active() {
    if (!boss_warning_can_start()) return false;
    var _active = false;
    with (obj_nightmare_zero) {
        if (state == NZ_STATE.INTRO && warning_timer > 0) _active = true;
    }
    // Includes oBoss_WebSpider, which inherits this implementation.
    with (obj_boss_web_spider) {
        if (state == WS_STATE.INTRO && warning_timer > 0) _active = true;
    }
    return _active;
}

// Called from Step, never Draw: sound and timing do not depend on rendering.
function boss_warning_tick(_remaining) {
    if (!boss_warning_can_start()) return _remaining;
    var _elapsed = BOSS_WARNING_FRAMES - _remaining;
    if (_elapsed >= 0 && _elapsed < 300 && _elapsed mod 60 == 0) {
        if (audio_exists(snd_boss_warning)) audio_play_sound(snd_boss_warning, 90, false);
    }
    return max(0, _remaining - 1);
}

function boss_warning_quad(_x, _y, _sx, _sy, _points) {
    draw_primitive_begin(pr_trianglelist);
    var _order = [0, 1, 2, 0, 2, 3];
    for (var _i = 0; _i < 6; _i++) {
        var _v = _order[_i] * 2;
        draw_vertex(_x + _points[_v] * _sx, _y + _points[_v + 1] * _sy);
    }
    draw_primitive_end();
}

// Angular strokes, authored in a 24x36 grid. I uses a narrower advance.
function boss_warning_glyphs() {
    return [
        [ // W
            [0,0, 5,0, 9,29, 5,36],
            [5,36, 11,0, 15,0, 10,36],
            [11,0, 15,0, 19,29, 15,36],
            [15,36, 21,0, 25,0, 20,36]
        ],
        [ // A
            [0,36, 10,0, 15,0, 5,36],
            [10,0, 15,0, 25,36, 19,36],
            [6,23, 19,23, 20,27, 5,27]
        ],
        [ // R
            [0,0, 5,0, 5,36, 0,36],
            [5,0, 17,0, 22,4, 5,4],
            [17,0, 23,5, 23,16, 18,20],
            [5,17, 19,17, 23,21, 5,21],
            [10,20, 16,20, 25,36, 18,36]
        ],
        [ // N
            [0,0, 5,0, 5,36, 0,36],
            [0,0, 6,0, 24,36, 18,36],
            [19,0, 24,0, 24,36, 19,36]
        ],
        [ // I
            [0,0, 6,0, 6,36, 0,36]
        ],
        [ // N
            [0,0, 5,0, 5,36, 0,36],
            [0,0, 6,0, 24,36, 18,36],
            [19,0, 24,0, 24,36, 19,36]
        ],
        [ // G
            [0,5, 6,0, 6,36, 0,31],
            [5,0, 24,0, 20,4, 5,4],
            [5,32, 24,32, 24,36, 5,36],
            [19,18, 24,18, 24,36, 19,36],
            [13,18, 24,18, 24,22, 13,22]
        ]
    ];
}

function boss_warning_draw(_remaining) {
    if (_remaining <= 0 || !boss_warning_can_start()) return;
    var _old_colour = draw_get_colour();
    var _old_alpha = draw_get_alpha();
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    var _sx = _w / 320;
    var _sy = _h / 240;
    var _elapsed = clamp(BOSS_WARNING_FRAMES - _remaining, 0, BOSS_WARNING_FRAMES);

    // Draw only the warning lettering so the stage remains visible underneath.
    draw_set_alpha(1);

    static _glyphs = boss_warning_glyphs();
    static _advances = [28, 28, 28, 27, 9, 27, 25];
    var _word_width = 172;
    var _left = (_w - _word_width * _sx) * 0.5;
    var _top = 65 * _sy;
    // Reveal left to right, then repeat the red alarm pulse; withdraw at the end.
    var _reveal = clamp(_elapsed / 54, 0, 1);
    var _exit = clamp((_elapsed - 300) / 60, 0, 1);
    var _visible_width = _word_width * _reveal * (1 - _exit);
    var _pulse_frame = _elapsed mod 60;
    var _brightness = _elapsed < 54 ? 1 : (_pulse_frame < 38 ? 1 : 0.20);
    draw_set_colour(make_colour_rgb(round(240 * _brightness), 0, 0));

    var _cursor = 0;
    for (var _letter = 0; _letter < 7; _letter++) {
        var _advance = _advances[_letter];
        var _amount = clamp((_visible_width - _cursor) / max(1, _advance - 3), 0, 1);
        if (_amount > 0) {
            var _strokes = _glyphs[_letter];
            for (var _stroke = 0; _stroke < array_length(_strokes); _stroke++) {
                boss_warning_quad(_left + _cursor * _sx, _top,
                    _sx * _amount, _sy, _strokes[_stroke]);
            }
        }
        _cursor += _advance;
    }
    // Thin, continuous red underline grows/shrinks with the letter reveal.
    if (_visible_width > 0) {
        draw_rectangle(_left, _top + 39 * _sy,
            _left + _visible_width * _sx, _top + 41 * _sy, false);
    }
    draw_set_colour(_old_colour);
    draw_set_alpha(_old_alpha);
}
