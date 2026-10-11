/// @desc Stage Builder: Stage 1 (Web Spider — Deep Jungle)

function scr_build_stage_web_spider() {
    if (instance_exists(oSolid)) return;
    
    var _bs = 16;
    
    // Spawn Parallax Background
    if (!instance_exists(oParallaxBackground)) {
        instance_create_layer(0, 0, "Instances", oParallaxBackground);
    }
    
    // -----------------------------------------------------------------
    // Boundaries (Floor & Walls)
    // -----------------------------------------------------------------
    // Ground floor across entire stage
    for (var _x = 0; _x < room_width; _x += _bs) {
        for (var _y = room_height - 32; _y < room_height; _y += _bs) {
            instance_create_layer(_x, _y, "Instances", oSolid);
        }
    }
    // Left boundary
    for (var _y = 0; _y < room_height; _y += _bs) {
        instance_create_layer(0, _y, "Instances", oSolid);
    }
    // Right boundary
    for (var _y = 0; _y < room_height; _y += _bs) {
        instance_create_layer(room_width - _bs, _y, "Instances", oSolid);
    }
    
    // -----------------------------------------------------------------
    // Section 1: Jungle Entry & Sticky Web Traps (x: 0 .. 600)
    // -----------------------------------------------------------------
    // Web Traps hanging from trees
    instance_create_layer(220, room_height - 48, "Instances", oWebTrap);
    instance_create_layer(360, room_height - 48, "Instances", oWebTrap);
    instance_create_layer(480, room_height - 64, "Instances", oWebTrap);
    
    // Low tree branches (One-Way)
    for (var _x = 180; _x < 320; _x += _bs) {
        instance_create_layer(_x, room_height - 96, "Instances", oOneWayPlatform);
    }
    for (var _x = 380; _x < 520; _x += _bs) {
        instance_create_layer(_x, room_height - 144, "Instances", oOneWayPlatform);
    }
    
    // Vine ladders climbing up into canopy
    for (var _y = room_height - 240; _y < room_height - 32; _y += _bs) {
        instance_create_layer(560, _y, "Instances", oLadder);
    }
    
    // -----------------------------------------------------------------
    // Section 2: Upper Canopy & Secret Dr. Light Capsule (x: 600 .. 1200)
    // -----------------------------------------------------------------
    // High canopy branch platform
    for (var _x = 600; _x < 1000; _x += _bs) {
        instance_create_layer(_x, room_height - 240, "Instances", oSolid);
    }
    
    // Hidden chamber with Dr. Light's Capsule (Leg Parts / Air Dash!)
    instance_create_layer(800, room_height - 240, "Instances", oCapsule_Light);
    
    // Falling leaf platforms in the upper trees
    instance_create_layer(1040, room_height - 240, "Instances", oPlatform_Falling);
    instance_create_layer(1120, room_height - 260, "Instances", oPlatform_Falling);
    
    // Ground level checkpoint
    instance_create_layer(1200, room_height - 48, "Instances", oTrigger_Checkpoint);
    
    // -----------------------------------------------------------------
    // Section 3: Waterfall Cave & Heart Tank (x: 1200 .. 1800)
    // -----------------------------------------------------------------
    // Water basin at cave bottom
    for (var _x = 1300; _x < 1550; _x += 32) {
        instance_create_layer(_x, room_height - 64, "Instances", oWater);
        instance_create_layer(_x, room_height - 32, "Instances", oWater);
    }
    
    // Slippery ice cave floor
    for (var _x = 1550; _x < 1750; _x += _bs) {
        instance_create_layer(_x, room_height - 32, "Instances", oIceSurface);
    }
    
    // High pillar holding the Heart Tank (+2 Max HP)
    for (var _y = room_height - 280; _y < room_height - 32; _y += _bs) {
        instance_create_layer(1680, _y, "Instances", oSolid);
    }
    instance_create_layer(1680, room_height - 296, "Instances", oPickup_HeartTank);
    
    // Vines to climb the pillar
    for (var _y = room_height - 280; _y < room_height - 32; _y += _bs) {
        instance_create_layer(1664, _y, "Instances", oLadder);
    }
    
    // -----------------------------------------------------------------
    // Section 4: Web Spider Boss Gate & Arena (x: 1800 .. 2400)
    // -----------------------------------------------------------------
    // Boss Gate Door!
    instance_create_layer(2060, room_height - 80, "Instances", oTrigger_BossGate);
    
    // Web Arena: spider webs scattered in boss room
    instance_create_layer(2160, room_height - 120, "Instances", oWebTrap);
    instance_create_layer(2280, room_height - 160, "Instances", oWebTrap);
    instance_create_layer(2220, room_height - 48, "Instances", oWebTrap);
    
    // Target practice dummies inside the web arena
    instance_create_layer(2240, room_height - 32, "Instances", oTargetDummy);
}
