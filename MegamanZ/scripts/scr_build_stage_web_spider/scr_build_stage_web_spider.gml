/// @desc Stage Builder: Stage 1 (Web Spider — Authentic Mega Man X4 Jungle Map)

function scr_build_stage_web_spider() {
    if (instance_exists(oSolid)) return;
    
    // Helpers to create merged collision boxes
    var _make_solid = function(_x, _y, _w, _h) {
        var _s = instance_create_layer(_x, _y, "Instances", oSolid);
        _s.image_xscale = _w / 16;
        _s.image_yscale = _h / 16;
        _s.visible = false;
        return _s;
    };
    
    var _make_oneway = function(_x, _y, _w) {
        var _p = instance_create_layer(_x, _y, "Instances", oOneWayPlatform);
        _p.image_xscale = _w / 16;
        _p.visible = false;
        return _p;
    };
    
    var _make_ladder = function(_x, _y, _h) {
        var _l = instance_create_layer(_x, _y, "Instances", oLadder);
        _l.image_yscale = _h / 16;
        _l.visible = false;
        return _l;
    };
    
    // Parallax background controller
    if (!instance_exists(oParallaxBackground)) {
        instance_create_layer(0, 0, "Instances", oParallaxBackground);
    }
    
    // =========================================================================
    // SECTION 1: SURFACE JUNGLE TRAIL (x: 0 .. 1440, y: 80 .. 560)
    // Rừng nhiệt đới ngoài trời ban đêm, địa hình đồi rêu và tán cây cổ thụ
    // =========================================================================
    // Tường biên trái sân khấu
    _make_solid(0, 0, 16, 600);
    
    // Mặt sàn địa hình tự nhiên theo độ dốc của artwork JungleMap
    _make_solid(0, 368, 160, 48);      // Khởi đầu bằng phẳng
    _make_solid(160, 400, 96, 48);     // Vùng trũng rễ cây mục
    _make_solid(256, 352, 128, 48);    // Đồi đá phủ rêu
    _make_solid(384, 368, 196, 48);    // Lối mòn giữa rừng
    _make_solid(580, 400, 140, 48);    // Dốc thoải xuống
    _make_solid(720, 384, 160, 48);    // Mặt đất trước di tích cổ
    _make_solid(880, 448, 100, 48);    // Hẻm trũng
    _make_solid(980, 432, 180, 48);    // Bậc thềm cổ
    _make_solid(1160, 384, 120, 48);   // Bậc thang đá dẫn lên đền
    _make_solid(1280, 304, 64, 48);    // Bậc cao
    _make_solid(1344, 268, 96, 48);    // Đỉnh đền trước cửa giếng cổ
    
    // Các cành cây cao (One-Way Platforms)
    _make_oneway(180, 280, 144);
    _make_oneway(420, 260, 144);
    _make_oneway(760, 300, 144);
    
    // Dây leo trèo lên cành cây cao
    _make_ladder(280, 280, 88);
    _make_ladder(500, 260, 108);
    _make_ladder(840, 300, 84);
    
    // Bẫy tơ nhện dính (Web Traps)
    instance_create_layer(240, 384, "Instances", oWebTrap);
    instance_create_layer(480, 352, "Instances", oWebTrap);
    instance_create_layer(820, 368, "Instances", oWebTrap);
    
    // Quái vật Section 1:
    instance_create_layer(220, 400, "Instances", oEnemy_MettaurD2);
    instance_create_layer(320, 352, "Instances", oEnemy_MettaurD2);
    instance_create_layer(660, 400, "Instances", oEnemy_MettaurD2);
    instance_create_layer(1060, 432, "Instances", oEnemy_MettaurD2);
    
    instance_create_layer(350, 240, "Instances", oEnemy_Batton);
    instance_create_layer(850, 260, "Instances", oEnemy_Batton);
    
    instance_create_layer(520, 260, "Instances", oEnemy_FlyGunner);
    instance_create_layer(1180, 340, "Instances", oEnemy_FlyGunner);
    
    // Bí mật: Buồng Dr. Light (Air Dash Capsule) giấu trên ngọn cây cao
    instance_create_layer(960, 220, "Instances", oCapsule_Light);
    _make_oneway(920, 220, 96);
    
    // Các bậc đá giật cấp đi xuống miệng hầm cổ tại x: 1320 .. 1440
    _make_solid(1360, 400, 80, 24);
    _make_solid(1320, 520, 80, 24);
    _make_solid(1340, 656, 100, 24);
    
    // =========================================================================
    // SECTION 2: UNDER-SURFACE RUINS CORRIDOR (x: 1440 .. 64, y: 560 .. 720)
    // Hành lang đá hầm ngầm cổ kính (chạy ngược từ phải sang trái)
    // =========================================================================
    // Trần đá kiên cố ngăn với mặt đất phía trên
    _make_solid(64, 544, 1376, 24);
    
    // Tường chặn bên phải
    _make_solid(1440, 268, 32, 452);
    
    // Sàn đá hành lang hầm ngầm
    _make_solid(1000, 656, 440, 32);
    _make_solid(750, 720, 250, 32);   // Đoạn hạ thấp có bẫy
    _make_solid(144, 672, 606, 32);   // Đoạn thẳng dẫn tới họng giếng đứng
    
    // Checkpoint 1: Đầu hành lang hầm ngầm
    instance_create_layer(1200, 656 - 16, "Instances", oTrigger_Checkpoint);
    
    // Quái vật Section 2: Bánh gai lăn và Vệ binh khiên chắn
    instance_create_layer(1080, 656, "Instances", oEnemy_SpikyMKII);
    instance_create_layer(880, 720, "Instances", oEnemy_Guardian);
    instance_create_layer(460, 672, "Instances", oEnemy_SpikyMKII);
    instance_create_layer(620, 672, "Instances", oEnemy_MettaurD2);
    
    // =========================================================================
    // SECTION 3: VERTICAL DESCENT SHAFT (x: 48 .. 208, y: 672 .. 1568)
    // Giếng sâu thẳng đứng trượt tường (Wall Slide / Wall Jump)
    // =========================================================================
    // Tường trái giếng sâu
    _make_solid(32, 672, 32, 928);
    
    // Tường phải giếng sâu
    _make_solid(192, 672, 32, 832);
    
    // Các gờ đá nghỉ chân xen kẽ hai bên tường giếng
    _make_solid(64, 880, 64, 16);
    _make_solid(128, 1050, 64, 16);
    _make_solid(64, 1220, 64, 16);
    _make_solid(128, 1380, 64, 16);
    
    // Dây leo bám tường phụ trợ
    _make_ladder(156, 920, 260);
    
    // Dơi Batton treo ngược phục kích dọc giếng
    instance_create_layer(112, 840, "Instances", oEnemy_Batton);
    instance_create_layer(96, 1180, "Instances", oEnemy_Batton);
    instance_create_layer(144, 1340, "Instances", oEnemy_Batton);
    
    // Đáy giếng mở thông sang Hang Thác Nước bên phải
    _make_solid(64, 1568, 236, 48);
    
    // =========================================================================
    // SECTION 4: WATERFALL CAVERN (x: 240 .. 3350, y: 1200 .. 1760)
    // Hang ngầm thác nước phát sáng lục lam, hồ nước sâu và các cột thạch nhũ
    // =========================================================================
    // Trần hang vòm đá vôi
    _make_solid(240, 1200, 3110, 32);
    
    // Các khối thạch nhũ rủ gai góc từ trần hang
    _make_solid(700, 1232, 48, 48);
    _make_solid(1250, 1232, 64, 64);
    _make_solid(1850, 1232, 48, 48);
    _make_solid(2400, 1232, 64, 64);
    _make_solid(2950, 1232, 48, 48);
    
    // Vực hồ nước ngầm rộng lớn dưới đáy hang (Water physics)
    var _make_water = function(_wx, _wy, _ww, _wh) {
        var _wat = instance_create_layer(_wx, _wy, "Instances", oWater);
        _wat.image_xscale = _ww / 32;
        _wat.image_yscale = _wh / 32;
        return _wat;
    };
    _make_water(350, 1568, 2750, 112);
    
    // Đáy hồ nước
    _make_solid(300, 1680, 2850, 32);
    
    // Các cột đá nhô cao vượt mặt nước (Stepping Pillars)
    _make_solid(520, 1480, 80, 120);     // Cột 1
    _make_solid(800, 1440, 80, 160);     // Cột 2
    _make_solid(1100, 1380, 96, 220);    // Cột 3
    _make_solid(1400, 1440, 96, 160);    // Cột 4
    
    // Cột thạch nhũ khổng lồ chứa Heart Tank bí mật (+2 Max HP)
    _make_solid(1750, 1320, 80, 280);
    _make_ladder(1736, 1330, 200);
    instance_create_layer(1790, 1320 - 16, "Instances", oPickup_HeartTank);
    
    // Sàn đá phủ băng trơn trượt (Ice Surface)
    var _make_ice = function(_ix, _iy, _iw) {
        var _ice = instance_create_layer(_ix, _iy, "Instances", oIceSurface);
        _ice.image_xscale = _iw / 16;
        _ice.visible = false;
        return _ice;
    };
    _make_solid(1950, 1568, 150, 32);
    _make_ice(1950, 1568, 150);
    
    _make_solid(2100, 1400, 96, 200);    // Cột 5
    _make_solid(2450, 1440, 96, 160);    // Cột 6
    _make_solid(2800, 1480, 96, 120);    // Cột 7
    
    // Checkpoint 2: Giữa Hang Thác Nước
    instance_create_layer(1450, 1440 - 16, "Instances", oTrigger_Checkpoint);
    
    // Quái vật Section 4: Chuồn chuồn bay lượn và Quái gai lơ lửng
    instance_create_layer(950, 1350, "Instances", oEnemy_TonboroidS);
    instance_create_layer(2300, 1360, "Instances", oEnemy_TonboroidS);
    instance_create_layer(1300, 1420, "Instances", oEnemy_TentoroidRS);
    instance_create_layer(2650, 1420, "Instances", oEnemy_TentoroidRS);
    instance_create_layer(1140, 1260, "Instances", oEnemy_Batton);
    instance_create_layer(2430, 1260, "Instances", oEnemy_Batton);
    
    // Đoạn dốc đá dẫn ra khỏi hang ngầm
    _make_solid(3000, 1568, 150, 48);
    _make_solid(3150, 1680, 130, 48);
    _make_solid(3280, 1760, 100, 48);
    
    // =========================================================================
    // SECTION 5: FLOATING PLATFORMS CHASM (x: 3350 .. 4780, y: 1600 .. 2100)
    // Vực thẳm không đáy với các phiến đá và lá cây lơ lửng giữa trời đêm
    // =========================================================================
    // Giàn xà kim loại phía trên (Overhead Girders)
    _make_solid(3340, 1616, 1440, 16);
    
    // 10 Bậc đá lơ lửng chính (khớp vị trí cụm đá trong JungleMap)
    _make_solid(3420, 1752, 72, 32);
    _make_solid(3596, 1752, 72, 32);
    _make_solid(3692, 1928, 72, 32);
    _make_solid(3804, 1736, 72, 32);
    
    // Bậc lá cây rụng (Falling Leaf Platforms) tạo cảm giác hồi hộp
    instance_create_layer(3980, 1928, "Instances", oPlatform_Falling);
    instance_create_layer(4020, 1928, "Instances", oPlatform_Falling);
    
    _make_solid(4140, 1848, 72, 32);
    _make_solid(4268, 1880, 72, 32);
    _make_solid(4396, 1800, 72, 32);
    _make_solid(4524, 1912, 72, 32);
    _make_solid(4652, 1800, 72, 32);
    
    // Các bậc cứu hộ tầng dưới (Lower safety ledges)
    _make_solid(3548, 2056, 88, 32);
    _make_solid(3836, 2008, 88, 32);
    _make_solid(4124, 2008, 88, 32);
    _make_solid(4268, 2056, 72, 32);
    _make_solid(4524, 2088, 72, 32);
    
    // Bậc cao giấu bình Sub-Tank bí mật
    _make_solid(4036, 1720, 48, 16);
    instance_create_layer(4050, 1720 - 16, "Instances", oPickup_SubTank);
    
    // Checkpoint 3: Giữa vực thẳm
    instance_create_layer(4160, 1848 - 16, "Instances", oTrigger_Checkpoint);
    
    // Quái vật bắn tỉa trên không quấy nhiễu lúc nhảy vực
    instance_create_layer(3500, 1680, "Instances", oEnemy_FlyGunner);
    instance_create_layer(3900, 1780, "Instances", oEnemy_FlyGunner);
    instance_create_layer(4300, 1760, "Instances", oEnemy_FlyGunner);
    instance_create_layer(4600, 1780, "Instances", oEnemy_TentoroidRS);
    
    // =========================================================================
    // SECTION 6: BOSS GATE & BOSS ARENA (x: 4780 .. 5472, y: 1800 .. 2144)
    // Cổng trùm Mega Man X cổ điển và Đấu trường Trùm Nightmare Zero
    // =========================================================================
    // Dốc thoải tiếp cận cổng thành
    _make_solid(4760, 2000, 120, 48);
    
    // Checkpoint 4 (Pre-Boss Checkpoint ngay trước cửa trùm)
    instance_create_layer(4820, 2000 - 16, "Instances", oTrigger_Checkpoint);
    
    // CỔNG TRÙM MEGA MAN X (Boss Gate Doorway)
    instance_create_layer(4880, 1992, "Instances", oTrigger_BossGate);
    
    // ĐẤU TRƯỜNG TRÙM (Boss Arena Chamber):
    // 1. Sàn đấu trường vững chắc (Floor: y = 2080)
    _make_solid(4880, 2080, 592, 64);
    
    // 2. Trần đấu trường (Ceiling: y = 1856)
    _make_solid(4880, 1856, 592, 32);
    
    // 3. Tường trái (phía trên cửa trùm)
    _make_solid(4880, 1888, 16, 104);
    
    // 4. Tường phải sân đấu (Right boundary wall)
    _make_solid(5440, 1888, 32, 192);
    
    // Bẫy tơ nhện trang trí/cản trở trong đấu trường trùm
    instance_create_layer(5020, 2080 - 16, "Instances", oWebTrap);
    instance_create_layer(5320, 2080 - 16, "Instances", oWebTrap);
}
