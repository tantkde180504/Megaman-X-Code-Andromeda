/// @desc Stage Builder: Intro Stage (Ruined Skyway)

function scr_build_stage_intro() {
    if (instance_exists(oSolid)) return;
    
    var _bs = 16;
    
    // Spawn Parallax Background
    if (!instance_exists(oParallaxBackground)) {
        instance_create_layer(0, 0, "Instances", oParallaxBackground);
    }
    
    // -----------------------------------------------------------------
    // Section 1: Starting Highway (x: 0 .. 600)
    // -----------------------------------------------------------------
    // Floor
    for (var _x = 0; _x < 600; _x += _bs) {
        for (var _y = room_height - 32; _y < room_height; _y += _bs) {
            instance_create_layer(_x, _y, "Instances", oSolid);
        }
    }
    // Left boundary
    for (var _y = 0; _y < room_height; _y += _bs) {
        instance_create_layer(0, _y, "Instances", oSolid);
    }
    
    // Highway overhead girders (One-Way)
    for (var _x = 180; _x < 360; _x += _bs) {
        instance_create_layer(_x, room_height - 96, "Instances", oOneWayPlatform);
    }
    
    // Enemies in Section 1 (Knot Beret & Spiky Mk-II)
    var _kb1 = instance_create_layer(250, room_height - 32, "Instances", oEnemy_KnotBeret);
    _kb1.beret_type = 0; // Blue
    
    var _kb2 = instance_create_layer(290, room_height - 96, "Instances", oEnemy_KnotBeret);
    _kb2.beret_type = 1; // Green
    
    instance_create_layer(460, room_height - 32, "Instances", oEnemy_SpikyMKII);
    
    // Sub-Tank on high pillar
    for (var _y = room_height - 128; _y < room_height - 32; _y += _bs) {
        instance_create_layer(420, _y, "Instances", oSolid);
    }
    instance_create_layer(420, room_height - 144, "Instances", oPickup_SubTank);
    
    // -----------------------------------------------------------------
    // Section 2: Collapsed Highway Gap & Falling Platforms (x: 600 .. 1200)
    // -----------------------------------------------------------------
    // Stepping stones
    for (var _x = 640; _x < 740; _x += _bs) {
        instance_create_layer(_x, room_height - 32, "Instances", oSolid);
    }
    
    // Falling Platforms across gap
    instance_create_layer(780, room_height - 64, "Instances", oPlatform_Falling);
    instance_create_layer(860, room_height - 80, "Instances", oPlatform_Falling);
    instance_create_layer(940, room_height - 64, "Instances", oPlatform_Falling);
    
    // Fly Gunner hovering over the collapsed gap
    instance_create_layer(860, room_height - 130, "Instances", oEnemy_FlyGunner);
    
    // Hazard Spikes at the bottom of the gap
    for (var _x = 760; _x < 1000; _x += _bs) {
        instance_create_layer(_x, room_height - 16, "Instances", oHazardSpike);
    }
    
    // Solid ground resumes
    for (var _x = 1020; _x < 1500; _x += _bs) {
        for (var _y = room_height - 32; _y < room_height; _y += _bs) {
            instance_create_layer(_x, _y, "Instances", oSolid);
        }
    }
    
    // Mid-Stage Checkpoint
    instance_create_layer(1100, room_height - 48, "Instances", oTrigger_Checkpoint);
    
    // Enemies in Section 2 (Knot Beret & Spiky Mk-II)
    var _kb3 = instance_create_layer(1180, room_height - 32, "Instances", oEnemy_KnotBeret);
    _kb3.beret_type = 0;
    instance_create_layer(1360, room_height - 32, "Instances", oEnemy_SpikyMKII);
    
    // -----------------------------------------------------------------
    // Section 3: Water Reservoir Drainage & Ice Pipe (x: 1500 .. 1900)
    // -----------------------------------------------------------------
    // Water basin (depth: 64px)
    for (var _x = 1500; _x < 1700; _x += 32) {
        instance_create_layer(_x, room_height - 64, "Instances", oWater);
        instance_create_layer(_x, room_height - 32, "Instances", oWater);
    }
    for (var _x = 1500; _x < 1700; _x += _bs) {
        instance_create_layer(_x, room_height - 16, "Instances", oSolid);
    }
    
    // Fly Gunner hovering over water reservoir
    instance_create_layer(1580, room_height - 120, "Instances", oEnemy_FlyGunner);
    
    // Frozen ice pipeline after water
    for (var _x = 1700; _x < 1900; _x += _bs) {
        instance_create_layer(_x, room_height - 32, "Instances", oIceSurface);
    }
    
    // Guardian drone scanning the frozen pipeline
    instance_create_layer(1800, room_height - 90, "Instances", oEnemy_Guardian);
    
    // -----------------------------------------------------------------
    // Section 4: Boss Gate & Arena (x: 1900 .. 2400)
    // -----------------------------------------------------------------
    for (var _x = 1900; _x < room_width; _x += _bs) {
        for (var _y = room_height - 32; _y < room_height; _y += _bs) {
            instance_create_layer(_x, _y, "Instances", oSolid);
        }
    }
    // Right room boundary
    for (var _y = 0; _y < room_height; _y += _bs) {
        instance_create_layer(room_width - _bs, _y, "Instances", oSolid);
    }
    
    // Knot Beret Green guarding gate approach
    var _kb4 = instance_create_layer(1980, room_height - 32, "Instances", oEnemy_KnotBeret);
    _kb4.beret_type = 1;
    
    // Boss Gate Door!
    instance_create_layer(2060, room_height - 80, "Instances", oTrigger_BossGate);
    
    // Target Dummies inside the Boss Arena
    instance_create_layer(2200, room_height - 32, "Instances", oTargetDummy);
    instance_create_layer(2280, room_height - 32, "Instances", oTargetDummy);
}
