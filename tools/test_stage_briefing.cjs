// Runs the actual GML event bodies with mocked engine I/O and the real bitmap-font wrapping.
const fs = require('node:fs'), vm = require('node:vm'), assert = require('node:assert/strict');
const read = name => fs.readFileSync(`MegamanZ/objects/obj_stage_briefing/${name}.gml`, 'utf8');
function scenario(character = 0) {
    let ready = true, playerExists = true, pressed = new Set(), destroyed = false;
    const player = {state: 1, hp_current: 16, hsp: 2, vsp: 0, iframes: 0};
    const c = {
        global: {stage_ready: false, input_locked: false, current_char: character}, id: 10,
        CHAR_TYPE: {X: 0, ZERO: 1},
        obj_stage_briefing: 10, obj_ready_intro: 11, oPlayerX: 12, oPlayerZero: 14,
        PLAYER_STATE: {INTRO: 1, IDLE: 2, DEATH: 3},
        vk_enter: 13, vk_escape: 27,
        max: Math.max, min: Math.min,
        array_length: a => a.length, array_push: (a, v) => a.push(v),
        array_create: (n, v) => Array(n).fill(v), ord: s => s.charCodeAt(0),
        string_length: s => s.length, string_char_at: (s, n) => s[n - 1],
        string_copy: (s, start, count) => s.slice(start - 1, start - 1 + count),
        string_split: (s, sep) => s.split(sep),
        string_replace_all: (s, a, b) => s.split(a).join(b),
        instance_number: () => 1,
        instance_exists: type => type === 11 ? ready : playerExists,
        instance_find: () => player,
        variable_instance_exists: (id, key) => key in c,
        keyboard_check_pressed: key => pressed.has(key),
        input_keyboard_action: () => pressed.has(90),
        gamepad_is_connected: () => false,
        instance_destroy: () => {destroyed = true; c.cleanup();},
    };
    vm.createContext(c);
    let font = fs.readFileSync('MegamanZ/scripts/scr_mmx_font/scr_mmx_font.gml', 'utf8');
    font = font.replace(/enum MMX_FONT \{[\s\S]*?\}/, 'const MMX_FONT = {SMALL:0, MEDIUM:1, LARGE:2};');
    vm.runInContext(font, c);
    for (const [name, event] of [['create', 'Create_0'], ['step', 'Step_0'], ['cleanup', 'Destroy_0']]) {
        vm.runInContext(`function ${name}() { ${read(event).replace(/\bexit;/g, 'return;')} }`, c);
    }
    c.create();
    return {c, player, tick: () => c.step(), press: keys => pressed = new Set(keys),
        readyDone: () => {ready = false; c.global.stage_ready = true;},
        removePlayer: () => playerExists = false, destroyed: () => destroyed};
}
let s = scenario();
assert.equal(s.c.global.input_locked, true);
for (let i = 0; i < 110; i++) {s.press([13]); s.tick();}
assert.equal(s.c.active, false, 'Briefing waits for READY despite confirm spam');
s.readyDone();s.tick();
assert.equal(s.c.active, false, 'Briefing also waits for teleport-in');
s.player.state = 2;s.press([]);s.tick();
assert.equal(s.c.active, true);
assert.equal(s.c.global.stage_ready, false, 'Enemies pause during dialogue');
assert.equal(s.c.visible_chars,0,'Text waits for the frame to unfold');
assert.equal(s.player.iframes,0,'Dialogue must not make X blink or disappear');
for (const page of s.c.pages) {
    const lines = s.c.ps1_text_lines(page, 240, 1);
    assert.ok(lines.length <= 2);
    for (const line of lines) assert.ok(s.c.string_mmx_width(line, 1) <= 240);
}
let count = 0;
while (!s.destroyed() && count++ < 1000) {s.press([90]);s.tick();}
assert.ok(s.destroyed(), 'Configured jump button can finish all dialogue pages');
assert.equal(s.c.global.input_locked, false);
assert.equal(s.c.global.stage_ready, true);
s = scenario();s.readyDone();s.player.state=2;
for (let i=0;i<24;i++) s.tick();
s.press([27]);s.tick();
assert.equal(s.c.closing,true,'Escape starts the closing animation');
assert.equal(s.c.global.input_locked,true,'Input remains locked through the close animation');
for(let i=0;i<10;i++)s.tick();
assert.ok(s.destroyed(), 'Closing completes and releases the dialogue locks');
assert.equal(s.c.global.stage_ready,true);
s = scenario();s.removePlayer();s.tick();
assert.ok(s.destroyed());
assert.equal(s.c.global.input_locked,false);
assert.equal(s.c.global.stage_ready,false, 'Pending cleanup must not end READY early');
const roomStart = fs.readFileSync('MegamanZ/objects/oGame/Other_4.gml', 'utf8');
const spawnHook = roomStart.slice(roomStart.indexOf('// Queue X\'s city briefing'));
assert.ok(spawnHook.startsWith('// Queue'), 'Room entry must contain the briefing hook');
for (const [room, character, respawn, exists, pending, expected] of [
    ['rStage_Sky', 0, false, false, false, 1],
    ['rStage_Sky', 0, true, false, false, 0],
    ['rStage_Sky', 1, false, false, false, 0],
    ['rStage_WebSpider', 0, false, false, false, 0],
    ['rStage_Sky', 0, false, true, false, 0],
    ['rStage_WebSpider', 1, false, false, true, 1],
    ['rStage_WebSpider', 1, true, false, true, 0],
    ['rStage_WebSpider', 1, false, false, false, 0],
    ['rStage_WebSpider', 0, false, false, true, 0],
]) {
    let spawned = 0;
    const entry = {room, rStage_WebSpider:'rStage_WebSpider', _respawning:respawn,
        global:{current_char:character, sky_jungle_briefing_pending:pending},
        CHAR_TYPE:{X:0,ZERO:1}, obj_stage_briefing:10, room_get_name:r=>r,
        instance_exists:()=>exists, instance_create_layer:()=>spawned++};
    vm.runInNewContext(spawnHook, entry);
    assert.equal(spawned, expected, 'Briefing follows fresh Sky entry or the one-time Zero handoff');
    assert.equal(entry.global.sky_jungle_briefing_pending, false);
}
s = scenario(1);
assert.equal(s.c.speaker_name, 'ZERO');
assert.equal(s.c.player_object, s.c.oPlayerZero);
assert(s.c.pages.join(' ').includes('X...'));
for (let i = 0; i < 160; i++) s.tick();
assert.equal(s.c.active, false, 'Zero also waits for READY');
s.readyDone(); s.tick();
assert.equal(s.c.active, false, 'Zero also waits for teleport-in');
s.player.state = 2;
count = 0;
while (!s.destroyed() && count++ < 1000) {s.press([90]);s.tick();}
assert(s.destroyed(), 'Zero monologue ends and restores control');
assert.equal(s.c.global.input_locked, false);
assert.equal(s.c.global.stage_ready, true);
for (const page of s.c.pages) {
    const lines = s.c.ps1_text_lines(page, 240, 1);
    assert(lines.length <= 2);
    for (const line of lines) assert(s.c.string_mmx_width(line, 1) <= 240);
}
console.log('PASS: READY/teleport sequencing, real-font page bounds, remapped advance, skip, completion and lock cleanup.');
