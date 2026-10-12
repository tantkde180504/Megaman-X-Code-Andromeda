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
    
    // Mettaur D2 on the jungle ground
    instance_create_layer(280, room_height - 32, "Instances", oEnemy_MettaurD2);
    
    // Low tree branches (One-Way)
    for (var _x = 180; _x < 320; _x += _bs) {
        instance_create_layer(_x, room_height - 96, "Instances", oOneWayPlatform);
    }
    for (var _x = 380; _x < 520; _x += _bs) {
        instance_create_layer(_x, room_height - 144, "Instances", oOneWayPlatform);
    }
    
    // Mettaur D2 guarding branch platform
    instance_create_layer(440, room_height - 144, "Instances", oEnemy_MettaurD2);
    
    // Batton hanging from high branch
    instance_create_layer(310, room_height - 160, "Instances", oEnemy_Batton);
    
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
    
    // Tentoroid RS crawling on canopy branch
    instance_create_layer(680, room_height - 240, "Instances", oEnemy_TentoroidRS);
    
    // Batton hanging under canopy
    instance_create_layer(740, room_height - 210, "Instances", oEnemy_Batton);
    
    // Hidden chamber with Dr. Light's Capsule (Leg Parts / Air Dash!)
    instance_create_layer(800, room_height - 240, "Instances", oCapsule_Light);
    
    // Tonboroid S flying above upper canopy
    instance_create_layer(880, room_height - 280, "Instances", oEnemy_TonboroidS);
    
    // Falling leaf platforms in the upper trees
    instance_create_layer(1040, room_height - 240, "Instances", oPlatform_Falling);
    instance_create_layer(1120, room_height - 260, "Instances", oPlatform_Falling);
    
    // Ground level checkpoint
    instance_create_layer(1200, room_height - 48, "Instances", oTrigger_Checkpoint);
    
    // Mettaur D2 near checkpoint
    instance_create_layer(1100, room_height - 32, "Instances", oEnemy_MettaurD2);
    
    // -----------------------------------------------------------------
    // Section 3: Waterfall Cave & Heart Tank (x: 1200 .. 1800)
    // -----------------------------------------------------------------
    // Water basin at cave bottom
    for (var _x = 1300; _x < 1550; _x += 32) {
        instance_create_layer(_x, room_height - 64, "Instances", oWater);
        instance_create_layer(_x, room_height - 32, "Instances", oWater);
    }
    
    // Tonboroid S hovering above waterfall
    instance_create_layer(1420, room_height - 140, "Instances", oEnemy_TonboroidS);
    
    // Batton hanging in waterfall cave
    instance_create_layer(1500, room_height - 180, "Instances", oEnemy_Batton);
    
    // Slippery ice cave floor
    for (var _x = 1550; _x < 1750; _x += _bs) {
        instance_create_layer(_x, room_height - 32, "Instances", oIceSurface);
    }
    
    // Tentoroid RS crawling on ice floor
    instance_create_layer(1600, room_height - 32, "Instances", oEnemy_TentoroidRS);
    
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
    // Knot Beret Green guarding entrance to Boss Gate
    instance_create_layer(1960, room_height - 32, "Instances", oEnemy_KnotBeretG);
    
    // Boss Gate Door!
    instance_create_layer(2060, room_height - 80, "Instances", oTrigger_BossGate);
    
    // Web Arena: spider webs scattered in boss room
    instance_create_layer(2160, room_height - 120, "Instances", oWebTrap);
    instance_create_layer(2280, room_height - 160, "Instances", oWebTrap);
    instance_create_layer(2220, room_height - 48, "Instances", oWebTrap);
    
    // Target practice dummies inside the web arena
    instance_create_layer(2240, room_height - 32, "Instances", oTargetDummy);
}
