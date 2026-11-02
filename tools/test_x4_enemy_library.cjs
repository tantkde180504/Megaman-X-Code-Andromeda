// Run the actual profile and behaviour functions with deterministic collision I/O.
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const read=p=>fs.readFileSync(p,'utf8');
const imported=JSON.parse(read('art/enemies/x4/imported.json'));
const plan=JSON.parse(read('art/enemies/x4/library.json'));
let created=[],destroyed=false,reserved=false,draws=[];
const target={x:450,y:500};
const c=vm.createContext({
 noone:-4,X4_AI_KIND:{PATROL:0,SHOOTER:1,HOVER:2,HOPPER:3,ORBIT:4,CHARGER:5,NEST:6,FALLING:7},
 X4_AI_STATE:{PATROL:0,WINDUP:1,ATTACK:2,RECOVER:3},
 x:320,y:500,room_height:600,grav:.25,anim_timer:0,flash_timer:0,target,
 abs:Math.abs,round:Math.round,min:Math.min,floor:Math.floor,sign:Math.sign,sin:Math.sin,
 point_distance:(x,y,a,b)=>Math.hypot(a-x,b-y),
 point_direction:(x,y,a,b)=>Math.atan2(y-b,a-x)*180/Math.PI,
 lengthdir_x:(n,a)=>n*Math.cos(a*Math.PI/180),lengthdir_y:(n,a)=>-n*Math.sin(a*Math.PI/180),
 instance_exists:x=>x===target,
 instance_number:obj=>created.filter(x=>x.object===obj).length,
 instance_create_layer:(x,y,layer,obj)=>{const result={x,y,object:obj};created.push(result);return result;},
 stage_encounters_reserved:()=>reserved,
 place_meeting:(x,y)=>y>500||x<10||x>630,
 instance_destroy:()=>{destroyed=true;},
 draw_sprite_ext:(sprite,frame)=>draws.push({sprite,frame}),gpu_set_fog:()=>{},c_white:0,
 oSolid:1,oEnemyBullet:2,oFX_EnemyExplosion:3,oEnemy_X4_Kunbien:4,
});
for(const a of imported.actors)c[a.sprite]=a.sprite;
vm.runInContext(read('MegamanZ/scripts/scr_x4_enemy_profiles/scr_x4_enemy_profiles.gml'),c);
const runtime=read('MegamanZ/scripts/scr_x4_enemy_runtime/scr_x4_enemy_runtime.gml')
 .replace(/^enum .*$/gm,'').replace(/\bmod\b/g,'%')
 .replace('repeat (abs(_dx))','for (var _rx=0;_rx<abs(_dx);_rx++)')
 .replace('repeat (abs(_dy))','for (var _ry=0;_ry<abs(_dy);_ry++)');
vm.runInContext(runtime,c);
for(const spec of plan.profiles){
 Object.assign(c,{x:320,y:spec.ground?500:400,hsp:0,vsp:0,anim_timer:0,grounded:!!spec.ground,target});
 created=[];destroyed=false;draws=[];reserved=false;
 c.x4_enemy_apply(spec.key);
 const meta=imported.actors.find(a=>a.key===spec.key);
 assert.equal(c.hp,spec.hp);assert.equal(c.mask_index,meta.sprite);
 let minY=c.y,states=new Set();
 for(let tick=0;tick<240&&!destroyed;tick++){
  c.anim_timer++;c.attack_cooldown=Math.max(0,c.attack_cooldown-1);
  c.x4_enemy_tick();if(!destroyed)c.x4_enemy_draw();minY=Math.min(minY,c.y);states.add(c.state);
  assert(Number.isFinite(c.x)&&Number.isFinite(c.y),`${spec.key}: finite motion`);
 }
 assert(draws.every(d=>d.frame>=0&&d.frame<meta.frames),`${spec.key}: valid animation frames`);
 if(spec.shots>0)assert(created.some(o=>o.object===c.oEnemyBullet),`${spec.key}: fires after telegraph`);
 if(spec.kind==='HOPPER')assert(minY<495,`${spec.key}: actually jumps`);
 if(spec.kind==='NEST')assert(created.some(o=>o.object===c.oEnemy_X4_Kunbien),'Nest creates Kunbien');
 if(spec.kind==='CHARGER')assert(states.has(c.X4_AI_STATE.ATTACK),`${spec.key}: charge state reached`);
 if(spec.kind==='FALLING')assert(destroyed,`${spec.key}: impact cleans up falling hazards`);
}
// Rest screens reject projectile fire even if a caller requests it directly.
c.x4_enemy_apply('MiniLaserCannon');created=[];reserved=true;c.x4_enemy_fire();
assert.equal(created.length,0);
const parse=p=>JSON.parse(read(p).replace(/^\uFEFF/,'').replace(/,\s*([}\]])/g,'$1'));
const project=parse('MegamanZ/MegamanZ.yyp'),names=project.resources.map(r=>r.id.name);
assert.equal(new Set(names).size,names.length,'No duplicate project registrations');
for(const a of imported.actors){
 assert(names.includes(a.sprite));
 if(a.object){
  assert(names.includes(a.object));
  const obj=parse(`MegamanZ/objects/${a.object}/${a.object}.yy`);
  assert.equal(obj.parentObjectId.name,'oEnemy_X4Base');
  assert.equal(obj.spriteMaskId.name,a.sprite);
 }
}
console.log('PASS: all 33 prefab behaviours, telegraphs, bullets, hops, charges, nests, hazards and project references.');
