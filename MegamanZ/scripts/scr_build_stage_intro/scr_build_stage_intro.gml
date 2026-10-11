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
    
    // Frozen ice pipeline after water
    for (var _x = 1700; _x < 1900; _x += _bs) {
        instance_create_layer(_x, room_height - 32, "Instances", oIceSurface);
    }
    
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
    
    // Boss Gate Door!
    instance_create_layer(2060, room_height - 80, "Instances", oTrigger_BossGate);
    
    // Target Dummies inside the Boss Arena
    instance_create_layer(2200, room_height - 32, "Instances", oTargetDummy);
    instance_create_layer(2280, room_height - 32, "Instances", oTargetDummy);
}
