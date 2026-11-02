const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
let spawned=[];
const c=vm.createContext({max:Math.max,sign:Math.sign,sprite_get_width:()=>32,
 instance_create_layer:(x,y,layer,object)=>{const fx={x,y,object};spawned.push(fx);return fx;},
 oFX_X4Burst:'burst',oFX_DashDust:'dust',oPlayerZero:'zero',oPlayerX:'x',
 sFX_X4_DashX:'dash-x',sFX_X4_DashZero:'dash-zero',sFX_X4_WallDust:'wall',sFX_X4_HitSpark:'spark',
 PLAYER_STATE:{WALL_SLIDE:5},state:5,grounded:false,vsp:1.5,
 x:100,y:80,bbox_left:90,bbox_right:109,bbox_bottom:94,wall_fx_timer:0});
vm.runInContext(fs.readFileSync('MegamanZ/scripts/scr_x4_effects/scr_x4_effects.gml','utf8'),c);
for(const facing of [-1,1]){
 Object.assign(c,{facing,dash_dir:facing,object_index:'x'});spawned=[];
 assert.equal(typeof c.player_spawn_x4_dash_dust,'function','Player dust needs an explicit direction');
 c.player_spawn_x4_dash_dust(100-facing*12,94);
 assert.equal(spawned[0].image_xscale,facing,'Dust must mirror with movement');
 c.player_spawn_x4_dash_flash();
 assert.equal(spawned[1].image_xscale,facing);
 assert.equal(spawned[1].sprite_index,'dash-x');
}
for(const wall of [-1,1]){
 Object.assign(c,{touching_wall:wall,wall_fx_timer:0,state:5,grounded:false,vsp:1.5});spawned=[];
 for(let i=0;i<30;i++)c.player_update_x4_wall_slide();
 assert.equal(spawned.length,3,'Wall sliding emits immediately, then every 10 steps');
 assert(spawned.every(fx=>fx.image_xscale===wall*.5&&fx.image_yscale===.5));
 assert(spawned.every(fx=>fx.x===(wall===1?110:89)),'Dust anchors at actual wall contact');
 c.state=0;c.player_update_x4_wall_slide();assert.equal(c.wall_fx_timer,0);
}
for(const name of ['oEnemy_SpikyMKII','oEnemy_TentoroidRS','obj_mini_spider']){
 assert(!fs.readFileSync(`MegamanZ/objects/${name}/Step_0.gml`,'utf8').includes('oFX_DashDust'),`${name}: no player dust`);
}
console.log('PASS: left/right dash dust and flash, both wall slide contacts, emission cadence and enemy dust removal.');
