// Execute audio routing logic with browser availability and actual fallback failures.
// This harness does not replace a GameMaker compile or a browser playthrough.
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
let web = true, available = false, playing = false, plays = [], streams = [];
const c = {
    global: {}, noone: -4,
    display_settings_is_web: () => web,
    audio_system_is_available: () => available,
    is_struct: x => x !== null && typeof x === 'object',
    is_string: x => typeof x === 'string',
    variable_global_exists: key => key in c.global,
    audio_exists: id => Number.isInteger(id) && id >= 0,
    audio_is_playing: () => playing,
    audio_stop_all: () => { playing = false; },
    audio_master_gain: () => {}, audio_sound_gain: () => {},
    audio_play_sound: id => { plays.push(id); playing = true; return 100 + id; },
    asset_get_index: name => name === 'title' ? 1 : -1,
    file_exists: () => true,
    filename_ext: name => /\.[^.]*$/.exec(name)?.[0] ?? '',
    string_lower: s => s.toLowerCase(),
    audio_create_stream: name => { streams.push(name); return 20; },
    audio_destroy_stream: () => {},
};
vm.createContext(c);
vm.runInContext(fs.readFileSync('MegamanZ/scripts/scr_audio/scr_audio.gml', 'utf8'), c);
c.music_play_track(1, 'title.mp3');
assert.deepEqual(plays, [], 'Locked browser audio must not be played');
c.music_play_track(2, 'stage.mp3');
available = true;
c.music_update_pending();
assert.deepEqual(plays, [2], 'Unlock plays the latest requested room track');
c.music_update_pending();
assert.deepEqual(plays, [2], 'Pending track is consumed once');
available = false;
c.music_play_track(3);
c.music_stop_all();
available = true;
c.music_update_pending();
assert.deepEqual(plays, [2], 'Stopping clears an obsolete pending track');
c.music_play_track(-1, 'missing.ogg');
assert.deepEqual(streams, [], 'Web must not use external-stream fallback');
web = false;
c.music_play_track(-1, 'missing.mp3');
assert.deepEqual(streams, [], 'MP3 is not valid for external OGG streaming');
c.music_play_track(-1, 'fallback.OGG');
assert.deepEqual(streams, ['fallback.OGG'], 'Desktop OGG fallback remains supported');
c.music_play_track('title');
assert.equal(plays.at(-1), 1, 'Dynamic Sound Asset lookup remains supported');

// Exercise the real title transition and delayed start, including skipping while locked.
web = true; available = false;
Object.assign(c, {
    TITLE_INTRO_STATE: { TEXT: 1, IMPACT: 2, LOGO: 3, BACKGROUND: 4, MENU: 5 },
    intro_audio_pending: true, bgm_handle: -4,
    sound_beam: 10, sound_bgm: 11,
    play_title_sound: id => { plays.push(id); return id; },
});
const create = fs.readFileSync('MegamanZ/objects/obj_title_intro/Create_0.gml', 'utf8');
vm.runInContext('enter_title_state = function' + create.split('enter_title_state = function')[1]
    .split('start_new_game = function')[0], c);
c.enter_title_state(c.TITLE_INTRO_STATE.MENU);
assert.equal(c.intro_audio_pending, true, 'Skipping while locked must retain title music');
const step = fs.readFileSync('MegamanZ/objects/obj_title_intro/Step_0.gml', 'utf8');
const titleAudio = step.slice(step.indexOf('if (intro_audio_pending &&'), step.indexOf('flash_alpha = max(0, flash_alpha - 0.08)'));
const count = plays.length;
vm.runInContext(titleAudio, c);
assert.equal(plays.length, count, 'Title waits for the browser audio context');
available = true;
vm.runInContext(titleAudio, c);
assert.deepEqual(plays.slice(count), [11], 'A skipped intro starts BGM without replaying its beam effect');
vm.runInContext(titleAudio, c);
assert.equal(plays.length, count + 1, 'Title BGM starts once');
console.log('PASS: browser audio unlock, latest-track routing, cancellation and platform-safe fallback.');
