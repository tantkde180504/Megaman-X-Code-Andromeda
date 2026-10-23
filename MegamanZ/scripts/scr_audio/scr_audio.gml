/// @desc Megaman X / Megaman Z Audio & BGM Manager

global.current_bgm = noone;
global.current_bgm_asset = noone;
global.current_bgm_buffer = noone;
global.current_bgm_buffer_sound = noone;
global.current_bgm_stream = noone;

/// @desc Universal BGM playback with fail-safes (Asset -> Dynamic -> Datafile Stream)
function music_play_track(_asset_id, _datafile_name = "") {
    // If this specific music is already playing, do not interrupt
    if (global.current_bgm != noone && audio_is_playing(global.current_bgm)) {
        if (variable_global_exists("current_bgm_asset") && global.current_bgm_asset == _asset_id) {
            return;
        }
    }
    
    // Stop previous tracks safely
    music_stop_all();
    audio_master_gain(1.0);
    global.current_bgm_asset = _asset_id;
    
    // Tier 1: Direct GameMaker Sound Asset identifier reference
    try {
        if (_asset_id != -1 && audio_exists(_asset_id)) {
            global.current_bgm = audio_play_sound(_asset_id, 100, true);
            if (global.current_bgm != -1 && audio_is_playing(global.current_bgm)) {
                audio_sound_gain(global.current_bgm, 1.0, 0);
                return;
            }
        }
    } catch (_ex1) {
        // Fall through to Tier 2
    }
    
    // Tier 2: Dynamic lookup via asset_get_index if given as string
    try {
        if (is_string(_asset_id)) {
            var _snd = asset_get_index(_asset_id);
            if (_snd != -1 && audio_exists(_snd)) {
                global.current_bgm = audio_play_sound(_snd, 100, true);
                if (global.current_bgm != -1 && audio_is_playing(global.current_bgm)) {
                    audio_sound_gain(global.current_bgm, 1.0, 0);
                    return;
                }
            }
        }
    } catch (_ex2) {
        // Fall through to Tier 3
    }
    
    // Tier 3: Direct Included File (datafiles) audio stream
    if (_datafile_name != "" && file_exists(_datafile_name)) {
        try {
            global.current_bgm_stream = audio_create_stream(_datafile_name);
            if (global.current_bgm_stream != -1) {
                global.current_bgm = audio_play_sound(global.current_bgm_stream, 100, true);
                if (global.current_bgm != -1) {
                    audio_sound_gain(global.current_bgm, 1.0, 0);
                    return;
                }
            }
        } catch (_ex3) {
            // Stream creation failed
        }
    }
}

/// @desc Play Title Screen Theme
function music_play_title() {
    music_play_track(snd_bgm_title, "snd_bgm_title.mp3");
}

/// @desc Play Player Select & Stage Select Theme
function music_play_player_select() {
    music_play_track(snd_bgm_player_select, "snd_bgm_player_select.mp3");
}

/// @desc Play Web Spider Stage Theme
function music_play_web_spider() {
    music_play_track(snd_bgm_web_spider, "snd_bgm_web_spider.mp3");
}

/// @desc Play Nightmare Zero Boss Battle Theme (Looping)
function music_play_boss_nightmare_zero() {
    music_play_track(snd_boss_nightmare_zero, "snd_boss_nightmare_zero.mp3");
}

/// @desc Stop Nightmare Zero Boss Battle Theme (Optional fade-out in ms)
function music_stop_boss_nightmare_zero(_fade_ms = 0) {
    if (global.current_bgm != noone) {
        if (audio_is_playing(global.current_bgm)) {
            if (_fade_ms > 0) {
                audio_sound_gain(global.current_bgm, 0.0, _fade_ms);
            } else {
                audio_stop_sound(global.current_bgm);
                global.current_bgm = noone;
                global.current_bgm_asset = noone;
            }
        }
    }
    try {
        if (audio_exists(snd_boss_nightmare_zero) && audio_is_playing(snd_boss_nightmare_zero)) {
            if (_fade_ms > 0) {
                audio_sound_gain(snd_boss_nightmare_zero, 0.0, _fade_ms);
            } else {
                audio_stop_sound(snd_boss_nightmare_zero);
            }
        }
    } catch (_ex) {}
}

/// @desc Stop all active audio & cleanup memory buffers / streams
function music_stop_all() {
    audio_stop_all();
    if (global.current_bgm_buffer_sound != noone && global.current_bgm_buffer_sound != -1) {
        audio_free_buffer_sound(global.current_bgm_buffer_sound);
        global.current_bgm_buffer_sound = noone;
    }
    if (global.current_bgm_buffer != noone && global.current_bgm_buffer != -1) {
        buffer_delete(global.current_bgm_buffer);
        global.current_bgm_buffer = noone;
    }
    if (global.current_bgm_stream != noone && global.current_bgm_stream != -1) {
        audio_destroy_stream(global.current_bgm_stream);
        global.current_bgm_stream = noone;
    }
    global.current_bgm = noone;
    global.current_bgm_asset = noone;
}
