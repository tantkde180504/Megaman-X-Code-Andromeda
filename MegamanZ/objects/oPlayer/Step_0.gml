anim_timer++;
if (iframes > 0) iframes--;
player_state_execute();
player_handle_movement_and_collision();

// Debug shortcut: Press 'B' or 'F8' to teleport straight to Nightmare Zero arena in rStage_WebSpider
if (keyboard_check_pressed(ord("B")) || keyboard_check_pressed(vk_f8)) {
    if (room_get_name(room) == "rStage_WebSpider") {
        x = 4820;
        y = 2050;
        hsp = 0;
        vsp = 0;
    }
}

