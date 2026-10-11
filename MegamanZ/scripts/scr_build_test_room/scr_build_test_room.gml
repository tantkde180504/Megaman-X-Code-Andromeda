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
    // 7. Combat Testing Arena (Target Dummies)
    // -------------------------------------------------------------
    instance_create_layer(1020, room_height - 32, "Instances", oTargetDummy);
    instance_create_layer(1100, room_height - 32, "Instances", oTargetDummy);
}
