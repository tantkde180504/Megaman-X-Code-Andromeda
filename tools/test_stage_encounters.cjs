// Exercise the real encounter module against room instances and inheritance.
const fs = require('node:fs'), vm = require('node:vm'), assert = require('node:assert/strict');
const read = p => fs.readFileSync(`MegamanZ/${p}`, 'utf8');
const parse = p => JSON.parse(read(p).replace(/^\uFEFF/,'').replace(/,\s*([}\]])/g,'$1'));
const objects = new Map();
for (const name of fs.readdirSync('MegamanZ/objects')) {
    const path = `objects/${name}/${name}.yy`;
    if (fs.existsSync(`MegamanZ/${path}`)) objects.set(name, parse(path));
}
const ancestor = (child,parent) => {
    for (let p=objects.get(child)?.parentObjectId?.name;p;p=objects.get(p)?.parentObjectId?.name) {
        if(p===parent)return true;
    }
    return false;
};
let instances=[], destroyed=[];
const c = vm.createContext({global:{}, VIEW_WIDTH:320,VIEW_HEIGHT:240,
    room:'rStage_Sky',room_width:4880,room_height:1248,
    room_get_name: r=>r,object_is_ancestor:ancestor,array_length:a=>a.length,
    array_push:(a,x)=>a.push(x),variable_global_exists:key=>key in c.global,
    instance_number: obj=>instances.filter(i=>i.object_index===obj||ancestor(i.object_index,obj)).length,
    instance_find: (obj,n)=>instances.filter(i=>i.object_index===obj||ancestor(i.object_index,obj))[n],
    instance_destroy:(i)=>{destroyed.push(i);instances=instances.filter(x=>x!==i);},
});
for(const name of objects.keys())c[name]=name;
vm.runInContext(read('scripts/scr_stage_encounters/scr_stage_encounters.gml'),c);
const roomInstances = room => parse(`rooms/${room}/${room}.yy`).layers.flatMap(l=>l.instances||[])
    .map(i=>({x:i.x,y:i.y,object_index:i.objectId?.name}));
instances=roomInstances('rStage_Sky');c.stage_encounters_configure(64,1152);
assert(c.stage_encounters_reserved(260,1152),'Opening screen excludes the old first enemy');
assert(!c.stage_encounters_reserved(480,1152),'First encounter starts past the rest screen');
for(const checkpoint of instances.filter(i=>i.object_index==='oTrigger_Checkpoint')) {
    assert(c.stage_encounters_reserved(checkpoint.x,checkpoint.y-120),'Checkpoint also excludes airborne ambushes');
}
let spawned=[];c.music_stop_all=()=>{};c.instance_exists=()=>false;
c.instance_create_layer=(x,y,layer,obj)=>spawned.push({x,y,object_index:obj});
vm.runInContext(read('scripts/scr_build_stage_sky/scr_build_stage_sky.gml'),c);c.scr_build_stage_sky();
assert.equal(spawned.length,13,'Sky uses spaced encounters instead of a 28-enemy pileup');
assert(spawned.every(e=>!c.stage_encounters_reserved(e.x,e.y)),'Every authored Sky encounter respects rest areas');
assert(c.stage_enemy_is_regular('oEnemy_SpikyMKII'));
assert(!c.stage_enemy_is_regular('obj_nightmare_zero'),'Boss inheritance is preserved');
assert(!c.stage_enemy_is_regular('oBoss_WebSpider'),'Legacy boss alias is preserved');
assert(!c.stage_enemy_is_regular('oBoss_WebSpider_Projectile'),'Boss projectiles remain functional');
assert(c.stage_enemy_is_regular('obj_mini_spider'),'Extra enemy adds are excluded from a boss-only arena');

c.room='rStage_WebSpider';c.room_width=5472;c.room_height=2160;
instances=roomInstances(c.room);c.stage_encounters_configure(4950,2032);
for(const p of [[64,368],[1168,1808],[3136,2016],[4864,1984],[4950,2032],[5180,2096]]) {
    assert(c.stage_encounters_reserved(...p),`Reserved Jungle area ${p}`);
}
const mob={x:5250,y:2096,object_index:'oEnemy_SpikyMKII'};
const boss={x:5250,y:2096,object_index:'obj_nightmare_zero'};
const attack={x:5250,y:2096,object_index:'oBoss_WebSpider_Projectile'};
instances.push(mob,boss,attack);c.stage_encounters_clear_reserved();
assert(destroyed.includes(mob));assert(instances.includes(boss));assert(instances.includes(attack));
assert(!instances.some(i=>i.object_index==='oWebTrap'&&c.stage_encounters_reserved(i.x,i.y)));
assert(!instances.some(i=>c.stage_enemy_is_regular(i.object_index)&&c.stage_encounters_reserved(i.x,i.y)));
// A runtime-spawned enemy is caught by the real parent Step before contact damage.
Object.assign(c,{object_index:'oEnemy_SpikyMKII',x:5250,y:2096,id:999,stage_frozen:false,is_dead:false});
vm.runInContext(`function enemy_step(){${read('objects/oEnemyParent/Step_0.gml')}}`,c);
c.enemy_step();assert.equal(c.stage_frozen,true);assert.equal(c.is_dead,true);assert(destroyed.includes(999));

c.room='rBoss_NightmareZero';c.room_width=480;c.room_height=270;
instances=[];c.stage_encounters_configure(80,240);
assert(c.stage_encounters_reserved(300,30));
c.room='rStage_Intro';c.room_width=2400;c.room_height=540;
c.stage_encounters_configure(64,508);assert(c.stage_encounters_reserved(2260,450),'Empty boss arena stays empty');
c.room='rTitle';assert(!c.stage_encounters_reserved(2260,450),'Areas cannot leak into another room');

// Ordinary enemy bullets, bombs and grenades die before they can damage a rest point.
c.room='rStage_Sky';instances=[];c.stage_encounters_configure(64,1152);
Object.assign(c,{x:260,y:1100,hsp:3,vsp:1});
for(const obj of ['oEnemyBullet','oEnemy_BattonBomb','oEnemy_Grenade']) {
    const before=destroyed.length;
    vm.runInContext(`function projectile_step(){${read(`objects/${obj}/Step_0.gml`)}}`,c);
    c.projectile_step();assert.equal(destroyed.length,before+1,`${obj} cannot fire into a safe screen`);
}
const project=parse('MegamanZ.yyp');assert(project.resources.some(r=>r.id.name==='scr_stage_encounters'));
console.log('PASS: authored encounters, all checkpoint/entry areas, boss-only arenas, runtime mobs and ordinary projectiles.');
