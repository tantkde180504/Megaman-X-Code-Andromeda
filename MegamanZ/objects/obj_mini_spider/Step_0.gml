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
        if (place_meeting(x, y + 1, oSolid) || y >= y_floor) {
            vsp = 0;
            spider_state = SPIDER_MINION_STATE.FLOOR;
            if (instance_exists(oPlayer)) {
                var _p = instance_nearest(x, y, oPlayer);
                facing = (_p.x >= x) ? 1 : -1;
            }
        }
        break;
        
    case SPIDER_MINION_STATE.FLOOR:
        hsp = facing * 2.8;
        x += hsp;
        
        // Floor snap on slopes/steps
        if (!place_meeting(x, y + 1, oSolid) && place_meeting(x, y + 4, oSolid)) y += 2;
        
        // Wall collision check
        if (place_meeting(x + sign(hsp), y, oSolid)) {
            spider_state = SPIDER_MINION_STATE.WALL;
            vsp = -2.8;
            hsp = 0;
        }
        break;
        
    case SPIDER_MINION_STATE.WALL:
        y += vsp;
        // Reached ceiling or top boundary
        if (place_meeting(x, y - 1, oSolid) || y <= 32) {
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
