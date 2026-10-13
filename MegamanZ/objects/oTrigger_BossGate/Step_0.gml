if (gate_state == GATE_STATE.CLOSED && instance_exists(oPlayer)) {
    var _p = instance_find(oPlayer, 0);
    if (_p.x > x - 32 && _p.x < x && abs(_p.y - (y + 24)) < 36) {
        gate_state = GATE_STATE.OPENING;
    }
} else if (gate_state == GATE_STATE.OPENING) {
    door_y = max(-48, door_y - 3);
    if (door_y <= -48) {
        gate_state = GATE_STATE.WALKING;
        walk_timer = 45;
    }
} else if (gate_state == GATE_STATE.WALKING) {
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        _p.x += 1.5;
        _p.facing = 1;
        _p.state = PLAYER_STATE.RUN;
    }
    walk_timer--;
    if (walk_timer <= 0) {
        gate_state = GATE_STATE.CLOSING;
    }
} else if (gate_state == GATE_STATE.CLOSING) {
    door_y = min(0, door_y + 4);
    if (door_y >= 0) {
        gate_state = GATE_STATE.LOCKED;
        camera_shake(3, 8);
        // Trigger or spawn boss in Jungle Stage arena
        if (room_get_name(room) == "rStage_WebSpider") {
            if (instance_exists(obj_nightmare_zero)) {
                with (obj_nightmare_zero) {
                    if (state == NZ_STATE.SLEEP) {
                        visible = true;
                        nz_change_state(NZ_STATE.INTRO);
                    }
                }
            } else {
                var _boss = instance_create_layer(5250, 2080, "Instances", obj_nightmare_zero);
                _boss.facing = -1;
            }
        }
    }
}
