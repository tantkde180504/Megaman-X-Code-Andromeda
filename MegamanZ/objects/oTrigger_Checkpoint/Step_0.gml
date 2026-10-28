anim_timer++;
if (!activated && instance_exists(oPlayer)) {
    if (place_meeting(x, y, oPlayer)) {
        activated = true;
        var _p = instance_place(x, y, oPlayer);
        if (_p != noone) {
            global.checkpoint_x = _p.x;
            global.checkpoint_y = _p.y;
        } else {
            global.checkpoint_x = x;
            global.checkpoint_y = y;
        }
        camera_shake(1, 6);
        if (object_exists(oFX_HitSpark)) {
            instance_create_layer(x, y - 8, "Instances", oFX_HitSpark);
        }
    }
}
