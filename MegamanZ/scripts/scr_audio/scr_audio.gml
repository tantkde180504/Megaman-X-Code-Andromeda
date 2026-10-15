/// @desc Megaman X / Megaman Z Audio & BGM Manager

global.current_bgm = noone;
global.current_bgm_stream = noone;

/// @desc Play Nightmare Zero Boss Battle Theme (Looping)
function music_play_boss_nightmare_zero() {
    // If music is already playing, do not interrupt
    if (global.current_bgm != noone) {
        if (audio_is_playing(global.current_bgm)) return;
    }
    
    // Stop any existing tracks
    music_stop_all();
    
    // 1. Try playing via built-in GameMaker Sound asset
    var _snd_asset = asset_get_index("snd_boss_nightmare_zero");
    if (_snd_asset != -1 && audio_exists(_snd_asset)) {
        global.current_bgm = audio_play_sound(_snd_asset, 100, true);
        audio_sound_gain(global.current_bgm, 1.0, 0);
        return;
    }
    
    // 2. Robust fallback: Load and stream from Included Files if audio asset is unbaked
    var _file = "snd_boss_nightmare_zero.mp3";
    if (file_exists(_file)) {
        global.current_bgm_stream = audio_create_stream(_file);
        if (global.current_bgm_stream != -1) {
            global.current_bgm = audio_play_sound(global.current_bgm_stream, 100, true);
            audio_sound_gain(global.current_bgm, 1.0, 0);
        }
    }
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
            }
        }
    }
    var _snd_asset = asset_get_index("snd_boss_nightmare_zero");
    if (_snd_asset != -1 && audio_is_playing(_snd_asset)) {
        if (_fade_ms > 0) {
            audio_sound_gain(_snd_asset, 0.0, _fade_ms);
        } else {
            audio_stop_sound(_snd_asset);
        }
    }
}

/// @desc Stop all active audio & cleanup streams
function music_stop_all() {
    audio_stop_all();
    if (global.current_bgm_stream != noone && global.current_bgm_stream != -1) {
        audio_destroy_stream(global.current_bgm_stream);
        global.current_bgm_stream = noone;
    }
    global.current_bgm = noone;
}
