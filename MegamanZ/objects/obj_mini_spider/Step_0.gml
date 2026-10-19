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
            if (y >= y_floor) y = y_floor;
            spider_state = SPIDER_MINION_STATE.FLOOR;
            // Maintain trajectory direction towards designated wall
            facing = crawl_dir;
            if (object_exists(oFX_DashDust)) {
                instance_create_layer(x, y, "Instances", oFX_DashDust);
            }
        }
        break;
        
    case SPIDER_MINION_STATE.FLOOR:
        hsp = facing * 2.8;
        x += hsp;
        
        // Floor snap on slopes/steps
        if (!place_meeting(x, y + 1, oSolid) && place_meeting(x, y + 6, oSolid)) y += 2;
        
        // Wall collision check: solid tile or arena wall boundary
        var _hit_wall = place_meeting(x + sign(hsp) * 4, y, oSolid) || 
                        (facing == -1 && x <= left_wall_x + 8) || 
                        (facing == 1 && x >= right_wall_x - 8);
                        
        if (_hit_wall) {
            spider_state = SPIDER_MINION_STATE.WALL;
            vsp = -2.8;
            hsp = 0;
            // Snap to wall face and turn belly toward room center
            if (facing == -1) {
                x = left_wall_x + 8;
                facing = 1; // Wall on left -> belly faces right
            } else {
                x = right_wall_x - 8;
                facing = -1; // Wall on right -> belly faces left
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
