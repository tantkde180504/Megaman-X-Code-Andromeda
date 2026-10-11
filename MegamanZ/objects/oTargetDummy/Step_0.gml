if (flash_timer > 0) flash_timer--;
if (hp <= 0) {
    hp = hp_max;
    camera_shake(3, 8);
    instance_create_layer(x, y - 18, "Instances", oFX_HitSpark);
}
