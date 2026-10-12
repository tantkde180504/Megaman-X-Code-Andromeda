event_inherited();
if (hp <= 0) return;

switch (state) {
    case 0: // FLY across area
        hsp = facing * 2.0;
        y = start_y + sin(anim_timer * 0.1) * 8;
        x += hsp;
        
        if (x < 16 || x > room_width - 16 || place_meeting(x + hsp * 2, y, oSolid)) {
            facing = -facing;
        }
        
        // When overhead player, drop bomb!
        if (instance_exists(oPlayer) && abs(oPlayer.x - x) < 28 && oPlayer.y > y) {
            state = 1;
            state_timer = 0;
        }
        break;

    case 1: // DROP BOMB
        hsp = facing * 0.8;
        x += hsp;
        state_timer++;
        if (state_timer == 6) {
            var _bomb = instance_create_layer(x, y + 16, "Instances", oEnemyBullet);
            _bomb.hsp = 0;
            _bomb.vsp = 2.8;
            camera_shake(1, 3);
        }
        if (state_timer > 24) {
            state = 0;
            state_timer = 0;
        }
        break;
}
