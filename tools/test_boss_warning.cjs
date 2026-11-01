const fs = require('node:fs'), vm = require('node:vm'), assert = require('node:assert/strict');
let code = fs.readFileSync('MegamanZ/scripts/scr_boss_warning/scr_boss_warning.gml','utf8');
code = code.replace(/^#macro BOSS_WARNING_FRAMES (\d+)/m, 'const BOSS_WARNING_FRAMES = $1;').replace(/\bmod\b/g,'%').replace(/\bstatic\b/g,'var');
let colour = '#123456', alpha = .7, calls = [], vertices = [], alarms = 0, width = 320, height = 240;
const c = {max:Math.max, min:Math.min, clamp:(n,a,b)=>Math.max(a,Math.min(b,n)), round:Math.round,
 global:{stage_ready:true}, obj_ready_intro:1,
 variable_global_exists:key=>key in c.global,
 instance_exists:()=>false,
 array_length:a=>a.length, c_black:'#000000', snd_boss_warning:1, pr_trianglelist:1,
 audio_exists:()=>true,audio_play_sound:()=>alarms++,
 display_get_gui_width:()=>width,display_get_gui_height:()=>height,
 draw_get_colour:()=>colour,draw_get_alpha:()=>alpha,draw_set_colour:x=>colour=x,draw_set_alpha:x=>alpha=x,
 make_colour_rgb:(r,g,b)=>`#${[r,g,b].map(x=>x.toString(16).padStart(2,'0')).join('')}`,
 draw_rectangle:(x1,y1,x2,y2)=>calls.push({colour,alpha,points:[[x1,y1],[x2,y1],[x2,y2],[x1,y2]]}),
 draw_primitive_begin:()=>vertices=[], draw_vertex:(x,y)=>vertices.push([x,y]),
 draw_primitive_end:()=>{for(let i=0;i<vertices.length;i+=3) calls.push({colour,alpha,points:vertices.slice(i,i+3)});}};
vm.createContext(c);
// The active-boss query uses GML's with(instance); exclude it from this renderer harness.
code = code.replace(/function boss_warning_is_active\(\) \{[\s\S]*?\n\}/, '');
vm.runInContext(code,c);
// READY and WARNING have separate Step/Draw events. READY must block both
// warning rendering and its clock/audio, even when stage_ready is stale.
for (const readyFlag of [false,true]) {
 c.global.stage_ready=readyFlag;
 c.instance_exists=()=>true;
 calls=[];const previousAlarms=alarms;
 c.boss_warning_draw(300);
 assert.equal(calls.length,0,'WARNING must not draw while READY exists');
 assert.equal(c.boss_warning_tick(360),360,'WARNING must wait with its full duration');
 assert.equal(alarms,previousAlarms,'WARNING audio must wait for READY');
}
c.instance_exists=()=>false;c.global.stage_ready=false;
calls=[];c.boss_warning_draw(300);
assert.equal(calls.length,0,'WARNING must wait for stage readiness');
assert.equal(c.boss_warning_tick(360),360);
c.global.stage_ready=true;
let remaining = 360;
for(let frame=0;frame<360;frame++) remaining=c.boss_warning_tick(remaining);
assert.equal(remaining,0); assert.equal(alarms,5);
const frames=[];
for(let elapsed=0;elapsed<360;elapsed+=3){
 calls=[];c.boss_warning_draw(360-elapsed);
 assert.equal(colour,'#123456'); assert.equal(alpha,.7);
 for(const shape of calls) for(const [x,y] of shape.points){assert.ok(Number.isFinite(x)&&Number.isFinite(y));assert.ok(x>=0&&x<=width&&y>=0&&y<=height);}
 assert.ok(!calls.some(shape => shape.alpha >= 1 && shape.points.length === 4 && shape.points[0][0] === 0 && shape.points[0][1] === 0 && shape.points[2][0] === width && shape.points[2][1] === height), 'WARNING must leave the scene visible behind the animation');
 frames.push(calls);
}
calls=[];c.boss_warning_draw(0);assert.equal(calls.length,0);
width=640;height=480;calls=[];c.boss_warning_draw(280);
for(const shape of calls)for(const [x,y]of shape.points)assert.ok(x<=640&&y<=480);

const readyDestroy=fs.readFileSync('MegamanZ/objects/obj_ready_intro/Destroy_0.gml','utf8');
c.global.stage_ready=false;c.instance_number=()=>2;
vm.runInContext(readyDestroy,c);
assert.equal(c.global.stage_ready,false,'Destroying duplicate READY must not finish the original');
c.instance_number=()=>1;vm.runInContext(readyDestroy,c);
assert.equal(c.global.stage_ready,true,'Destroying final READY completes readiness');

console.log('PASS: READY/WARNING sequencing, duplicate READY cleanup, scene visibility, full warning duration/audio, GUI scaling and Draw state restoration.');
