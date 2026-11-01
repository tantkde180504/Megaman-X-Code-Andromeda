// Event-level logic/render harness; the GameMaker compiler checks the native APIs.
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const read=n=>fs.readFileSync(`MegamanZ/objects/obj_ready_intro/${n}.gml`,'utf8');
let destroyed=false,colour=123,alpha=.45,filter=true,sprites=[],vertices=[],strips=0,readyExists=true;
const c={global:{stage_ready:true,current_char:0},id:1,obj_ready_intro:1,spr_ready_intro:100,
 max:Math.max,min:Math.min,floor:Math.floor,round:Math.round,power:Math.pow,sin:Math.sin,pi:Math.PI,
 clamp:(v,a,b)=>Math.max(a,Math.min(b,v)),lerp:(a,b,t)=>a+(b-a)*t,
 instance_number:()=>1,instance_destroy:()=>destroyed=true,
 display_get_gui_width:()=>320,display_get_gui_height:()=>240,
 gpu_get_texfilter:()=>filter,gpu_set_texfilter:v=>filter=v,gpu_set_blendmode:()=>{},
 draw_get_alpha:()=>alpha,draw_set_alpha:v=>alpha=v,draw_get_colour:()=>colour,draw_set_colour:v=>colour=v,
 make_colour_rgb:(r,g,b)=>[r,g,b],c_white:1,c_aqua:2,bm_normal:0,bm_add:1,pr_trianglestrip:3,
 draw_primitive_begin:()=>strips++,draw_vertex_colour:(x,y)=>vertices.push([x,y]),draw_primitive_end:()=>{},
 draw_line_width_colour:()=>{},draw_sprite_ext:(...args)=>sprites.push(args),
};
vm.createContext(c);
for(const [name,event]of [['create','Create_0'],['step','Step_0'],['draw','Draw_64']]){
 const code=read(event).replace(/\bexit;/g,'return;').replace(/_t div 2/g,'Math.floor(_t / 2)').replace(/\bmod\b/g,'%');
 vm.runInContext(`function ${name}(){${code}}`,c);
}
c.create();assert.equal(c.global.stage_ready,false);assert.equal(c.ready_duration,138);
for(const frame of [0,6,20,60,126,132,137]){
 c.ready_frame=frame;sprites=[];vertices=[];strips=0;c.draw();
 assert.equal(colour,123);assert.equal(alpha,.45);assert.equal(filter,true);
 for(const [x,y]of vertices)assert.ok(Number.isFinite(x)&&Number.isFinite(y));
 if(frame===0)assert.equal(sprites.length,0,'Light precedes READY');
 if(frame===20)assert.equal(strips,4,'Four blue columns converge');
 if(frame===60)assert.equal(strips,0,'Columns clear during the hold');
 if(frame===132){assert.equal(sprites.length,2);assert.ok(sprites[0][2]<160&&sprites[1][2]>160,'Exit copies separate horizontally');}
}
c.ready_frame=136;c.step();assert.equal(destroyed,false);
c.step();assert.equal(destroyed,true);assert.equal(c.global.stage_ready,true);
c.display_get_gui_width=()=>640;c.display_get_gui_height=()=>480;
c.ready_frame=60;sprites=[];c.draw();
assert.equal(sprites.at(-1)[2],320);assert.equal(sprites.at(-1)[3],240);
assert.equal(sprites.at(-1)[4],2,'READY scales once at a larger GUI resolution');

// Use the real player intro to verify the beam/audio wait for the READY exit.
Object.assign(c,{obj_ready_intro:c,instance_exists:()=>readyExists,
 CHAR_TYPE:{X:0,ZERO:1},PLAYER_STATE:{IDLE:0},x:64,y:1000,grounded:true,
 intro_phase:0,teleport_beam_y:760,intro_sound_played:false,
 variable_instance_exists:(id,k)=>k in c,snd_teleport_in:5,audio_exists:()=>true,
 sX_Teleport_In:6,sX_Intro:7,sZero_Teleport_In:8,sZero_Intro:9,
 sprite_exists:()=>true,player_is_solid_at:()=>true});
let sounds=0;c.audio_play_sound=()=>sounds++;
const states=fs.readFileSync('MegamanZ/scripts/scr_player_states/scr_player_states.gml','utf8');
vm.runInContext(states.slice(states.indexOf('function player_state_intro()'),states.indexOf('// TELEPORT OUT STATE')),c);
c.ready_frame=125;c.player_state_intro();assert.equal(c.teleport_beam_y,760);assert.equal(sounds,0);
c.ready_frame=126;c.player_state_intro();assert.equal(c.teleport_beam_y,778);assert.equal(sounds,1);
readyExists=false;c.player_state_intro();assert.equal(sounds,1,'Teleport cue plays only once');
console.log('PASS: READY phases, split exit, duration, render state and delayed teleport/audio.');
