/// @desc Mini Spider Minion Step
anim_timer += 0.2;

// Health check
if (hp <= 0) {
    if (object_exists(oFX_HitSpark)) {
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
    }
    instance_destroy();
    return;
}

switch (spider_state) {
    case SPIDER_MINION_STATE.AIR:
        vsp = min(vsp + grav, 8.0);
        x += hsp;
        y += vsp;
        if (hsp != 0) facing = (hsp >= 0) ? 1 : -1;
        
        // Touch flat floor surface
        if (place_meeting(x, y + 1, oSolid) || y >= y_floor) {
            vsp = 0;
            // Snap cleanly to surface
            while (!place_meeting(x, y + 1, oSolid) && y < y_floor) y++;
            while (place_meeting(x, y, oSolid)) y--;
            spider_state = SPIDER_MINION_STATE.FLOOR;
            floor_crawl_timer = 0;
            facing = crawl_dir;
            if (object_exists(oFX_DashDust)) {
                instance_create_layer(x, y, "Instances", oFX_DashDust);
            }
        }
        break;
        
    case SPIDER_MINION_STATE.FLOOR:
        floor_crawl_timer++;
        hsp = facing * crawl_speed;
        x += hsp;
        
        // Floor snap on slopes/steps
        if (!place_meeting(x, y + 1, oSolid) && place_meeting(x, y + 6, oSolid)) y += 2;
        while (place_meeting(x, y, oSolid)) y--;
        
        // Bò dưới đất trước, khi tới sát tường và đủ thời gian bò thì từ từ bám tường đi lên
        var _hit_wall = place_meeting(x + (facing * 4), y - 4, oSolid) || 
                        (facing == -1 && x <= left_wall_x + 8) || 
                        (facing == 1 && x >= right_wall_x - 8);
        
        if (_hit_wall) {
            if (floor_crawl_timer >= floor_crawl_min_time) {
                // Đã bò dưới đất đủ lâu -> bắt đầu bám tường từ từ đi lên
                spider_state = SPIDER_MINION_STATE.WALL;
                vsp = wall_climb_speed;
                hsp = 0;
                if (facing == -1) {
                    // Bám tường trái -> chân chạm tường trái (facing = 1 trong sprite sheet)
                    facing = 1;
                    while (place_meeting(x, y, oSolid)) x++;
                } else {
                    // Bám tường phải -> chân chạm tường phải (facing = -1 trong sprite sheet)
                    facing = -1;
                    while (place_meeting(x, y, oSolid)) x--;
                }
            } else {
                // Nếu chạm góc tường quá sớm -> quay đầu tiếp tục bò dưới mặt đất
                facing = -facing;
                crawl_dir = facing;
            }
        }
        break;
        
    case SPIDER_MINION_STATE.WALL:
        y += vsp;
        
        // Reached ceiling or top boundary
        if (place_meeting(x, y - 2, oSolid) || y <= y_ceiling || y <= 32) {
            if (object_exists(oFX_HitSpark)) {
                instance_create_layer(x, y, "Instances", oFX_HitSpark);
            }
            instance_destroy();
            return;
        }
        break;
}

// Damage player
if (instance_exists(oPlayer)) {
    var _p = instance_nearest(x, y, oPlayer);
    if (place_meeting(x, y, _p)) {
        if (_p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
            var _kdir = (hsp != 0) ? sign(hsp) : ((_p.x >= x) ? 1 : -1);
            player_take_damage(damage, _kdir);
        }
    }
}
