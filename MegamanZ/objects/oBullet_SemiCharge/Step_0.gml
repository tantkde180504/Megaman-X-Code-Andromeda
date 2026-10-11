if (place_meeting(x, y, oSolid)) {
    instance_create_layer(x, y, "Instances", oFX_HitSpark);
    instance_destroy();
    return;
}
var _tgt = instance_place(x, y, oTargetDummy);
if (_tgt != noone && _tgt != hit_target) {
    hit_target = _tgt;
    deal_damage_to_target(_tgt, damage, x, y);
}
life--;
if (life <= 0) instance_destroy();
