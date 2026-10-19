anim_timer++;
if (iframes > 0) iframes--;
player_state_execute();
player_handle_movement_and_collision();

// Debug shortcuts:
// 'B' or 'F8': Teleport directly in front of Door 1 (Note 1 - Entrance to Save Corridor)
if (keyboard_check_pressed(ord("B")) || keyboard_check_pressed(vk_f8)) {
    if (room_get_name(room) == "rStage_WebSpider") {
        x = 4760;
        y = 2000;
        hsp = 0;
        vsp = 0;
    }
}
// 'N' or 'F9': Teleport in save corridor in front of Door 2 (Note 2 - Entrance to Boss Cave)
if (keyboard_check_pressed(ord("N")) || keyboard_check_pressed(vk_f9)) {
    if (room_get_name(room) == "rStage_WebSpider") {
        x = 5040;
        y = 2048;
        hsp = 0;
        vsp = 0;
    }
}
// Web bound status handling (from Lightning Web)
if (variable_instance_exists(id, "is_web_bound") && is_web_bound) {
    web_bound_timer--;
    hsp = 0;
    
    // Delayed shock damage after 30 frames (4 damage as per specification)
    if (variable_instance_exists(id, "web_bound_damage_timer")) {
        if (web_bound_damage_timer > 0) {
            web_bound_damage_timer--;
            if (web_bound_damage_timer == 0) {
                player_take_damage(4, 0);
            }
        }
    }
    
    if (web_bound_timer <= 0) {
        is_web_bound = false;
    }
}

// 'K' or 'F10': Spawn Web Spider boss for testing
if (keyboard_check_pressed(ord("K")) || keyboard_check_pressed(vk_f10)) {
    if (!instance_exists(obj_boss_web_spider) && !instance_exists(oBoss_WebSpider)) {
        if (instance_exists(obj_nightmare_zero)) with (obj_nightmare_zero) instance_destroy();
        var _spawn_x = (room_get_name(room) == "rStage_WebSpider") ? 5250 : x + (facing * 120);
        var _spawn_y = (room_get_name(room) == "rStage_WebSpider") ? 1900 : y - 60;
        instance_create_layer(_spawn_x, _spawn_y, "Instances", obj_boss_web_spider);
    }
}


