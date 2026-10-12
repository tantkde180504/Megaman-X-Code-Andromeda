/// @desc Procedural Playground Layout for Test Room

function scr_build_test_room() {
    // Prevent duplicate spawning if instances already exist
    if (instance_exists(oSolid)) return;
    
    var _block_sz = 16;
    
    // -------------------------------------------------------------
    // 1. Outer Boundaries (Floor, Ceiling, Walls)
    // -------------------------------------------------------------
    // Bottom floor (thickness: 3 blocks)
    for (var _bx = 0; _bx < room_width; _bx += _block_sz) {
        for (var _by = room_height - 32; _by < room_height; _by += _block_sz) {
            // Leave a gap for the spike pit at x: 840 to 920
            if (!(_bx >= 840 && _bx < 920 && _by == room_height - 32)) {
                instance_create_layer(_bx, _by, "Instances", oSolid);
            }
        }
    }
    
    // Ceiling
    for (var _bx = 0; _bx < room_width; _bx += _block_sz) {
        instance_create_layer(_bx, 0, "Instances", oSolid);
    }
    
    // Left & Right boundary walls
    for (var _by = 0; _by < room_height; _by += _block_sz) {
        instance_create_layer(0, _by, "Instances", oSolid);
        instance_create_layer(room_width - _block_sz, _by, "Instances", oSolid);
    }
    
    // -------------------------------------------------------------
    // 2. Obstacles & Stepping Stones (Test Run & Jump Heights)
    // -------------------------------------------------------------
    // Low platform (h = 32px off ground)
    for (var _bx = 180; _bx <= 240; _bx += _block_sz) {
        instance_create_layer(_bx, room_height - 64, "Instances", oSolid);
    }
    
    // Medium platform (h = 64px off ground)
    for (var _bx = 280; _bx <= 340; _bx += _block_sz) {
        instance_create_layer(_bx, room_height - 96, "Instances", oSolid);
    }
    
    // High platform (h = 112px off ground)
    for (var _bx = 380; _bx <= 430; _bx += _block_sz) {
        instance_create_layer(_bx, room_height - 144, "Instances", oSolid);
    }
    
    // -------------------------------------------------------------
    // 3. Tall Wall Shaft (Test Wall Slide, Wall Jump & Wall Kicks)
    // -------------------------------------------------------------
    // Left shaft wall (height: 200px)
    for (var _by = room_height - 232; _by < room_height - 32; _by += _block_sz) {
        instance_create_layer(480, _by, "Instances", oSolid);
    }
    // Right shaft wall
    for (var _by = room_height - 232; _by < room_height - 32; _by += _block_sz) {
        instance_create_layer(544, _by, "Instances", oSolid);
    }
    
    // -------------------------------------------------------------
    // 4. One-Way Platforms (Jump Through & Drop Down)
    // -------------------------------------------------------------
    for (var _bx = 600; _bx <= 700; _bx += _block_sz) {
        instance_create_layer(_bx, room_height - 120, "Instances", oOneWayPlatform);
    }
    for (var _bx = 640; _bx <= 720; _bx += _block_sz) {
        instance_create_layer(_bx, room_height - 180, "Instances", oOneWayPlatform);
    }
    
    // -------------------------------------------------------------
    // 5. Ladder Section (Climb Up/Down & Jump Off)
    // -------------------------------------------------------------
    for (var _by = room_height - 200; _by < room_height - 32; _by += _block_sz) {
        instance_create_layer(760, _by, "Instances", oLadder);
    }
    // Platform atop ladder
    for (var _bx = 744; _bx <= 800; _bx += _block_sz) {
        if (_bx != 760) {
            instance_create_layer(_bx, room_height - 200, "Instances", oOneWayPlatform);
        }
    }
    
    // -------------------------------------------------------------
    // 6. Hazard Spike Pit
    // -------------------------------------------------------------
    for (var _bx = 840; _bx < 920; _bx += _block_sz) {
        instance_create_layer(_bx, room_height - 32, "Instances", oHazardSpike);
    }
    // High bridge across spikes
    for (var _bx = 824; _bx <= 936; _bx += _block_sz) {
        instance_create_layer(_bx, room_height - 110, "Instances", oOneWayPlatform);
    }
    
    // -------------------------------------------------------------
    // 7. Mobility Gym Test Enemies (Quick Test Right From Start)
    // -------------------------------------------------------------
    // Mettaur D2: On floor before stepping stones
    instance_create_layer(210, room_height - 32, "Instances", oEnemy_MettaurD2);
    
    // Batton Bone B81: Perched under medium platform
    instance_create_layer(310, room_height - 96, "Instances", oEnemy_Batton);
    
    // Knot Beret G: Standing on high platform with rifle
    instance_create_layer(405, room_height - 144, "Instances", oEnemy_KnotBeretG);
    
    // Spiky Mk-II: Patrolling floor under one-way platforms
    instance_create_layer(650, room_height - 32, "Instances", oEnemy_SpikyMKII);
    
    // Fly Gunner: Hovering over the hazard spike pit
    instance_create_layer(880, room_height - 150, "Instances", oEnemy_FlyGunner);
    
    // -------------------------------------------------------------
    // 8. Dedicated 9-Enemy Testing Gallery (x: 960 .. 2400)
    // -------------------------------------------------------------
    // Divider pillar at entrance of gallery
    for (var _by = room_height - 120; _by < room_height - 32; _by += _block_sz) {
        instance_create_layer(960, _by, "Instances", oSolid);
    }
    
    // Station 1 (x: 1040): Mettaur D2 — Helmet guard & 3-way spread shot
    instance_create_layer(1040, room_height - 32, "Instances", oEnemy_MettaurD2);
    
    // Station 2 (x: 1180): Spiky Mk-II — Patrol, spike deploy & high-speed charge
    instance_create_layer(1180, room_height - 32, "Instances", oEnemy_SpikyMKII);
    
    // Station 3 (x: 1320): Knot Beret B — Parabolic bouncing grenade thrower
    instance_create_layer(1320, room_height - 32, "Instances", oEnemy_KnotBeretB);
    
    // Station 4 (x: 1460): Knot Beret G — Sniper rifle bursts on elevated girder
    for (var _bx = 1420; _bx <= 1500; _bx += _block_sz) {
        instance_create_layer(_bx, room_height - 64, "Instances", oOneWayPlatform);
    }
    instance_create_layer(1460, room_height - 64, "Instances", oEnemy_KnotBeretG);
    
    // Station 5 (x: 1620): Batton Bone B81 — Ceiling roost, dive swoop & bomb drop
    for (var _bx = 1580; _bx <= 1660; _bx += _block_sz) {
        instance_create_layer(_bx, room_height - 130, "Instances", oSolid);
    }
    instance_create_layer(1620, room_height - 130, "Instances", oEnemy_Batton);
    
    // Station 6 (x: 1780): Fly Gunner — Airborne hover, laser tracking & plasma cannon
    instance_create_layer(1780, room_height - 120, "Instances", oEnemy_FlyGunner);
    
    // Station 7 (x: 1940): Tonboroid S — Dragonfly wing flaps & aerial bomb drops
    instance_create_layer(1940, room_height - 130, "Instances", oEnemy_TonboroidS);
    
    // Station 8 (x: 2100): Tentoroid RS — Armored beetle crawl & charging pincer crush
    instance_create_layer(2100, room_height - 32, "Instances", oEnemy_TentoroidRS);
    
    // Station 9 (x: 2240): Guardian — Frontal barrier shield & dual laser blasts
    instance_create_layer(2240, room_height - 90, "Instances", oEnemy_Guardian);
    
    // Target Practice & Combo Dummy
    instance_create_layer(2320, room_height - 32, "Instances", oTargetDummy);
    
    // Station 10 (x: 2360): Nightmare Zero Boss (Press 'B' anytime to summon directly to player)
    instance_create_layer(2360, room_height - 32, "Instances", obj_nightmare_zero);
}

