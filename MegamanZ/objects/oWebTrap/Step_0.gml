if (flash_timer > 0) flash_timer--;

// Hit by projectiles
var _b = instance_place(x, y, oBullet_Buster);
if (_b != noone) {
    hp -= _b.damage;
    flash_timer = 6;
    instance_destroy(_b);
}
var _cb = instance_place(x, y, oBullet_FullCharge);
if (_cb != noone) {
    hp -= _cb.damage;
    flash_timer = 6;
}
var _sh = instance_place(x, y, oSaberHitbox);
if (_sh != noone) {
    hp -= _sh.damage;
    flash_timer = 6;
}

if (hp <= 0) {
    if (object_exists(oFX_HitSpark)) {
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
    }
    instance_destroy();
}
