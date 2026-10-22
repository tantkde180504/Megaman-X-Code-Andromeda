// Custom death interception (Row 3 skull & Row 4 burst)
if (hp <= 0 && state != 3) {
    is_dead = true;
    state = 3; // DESTROYED
    state_timer = 0;
    contact_damage = 0;
    skull_x = x;
    skull_y = y;
    skull_vsp = -2.5;
    skull_hsp = (target != noone && target.x < x) ? 1.0 : -1.0;
    camera_shake(2, 6);
}

if (state == 3) {
    // DESTROYED sequence (Row 3 skull falling & Row 4 burst)
    state_timer++;
    skull_x += skull_hsp;
    skull_y += skull_vsp;
    skull_vsp += 0.25;
    
    if (state_timer >= 24) {
        // Roll item drops
        var _roll = random(100);
        if (_roll < 22) {
            instance_create_layer(x, y - 8, "Instances", oPickup_LifeSmall);
        } else if (_roll < 30) {
            instance_create_layer(x, y - 8, "Instances", oPickup_LifeLarge);
        } else if (_roll < 32) {
            instance_create_layer(x, y - 8, "Instances", oPickup_1UP);
        }
        instance_destroy();
    }
    return;
}

event_inherited();
if (is_dead || stage_frozen) return;

state_timer++;

switch (state) {
    case 0: // WAIT (Row 1, 4 frame đầu: 0..3): Đang đợi trong khi giữ bom
        hsp = 0;
        // Hover gently in place
        y = start_y + sin(anim_timer * 0.08) * 3;
        
        // Spot player in detection zone
        if (target != noone) {
            var _dx = abs(target.x - x);
            var _dy = target.y - y;
            if (_dx < 180 && _dy > -32 && _dy < 240) {
                facing = (target.x >= x) ? 1 : -1;
                state = 1; // DROP_BOMB
                state_timer = 0;
            }
        }
        break;

    case 1: // DROP_BOMB (Row 1, frame 5, 6: 4..5): Mở móng thả bom và bắt đầu bay
        hsp = facing * 0.6;
        x += hsp;
        // At frame 5/6 release the bomb (Row 5 bomb object)
        if (state_timer == 6) {
            var _bomb = instance_create_layer(x, y + 16, "Instances", oEnemy_BattonBomb);
            _bomb.damage = projectile_damage;
            _bomb.hsp = facing * 0.5;
            _bomb.vsp = 1.8;
            camera_shake(1, 2);
        }
        if (state_timer >= 14) {
            state = 2; // SWOOP_FLIGHT (Row 2)
            state_timer = 0;
        }
        break;

    case 2: // SWOOP_FLIGHT (Row 2, 6 frames): Bay tự do lượn quanh phát hiện địch
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        hsp = facing * 1.8;
        vsp = sin(anim_timer * 0.12) * 2.2;
        x += hsp;
        y += vsp;
        
        // After swooping around for a while, re-ascend towards start height
        if (state_timer > 200) {
            y = lerp(y, start_y, 0.03);
            if (abs(y - start_y) < 6) {
                state = 0; // Return to wait
                state_timer = 0;
            }
        }
        break;
}
