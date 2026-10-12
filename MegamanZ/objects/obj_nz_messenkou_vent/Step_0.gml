/// @desc Vent Countdown & Beam Eruption
timer--;
if (timer <= 0) {
    var _beam = instance_create_layer(x, y, "Instances", obj_nz_messenkou_beam);
    _beam.damage = damage + 1;
    instance_destroy();
}
