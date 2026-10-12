event_inherited();
if (hp <= 0) return;

if (instance_exists(oPlayer)) {
    facing = (oPlayer.x >= x) ? 1 : -1;
}

switch (state) {
    case 0: // HOVER
        y = start_y + sin(anim_timer * 0.08) * 8;
        state_timer++;
        if (state_timer > 95 && instance_exists(oPlayer) && abs(oPlayer.x - x) < 260) {
            state = 1;
            state_timer = 0;
        }
        break;

    case 1: // AIM & SHOOT
        y = start_y + sin(anim_timer * 0.08) * 4;
        state_timer++;
        if (state_timer == 18 && instance_exists(oPlayer)) {
            var _dir = point_direction(x + facing * 14, y, oPlayer.x, oPlayer.y - 16);
            var _b = instance_create_layer(x + facing * 14, y, "Instances", oEnemyBullet);
            _b.hsp = lengthdir_x(3.2, _dir);
            _b.vsp = lengthdir_y(3.2, _dir);
            camera_shake(1, 4);
        }
        if (state_timer > 40) {
            state = 0;
            state_timer = 0;
        }
        break;
}
