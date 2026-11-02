// Exercise the real camera script and End Step with GameMaker I/O mocked.
const fs = require('node:fs'), vm = require('node:vm'), assert = require('node:assert/strict');
const read = path => fs.readFileSync(`MegamanZ/${path}`, 'utf8');
const player = {id: 100, x: 5000, y: 2032, state: 0};
let view;
const c = vm.createContext({
    VIEW_WIDTH: 320, VIEW_HEIGHT: 240, noone: -1,
    room: 'rStage_WebSpider', rStage_Sky: 'rStage_Sky', room_width: 5472, room_height: 2160,
    oPlayer: 1, view_camera: [0], PLAYER_STATE: {TELEPORT_OUT: 10},
    room_get_name: room => room, is_array: Array.isArray,
    clamp: (v, lo, hi) => Math.max(lo, Math.min(hi, v)),
    min: Math.min, max: Math.max, round: Math.round,
    lerp: (a, b, t) => a + (b - a) * t, random_range: (lo, hi) => hi,
    instance_exists: () => true, instance_find: () => player,
    camera_set_view_pos: (id, x, y) => {view = [x, y];},
});
c.oCamera = c;
vm.runInContext(read('scripts/scr_camera/scr_camera.gml'), c);
vm.runInContext(read('objects/oCamera/Create_0.gml'), c);
vm.runInContext(`function endStep() { ${read('objects/oCamera/Step_2.gml')} }`, c);
assert.equal(c.camera_get_boss_view(5000), -1, 'Corridor still follows normally');
c.endStep(); assert.equal(c.boss_arena_locked, false);
player.x = 5128; c.endStep();
assert.deepEqual(view, [5120, 1872], 'Entering the chamber immediately fixes the camera');
assert.equal(c.boss_arena_locked, true);
for (const x of [5096, 5128, 5250, 5424]) {
    for (const y of [1904, 1984, 2096]) {
        player.x = x; player.y = y;
        c.camera_shake(12, 20); c.endStep();
        assert.deepEqual(view, [5120, 1872], 'Movement, recoil near the door and shake cannot move the frame');
        assert.deepEqual(Array.from(c.camera_update_follow(0, x, y)), view);
    }
}
player.state = 10; c.endStep(); assert.deepEqual(view, [5120, 1872], 'Teleport-out retains the arena frame');
player.state = 0; player.x = 4950; player.y = 2032;
c.endStep();
assert.equal(c.boss_arena_locked, false, 'Returning to the corridor must release a stale arena lock');
assert.ok(player.x >= view[0] && player.x < view[0] + 320, 'Checkpoint player must be on screen immediately');
player.x = 5250; c.endStep();
player.id = 101; player.x = 4950; c.endStep();
assert.equal(c.boss_arena_locked, false, 'A respawned player cannot inherit another instance arena lock');
const roomStart = read('objects/oGame/Other_4.gml');
assert.match(roomStart, /oCamera\.boss_arena_locked = false;/);
vm.runInContext(roomStart.match(/oCamera\.boss_arena_locked = false;/)[0], c);
player.state = 0; player.x = 4950; player.y = 2032;
assert.equal(c.camera_get_boss_view(player.x), -1, 'Checkpoint restart releases the arena lock');
c.endStep(); assert.notDeepEqual(view, [5120, 1872]);

// Gate scroll owns the camera, including the instant the player crosses x=5120.
player.id = 102; player.x = 5060; player.y = 2032; c.camera_reset_follow(player);
const start = view.slice();
c.camera_begin_gate_pan(player, true);
c.endStep();
assert.ok(view[0] >= start[0] && view[0] < start[0] + 3, 'Gate scroll starts without snapping');
let previous = view[0];
for (let frame = 1; frame < 60; frame++) {
    player.x = 5060 + frame * 2;
    c.endStep();
    assert.ok(view[0] >= previous && view[0] - previous <= 9, 'Scroll is monotonic and bounded');
    previous = view[0];
}
assert.deepEqual(view, [5120, 1872], 'Scroll lands exactly on the complete arena frame');
assert.equal(c.gate_pan_active, false);
assert.equal(c.boss_arena_locked, true);
player.id = 103; player.x = 4950; c.endStep();
assert.equal(c.boss_arena_locked, false);
assert.deepEqual(view, [4800, 1840], 'Respawn immediately frames the save corridor');
c.camera_begin_gate_pan(player, true); c.endStep();
player.id = 104; player.x = 4950; c.endStep();
assert.equal(c.gate_pan_active, false, 'Respawn interrupts an unfinished gate scroll');
assert.deepEqual(view, [4800, 1840]);

c.room = 'rStage_Sky'; player.x = 4776; player.y = 368;
assert.deepEqual(Array.from(c.camera_update_follow(0, player.x, player.y)), [4560, 192], 'Sky camera keeps its existing bounds');
console.log('PASS: fixed Jungle arena, door-edge recoil, jumps, shake, teleport-out, checkpoint reset and Sky bounds.');
