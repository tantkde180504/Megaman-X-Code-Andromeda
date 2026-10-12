anim_timer++;
if (flash_timer > 0) flash_timer--;

// Check death
if (hp <= 0) {
    var _ey = (bbox_bottom + bbox_top) / 2;
    instance_create_layer(x, _ey, "Instances", oFX_EnemyExplosion);
    camera_shake(2, 6);
    
    // Roll item drops
    var _roll = random(100);
    if (_roll < 22) {
        instance_create_layer(x, y - 8, "Instances", oPickup_LifeSmall);
    } else if (_roll < 30) {
        instance_create_layer(x, y - 8, "Instances", oPickup_LifeLarge);
    } else if (_roll < 32) {
        instance_create_layer(x, y - 8, "Instances", oPickup_1UP);
    }
    
    instance_destroy();
    return;
}

// Contact damage to player
if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        var _kdir = (_p.x >= x) ? 1 : -1;
        player_take_damage(contact_damage, _kdir);
    }
}
