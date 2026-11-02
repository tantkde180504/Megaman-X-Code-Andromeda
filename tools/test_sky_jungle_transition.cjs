// Executes the portal/loading GML events with room and rendering I/O mocked.
const fs = require('node:fs'), vm = require('node:vm'), assert = require('node:assert/strict');
const read = path => fs.readFileSync(`MegamanZ/${path}`, 'utf8');
const compile = code => code.replace(/\bexit;/g, 'return;')
    .replace(/(\w+) div (\d+)/g, 'Math.floor($1 / $2)').replace(/\bmod\b/g, '%');
let starts = 0, changes = 0, destroyed = false, hasBriefing = false;
const player = {x: 4776, y: 368, hp_current: 16, grounded: true, state: 1, hsp: 2.5, vsp: 0};
const c = vm.createContext({
    room: 1, rStage_Sky: 1, rStage_WebSpider: 2, x: 4776, y: 368,
    oPlayer: 3, obj_sky_jungle_transition: 4, obj_stage_briefing: 5,
    PLAYER_STATE: {IDLE: 0, RUN: 1, DASH: 2, DEATH: 3}, CHAR_TYPE: {X: 0, ZERO: 1},
    global: {current_char: 0, stage_ready: true, input_locked: false, checkpoint_x: 4256, checkpoint_y: 1136},
    noone: -1, abs: Math.abs, min: Math.min, max: Math.max,
    instance_exists: type => type === 3 || (type === 5 && hasBriefing),
    instance_find: () => player, instance_create_layer: () => starts++,
    music_stop_all() {}, instance_destroy: () => destroyed = true,
    room_goto: room => { changes++; c.room = room; },
    draw_get_colour: () => 123, draw_get_alpha: () => 0.4,
    draw_set_colour() {}, draw_set_alpha() {}, draw_rectangle() {},
    display_get_gui_width: () => 320, display_get_gui_height: () => 240,
    c_black: 0, c_aqua: 1, c_white: 2, string_repeat: (s, n) => s.repeat(n),
    ps1_draw_centered: (x, y, text) => labels.push(text),
});
const labels = [];
for (const [name, path] of [
    ['portalCreate', 'objects/oTrigger_Teleporter/Create_0.gml'],
    ['portalStep', 'objects/oTrigger_Teleporter/Step_0.gml'],
    ['create', 'objects/obj_sky_jungle_transition/Create_0.gml'],
    ['step', 'objects/obj_sky_jungle_transition/Step_0.gml'],
    ['draw', 'objects/obj_sky_jungle_transition/Draw_64.gml'],
]) vm.runInContext(`function ${name}() { ${compile(read(path))} }`, c);
c.portalCreate();
player.x = 4700; c.portalStep(); assert.equal(starts, 0, 'Must reach the portal');
player.x = 4776; player.grounded = false; c.portalStep(); assert.equal(starts, 0);
player.grounded = true; player.state = 3; c.portalStep(); assert.equal(starts, 0, 'Dead players cannot transition');
player.state = 1; c.global.input_locked = true; c.portalStep(); assert.equal(starts, 0);
c.global.input_locked = false; c.portalStep(); c.portalStep();
assert.equal(starts, 1, 'Portal starts exactly once');
assert.equal(player.hsp, 0);
c.create();
assert.equal(c.global.input_locked, true); assert.equal(c.global.stage_ready, false);
for (let i = 0; i < 24; i++) c.step();
assert.equal(c.phase, 1); assert.equal(changes, 0); assert.equal(c.fade_alpha, 1);
c.draw(); assert(labels.includes('JUNGLE')); assert(labels.some(text => text.startsWith('LOADING')));
for (let i = 0; i < 59; i++) c.step();
assert.equal(changes, 0, 'Loading remains visible before the room change');
c.step();
assert.equal(changes, 1); assert.equal(c.room, c.rStage_WebSpider);
assert.equal(c.global.current_char, c.CHAR_TYPE.ZERO);
assert.equal(c.global.checkpoint_x, 64); assert.equal(c.global.checkpoint_y, 368);
assert.equal(c.global.pending_respawn, c.noone); assert.equal(c.global.sky_jungle_briefing_pending, true);
// Execute the actual room-entry story hook, which creates the Zero monologue.
const roomStart = read('objects/oGame/Other_4.gml');
const hook = roomStart.slice(roomStart.indexOf('// Queue X\'s city briefing'));
c._respawning = false; c.room_get_name = r => r === 2 ? 'rStage_WebSpider' : 'rStage_Sky';
c.instance_create_layer = () => {hasBriefing = true;};
vm.runInContext(hook, c);
assert(hasBriefing); assert.equal(c.global.sky_jungle_briefing_pending, false);
for (let i = 0; i < 24; i++) c.step();
assert(destroyed); assert.equal(c.fade_alpha, 0); assert.equal(changes, 1);
assert.equal(c.global.input_locked, true, 'Loading must leave control locked for the monologue');

// New resources and events must be reachable from the GameMaker manifest.
const json = path => JSON.parse(read(path).replace(/,\s*([}\]])/g, '$1'));
const project = json('MegamanZ.yyp');
assert(project.resources.some(r => r.id.name === 'obj_sky_jungle_transition'));
for (const object of ['oTrigger_Teleporter', 'obj_sky_jungle_transition']) {
    const meta = json(`objects/${object}/${object}.yy`);
    for (const event of meta.eventList) {
        const type = {0: 'Create', 3: 'Step', 8: 'Draw'}[event.eventType];
        assert(fs.existsSync(`MegamanZ/objects/${object}/${type}_${event.eventNum}.gml`));
    }
}
console.log('PASS: portal guards, one-shot activation, visible loading, Zero/Jungle checkpoint, monologue handoff and resource registration.');
