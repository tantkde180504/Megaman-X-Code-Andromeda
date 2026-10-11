if (!activated && instance_exists(oPlayer)) {
    var _p = instance_find(oPlayer, 0);
    if (point_distance(x, y, _p.x, _p.y) < 28) {
        activated = true;
        text_timer = 180;
        global.has_air_dash = true;
        _p.has_air_dash = true;
        camera_shake(4, 15);
        if (object_exists(oFX_HitSpark)) {
            instance_create_layer(x, y - 24, "Instances", oFX_HitSpark);
        }
    }
}
if (text_timer > 0) text_timer--;
