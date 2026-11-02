const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const data=JSON.parse(fs.readFileSync('art/effects/x4/imported.json','utf8'));
const sprites=new Map(data.sprites.map((s,i)=>[s.name,{...s,id:i}]));
let calls=[],alpha=.4,colour=123,destroyed=false;
const c=vm.createContext({VIEW_WIDTH:320,X4_HUD_STYLE:{X:0,ZERO:1,BOSS_X:2,BOSS_R:3,BOSS_SIGMA:4},
 ceil:Math.ceil,clamp:(v,l,h)=>Math.max(l,Math.min(h,v)),round:Math.round,floor:Math.floor,max:Math.max,
 c_black:0,c_white:16777215,draw_get_alpha:()=>alpha,draw_get_colour:()=>colour,
 draw_set_alpha:v=>alpha=v,draw_set_colour:v=>colour=v,
 draw_rectangle:(...args)=>calls.push({rectangle:args}),
 draw_sprite:(sprite,frame,x,y)=>calls.push({sprite,frame,x,y}),
 sprite_get_width:s=>sprites.get(s).size[0],sprite_get_number:s=>sprites.get(s).frames,
 instance_destroy:()=>{destroyed=true;},
});
for(const name of sprites.keys())c[name]=name;
const hud=fs.readFileSync('MegamanZ/scripts/scr_x4_hud/scr_x4_hud.gml','utf8').replace(/^enum .*$/gm,'');
vm.runInContext(hud,c);
for(const [hp,max,cells,filled] of [[16,16,16,16],[8,16,16,8],[0,16,16,0],[-4,16,16,0],
 [99,16,16,16],[1,64,32,1],[32,64,32,16],[64,64,32,32],[0,0,16,0]]){
 calls=[];c.hud_x4_draw_bar(8,12,hp,max,0,cells);
 assert.equal(calls.filter(x=>x.sprite==='sHUD_X4_Cell').length,filled);
 assert.equal(calls.filter(x=>x.sprite==='sHUD_X4_BaseX').length,1,'Emblem drawn once without stretching');
 assert.equal(calls.filter(x=>x.sprite==='sHUD_X4_Shaft').length,cells);
 const fill=calls.filter(x=>x.sprite==='sHUD_X4_Cell');
 assert(fill.every((x,i)=>!i||x.y===fill[i-1].y-2),'Health fills from bottom up');
 assert.equal(alpha,.4);assert.equal(colour,123,'GUI render state restored');
}
for(const style of [2,3,4]){
 calls=[];c.hud_x4_draw_boss(64,64,style,true);
 for(const call of calls.filter(x=>x.sprite)){
  const [w,h]=sprites.get(call.sprite).size;
  assert(call.x>=0&&call.x+w<=320&&call.y>=0&&call.y+h<=240,'Native HUD parts stay in safe bounds');
 }
 assert(calls.filter(x=>x.sprite==='sHUD_X4_Cell').every(x=>x.frame===1),'Damage flash uses white source-palette cells');
}
const effects=fs.readFileSync('MegamanZ/scripts/scr_x4_effects/scr_x4_effects.gml','utf8');
vm.runInContext(effects,c);
for(const object of ['oFX_HitSpark','oFX_DashDust','oFX_EnemyExplosion','oFX_X4Burst']){
 destroyed=false;
 vm.runInContext(fs.readFileSync(`MegamanZ/objects/${object}/Create_0.gml`,'utf8'),c);
 const frames=[];for(let i=0;i<300&&!destroyed;i++){
  c.fx_x4_advance();if(!destroyed)frames.push(c.image_index);
 }
 assert(destroyed,`${object} must clean itself up`);
 assert(frames.includes(sprites.get(c.sprite_index).frames-1),`${object} must display its final source frame`);
 assert(frames.every(f=>f>=0&&f<sprites.get(c.sprite_index).frames));
}
// Verify a single character-specific flash on every transition into DASH.
const step=fs.readFileSync('MegamanZ/objects/oPlayer/Step_0.gml','utf8').split('if (state == PLAYER_STATE.TELEPORT_OUT)')[0];
let flashes=0;Object.assign(c,{state:0,anim_timer:0,iframes:0,PLAYER_STATE:{RUN:1,DASH:2},
 player_state_execute:()=>{c.state=2;},player_spawn_x4_dash_flash:()=>flashes++});
vm.runInContext(`function player_step(){${step}}`,c);c.player_step();c.player_step();c.player_step();
assert.equal(flashes,1);c.state=0;c.player_step();assert.equal(flashes,2);
assert.equal(sprites.get('sHUD_X4_Digits').frames,10);
assert.equal(sprites.get('sHUD_X4_WeaponIcons').frames,8);
assert.equal(sprites.get('sHUD_X4_PauseIconsX').frames,20);
assert.equal(sprites.get('sHUD_X4_PauseIconsZero').frames,8);
console.log('PASS: source HUD assembly, HP ratios/upgrades, boss bounds, render state, complete one-shot effects and dash entry.');
