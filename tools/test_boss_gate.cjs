// Run the actual gate event; apply the player's one physics movement separately.
const fs = require('node:fs'), vm = require('node:vm'), assert = require('node:assert/strict');
const states = {CLOSED:0,OPENING:1,WALKING:2,WAIT_CLOSE:3,CLOSING:4,LOCKED:5};
const player = {id:101,x:5072,y:2034,bbox_left:5060,bbox_right:5084,bbox_top:2002,bbox_bottom:2048,
    grounded:true,state:0,hsp:0,vsp:0};
let pans=0, panning=true;
const c = vm.createContext({global:{}, GATE_STATE:states, PLAYER_STATE:{IDLE:0,RUN:1,HURT:2,DEATH:3},
    GRAVITY:.25, MAX_FALL_SPEED:8, TECHNIQUE:{NONE:0},oPlayer:1,oSolid:2,
    snd_boss_door_open:3,snd_boss_door_close:4,
    x:5088,y:1984,bbox_left:5088,bbox_right:5117,bbox_top:1984,bbox_bottom:2047,
    clamp:(v,lo,hi)=>Math.max(lo,Math.min(hi,v)),floor:Math.floor,min:Math.min,
    instance_exists:()=>true,instance_find:()=>player,place_meeting:()=>false,
    variable_instance_exists:(p,key)=>key in p,audio_exists:()=>false,
    camera_begin_gate_pan:(p,arena)=>{assert.equal(p,player);assert.equal(arena,true);pans++;},
    camera_gate_pan_running:()=>panning,
});
vm.runInContext(fs.readFileSync('MegamanZ/objects/oTrigger_BossGate/Create_0.gml','utf8'),c);
c.is_arena_door=true;
vm.runInContext(`function step(){${fs.readFileSync('MegamanZ/objects/oTrigger_BossGate/Step_0.gml','utf8')}}`,c);
c.step(); assert.equal(c.gate_state,states.OPENING); assert.equal(pans,0);
while(c.gate_state===states.OPENING)c.step();
assert.equal(pans,1,'Camera scroll starts once, only after the door opens');
assert.equal(c.walk_target_x,5184,'Player must stand 64px inside the arena frame');
player.grounded=false;c.step();assert.equal(player.vsp,.25,'Auto-walk must descend from the ledge');player.grounded=true;
while(c.gate_state===states.WALKING){
    const before=player.x;c.step();
    assert.ok(player.x<=before,'Gate event must not apply a second horizontal movement');
    player.x+=player.hsp;
}
assert.equal(player.x,5184);assert.equal(player.is_auto_walking,false);
for(let i=0;i<65;i++)c.step();
assert.equal(c.gate_state,states.WAIT_CLOSE,'Door must wait for the scroll before closing');
panning=false;c.step();assert.equal(c.gate_state,states.CLOSING);
assert.equal(pans,1);
console.log('PASS: open-scroll-walk-close order, player framing, single movement and ledge gravity.');
