/// @desc Giant Web Network Step
anim_timer += 0.2;
pulse_timer++;

if (build_timer < build_duration) {
    build_timer++;
    // When rays reach outer nodes (~tick 25), spawn electric hit sparks at all nodes
    if (build_timer == 25) {
        camera_shake(2, 6);
        for (var i = 1; i <= 8; i++) {
            if (object_exists(oFX_HitSpark)) {
                instance_create_layer(web_nodes[i][0], web_nodes[i][1], "Instances", oFX_HitSpark);
            }
        }
    }
} else {
    is_active = true;
}
