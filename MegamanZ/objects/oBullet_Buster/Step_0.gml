if (place_meeting(x, y, oSolid)) {
    instance_create_layer(x, y, "Instances", oFX_HitSpark);
    instance_destroy();
    return;
}
var _tgt = instance_place(x, y, oEnemyParent);
if (_tgt != noone) {
    if (variable_instance_exists(_tgt, "is_deflecting") && _tgt.is_deflecting) {
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
        camera_shake(1, 4);
        instance_destroy();
        return;
    } else {
        deal_damage_to_target(_tgt, damage, x, y);
        instance_destroy();
        return;
    }
}
life--;
if (life <= 0) instance_destroy();
