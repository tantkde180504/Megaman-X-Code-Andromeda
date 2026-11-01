// Logic harness for the GML display module; GameMaker compilation checks GML APIs.
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
let desktop = [1920, 1080], fullscreen = true, size = [], saved;
const c = {
    global: {}, VIEW_WIDTH: 320, VIEW_HEIGHT: 240,
    max: Math.max, min: Math.min, floor: Math.floor,
    clamp: (v, lo, hi) => Math.max(lo, Math.min(hi, v)), string: String,
    display_get_width: () => desktop[0], display_get_height: () => desktop[1],
    window_set_fullscreen: value => fullscreen = value,
    window_get_fullscreen: () => fullscreen,
    window_set_size: (w, h) => size = [w, h],
    oGame: {window_centered_timer: 0},
    file_exists: () => saved !== undefined,
    ini_open: () => {}, ini_close: () => {},
    ini_read_real: () => saved,
    ini_write_real: (section, key, value) => saved = value,
};
vm.createContext(c);
vm.runInContext(fs.readFileSync('MegamanZ/scripts/scr_display_settings/scr_display_settings.gml', 'utf8').replace(/\bmod\b/g, '%'), c);
c.display_settings_init();
assert.equal(fullscreen, false, 'Startup must leave fullscreen');
assert.deepEqual(size, [960, 720]);
assert.equal(c.oGame.window_centered_timer, 2);
c.display_settings_toggle_fullscreen();
assert.equal(fullscreen, true);
c.display_settings_toggle_fullscreen();
assert.equal(fullscreen, false);
c.display_settings_apply(true, 4);
c.display_settings_cycle_size();
assert.equal(fullscreen, false, 'Changing size selects windowed mode');
assert.deepEqual(size, [320, 240], 'Largest size wraps to smallest');
c.display_settings_cycle_size(-1);
assert.deepEqual(size, [1280, 960], 'Smallest size wraps to largest');
c.display_settings_apply(true, 2);
c.display_settings_init();
assert.equal(fullscreen, false, 'Restart must be windowed after playing fullscreen');
assert.deepEqual(size, [640, 480], 'Window size survives restart');
desktop = [1280, 720]; saved = 99;
c.display_settings_init();
assert.deepEqual(size, [640, 480], 'Window and borders must fit the desktop');
saved = -9;c.display_settings_init();
assert.deepEqual(size, [320, 240], 'Invalid saved size is clamped');
const windowsOptions = fs.readFileSync('MegamanZ/options/windows/options_windows.yy', 'utf8');
assert.match(windowsOptions, /"option_windows_start_fullscreen"\s*:\s*false/);

// Exercise the actual Options event through mode, size, keyboard and back navigation.
let pressed = new Set();
Object.assign(c, {
    state: 1, TITLE_INTRO_STATE: {MENU: 1},
    TITLE_MENU_STATE: {PRESS_START: 0, OPTIONS: 1, CONTROLS: 2, SETTINGS: 3},
    menu_state: 3, settings_row: 1,
    vk_enter: 13, vk_escape: 27, vk_space: 32, vk_up: 38, vk_down: 40,
    vk_left: 37, vk_right: 39, vk_delete: 46,
    ord: text => text.charCodeAt(0),
    keyboard_check_pressed: key => pressed.has(key),
    gamepad_is_connected: () => false,
    play_title_sound: () => {}, sound_move: 1, sound_confirm: 2,
    controls_capturing: false, controls_row: 0, controls_slot: 0,
    controls_message: '', array_length: a => a.length,
});
c.global.key_actions = Array(9).fill('action');
const menuCode = fs.readFileSync('MegamanZ/objects/obj_title_intro/Step_0.gml', 'utf8')
    .split('// Bam Enter/Space/Z/X')[0].replace(/\bmod\b/g, '%').replace(/\bexit;/g, 'return;');
vm.runInContext(`function menu_step() { ${menuCode} }`, c);
pressed = new Set([13]);c.menu_step();
assert.equal(fullscreen, true, 'Screen Mode row toggles fullscreen');
c.settings_row = 2;pressed = new Set([39]);c.menu_step();
assert.equal(fullscreen, false, 'Window Size row returns to windowed');
assert.deepEqual(size, [640, 480]);
c.settings_row = 0;pressed = new Set([13]);c.menu_step();
assert.equal(c.menu_state, 2, 'Keyboard row opens rebinding');
pressed = new Set([27]);c.menu_step();
assert.equal(c.menu_state, 3, 'Keyboard back returns to Options');
c.menu_step();
assert.equal(c.menu_state, 1, 'Options back returns to title menu');
console.log('PASS: windowed startup, mode/size Options navigation, keyboard submenu, persistence, desktop bounds and launch options.');
