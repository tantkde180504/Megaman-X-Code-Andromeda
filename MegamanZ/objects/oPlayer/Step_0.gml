anim_timer++;
if (iframes > 0) iframes--;
player_state_execute();
player_handle_movement_and_collision();

// Debug shortcuts:
// 'B' or 'F8': Teleport directly in front of Door 1 (Circle 1 - Entrance to Save Corridor)
if (keyboard_check_pressed(ord("B")) || keyboard_check_pressed(vk_f8)) {
    if (room_get_name(room) == "rStage_WebSpider") {
        x = 4620;
        y = 1984;
        hsp = 0;
        vsp = 0;
    }
}
// 'N' or 'F9': Teleport in save corridor in front of Door 2 (Circle 2 - Entrance to Boss Cave)
if (keyboard_check_pressed(ord("N")) || keyboard_check_pressed(vk_f9)) {
    if (room_get_name(room) == "rStage_WebSpider") {
        x = 4750;
        y = 1984;
        hsp = 0;
        vsp = 0;
    }
}

