/// @desc Megaman X / Megaman Z Audio & BGM Manager

global.current_bgm = noone;
global.current_bgm_buffer = noone;
global.current_bgm_buffer_sound = noone;
global.current_bgm_stream = noone;

/// @desc Play Nightmare Zero Boss Battle Theme (Looping)
function music_play_boss_nightmare_zero() {
    // If music is already playing, do not interrupt
    if (global.current_bgm != noone) {
        if (audio_is_playing(global.current_bgm)) return;
    }
    
    // Stop any existing tracks
    music_stop_all();
    audio_master_gain(1.0);
    
    // Tier 1: Direct GameMaker Sound Asset identifier reference
    // Writing `snd_boss_nightmare_zero` directly guarantees GameMaker's compiler
    // will link and NEVER strip this asset from the final build!
    try {
        if (audio_exists(snd_boss_nightmare_zero)) {
            global.current_bgm = audio_play_sound(snd_boss_nightmare_zero, 100, true);
            if (global.current_bgm != -1 && audio_is_playing(global.current_bgm)) {
                audio_sound_gain(global.current_bgm, 1.0, 0);
                return;
            }
        }
    } catch (_ex1) {
        // Fall through to Tier 2
    }
    
    // Tier 2: Dynamic lookup via asset_get_index
    try {
        var _snd_asset = asset_get_index("snd_boss_nightmare_zero");
        if (_snd_asset != -1 && audio_exists(_snd_asset)) {
            global.current_bgm = audio_play_sound(_snd_asset, 100, true);
            if (global.current_bgm != -1 && audio_is_playing(global.current_bgm)) {
                audio_sound_gain(global.current_bgm, 1.0, 0);
                return;
            }
        }
    } catch (_ex2) {
        // Fall through to Tier 3
    }
    
    // Tier 3: Direct WAV buffer playback from Included Files (datafiles)
    // 100% engine-native, loads raw PCM samples without requiring asset compilation
    var _wav_file = "snd_boss_nightmare_zero.wav";
    if (file_exists(_wav_file)) {
        try {
            var _buff = buffer_load(_wav_file);
            if (_buff != -1) {
                var _buf_size = buffer_get_size(_buff);
                // Standard WAV header is 44 bytes, 16-bit stereo = 4 bytes per sample
                var _pcm_offset = 44;
                var _samples = max(0, (_buf_size - _pcm_offset) div 4);
                var _snd_buf = audio_create_buffer_sound(_buff, buffer_s16, 44100, _pcm_offset, _samples, audio_stereo);
                if (_snd_buf != -1) {
                    global.current_bgm_buffer = _buff;
                    global.current_bgm_buffer_sound = _snd_buf;
                    global.current_bgm = audio_play_sound(_snd_buf, 100, true);
                    audio_sound_gain(global.current_bgm, 1.0, 0);
                    return;
                }
            }
        } catch (_ex3) {
            // Buffer creation failed
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
}
