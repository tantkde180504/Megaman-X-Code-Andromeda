bob_timer++;
if (instance_exists(oPlayer)) {
    if (place_meeting(x, y, oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        _p.hp_max += 2;
        _p.hp_current = _p.hp_max;
        camera_shake(3, 10);
        if (object_exists(oFX_HitSpark)) {
            instance_create_layer(x, y, "Instances", oFX_HitSpark);
        }
        instance_destroy();
    }
}
