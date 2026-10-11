anim_timer++;
if (!activated && instance_exists(oPlayer)) {
    if (place_meeting(x, y, oPlayer)) {
        activated = true;
        global.checkpoint_x = x;
        global.checkpoint_y = y;
        camera_shake(1, 6);
        if (object_exists(oFX_HitSpark)) {
            instance_create_layer(x, y - 8, "Instances", oFX_HitSpark);
        }
    }
}
