if (place_meeting(x, y, oSolid)) {
    instance_create_layer(x, y, "Instances", oFX_HitSpark);
    instance_destroy();
    return;
}
var _tgt = instance_place(x, y, oTargetDummy);
if (_tgt != noone && ds_list_find_index(hit_list, _tgt) == -1) {
    ds_list_add(hit_list, _tgt);
    deal_damage_to_target(_tgt, damage, x, y);
    camera_shake(2, 6);
}
life--;
if (life <= 0) instance_destroy();
