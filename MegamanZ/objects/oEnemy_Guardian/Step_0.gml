event_inherited();
if (hp <= 0) return;

if (instance_exists(oPlayer)) {
    facing = (oPlayer.x >= x) ? 1 : -1;
}

switch (state) {
    case 0: // FLOAT & SCAN
        x = start_x + sin(anim_timer * 0.04) * 24;
        y = start_y + cos(anim_timer * 0.06) * 10;
        if (instance_exists(oPlayer) && point_distance(x, y, oPlayer.x, oPlayer.y) < 200) {
            state = 1;
            state_timer = 0;
        }
        break;

    case 1: // LOCK TARGET & CHARGE
        state_timer++;
        if (state_timer > 30) {
            state = 2;
            state_timer = 0;
        }
        break;

    case 2: // FIRE BEAM / SPREAD
        state_timer++;
        if (state_timer == 2 && instance_exists(oPlayer)) {
            var _base_dir = point_direction(x, y, oPlayer.x, oPlayer.y);
            
            var _b1 = instance_create_layer(x + facing * 12, y, "Instances", oEnemyBullet);
            _b1.hsp = lengthdir_x(3.2, _base_dir - 12);
            _b1.vsp = lengthdir_y(3.2, _base_dir - 12);
            
            var _b2 = instance_create_layer(x + facing * 12, y, "Instances", oEnemyBullet);
            _b2.hsp = lengthdir_x(3.2, _base_dir + 12);
            _b2.vsp = lengthdir_y(3.2, _base_dir + 12);
            
            camera_shake(2, 6);
        }
        if (state_timer > 40) {
            state = 0;
            state_timer = 0;
        }
        break;
}
