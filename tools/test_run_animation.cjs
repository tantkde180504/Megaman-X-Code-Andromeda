const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const read = path => fs.readFileSync(`MegamanZ/objects/${path}`, 'utf8');
const parentStep = read('oPlayer/Step_0.gml').split('if (state == PLAYER_STATE.STAGE_CLEAR')[0];
const init = read('oPlayer/Create_0.gml').split('\n').filter(line => /^run_(anim_tick|frame)\s*=/.test(line)).join('\n');

for (const character of ['oPlayerX', 'oPlayerZero']) {
    const drawn = [];
    const sprites = [];
    const c = vm.createContext({
        state: 0, next_state: 0, anim_timer: 0, iframes: 0,
        PLAYER_STATE: { RUN: 1, IDLE: 0, TELEPORT_OUT: 2 },
        player_handle_movement_and_collision() {},
        player_update_x4_wall_slide() {},
        floor: Math.floor, _is_shooting: false, sprite_exists: () => true,
        sX_Run: 10, sX_Run_Shoot: 11, sZero_Run: 12,
        x: 0, y: 0, facing: 1, c_white: 0,
        _draw_player: (sprite, frame) => { drawn.push(frame); sprites.push(sprite); },
    });
    c.player_state_execute = () => { c.state = c.next_state; };
    const draw = read(`${character}/Draw_0.gml`);
    const branch = draw.match(/else if \(state == PLAYER_STATE.RUN[^\n]+\{([\s\S]*?)\n\} else/)[1];
    const translatedStep = parentStep.replace(/(\w+) div (\d+)/g, 'Math.floor($1 / $2)');
    vm.runInContext(`${init}\nfunction step() { ${translatedStep} }\nfunction draw_run() { ${branch} }`, c);
    // Enter RUN from idle, then hold movement for several complete cycles.
    vm.runInContext('step(); next_state = PLAYER_STATE.RUN;', c);
    for (let tick = 0; tick < 180; tick++) {
        c._is_shooting = tick >= 60 && tick < 90;
        vm.runInContext('step(); draw_run();', c);
    }
    assert(drawn.slice(48).every(frame => frame >= 2 && frame <= 15), `${character}: startup poses recur in the running loop`);
    const expected = Array.from({ length: 180 }, (_, tick) => {
        const phase = Math.floor(tick / 3);
        return phase < 16 ? phase : 2 + (phase - 16) % 14;
    });
    assert.deepEqual(drawn, expected, `${character}: running frames must advance every three steps`);
    if (character === 'oPlayerX') {
        assert(sprites.slice(60, 90).every(sprite => sprite === c.sX_Run_Shoot));
        assert.equal(sprites[90], c.sX_Run);
        for (const event of ['Step_0.gml', 'Draw_0.gml']) {
            assert.match(read(`${character}/${event}`), /var _rf = run_frame;/, 'buster offsets must use the same running frame');
        }
    }
    vm.runInContext('next_state = PLAYER_STATE.IDLE; step(); next_state = PLAYER_STATE.RUN; step(); draw_run();', c);
    assert.equal(drawn.at(-1), 0, `${character}: restarting must begin at the startup pose`);
    console.log(`${character}: startup once, uniform 14-frame loop, restart OK`);
}
