/// @desc Dọn dẹp tài nguyên và trạng thái khi hủy đối tượng (CleanUp Event)

gpu_set_blendmode(bm_normal);
gpu_set_fog(false, c_white, 0, 0);
draw_set_alpha(1.0);
draw_set_color(c_white);

// Đảm bảo nhân vật luôn hiển thị lại nếu hiệu ứng kết thúc
if (instance_exists(player_id)) {
    player_id.visible = true;
    if (player_id.state == PLAYER_STATE.DEATH) {
        player_id.state = PLAYER_STATE.IDLE;
        player_id.iframes = 60;
    }
}

global.screen_fade_alpha = 0.0;
rings = [];
sparks = [];
