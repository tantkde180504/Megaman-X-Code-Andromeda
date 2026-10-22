if (variable_global_exists("stage_ready") && !global.stage_ready) {
    stage_frozen = true;
    return;
}
stage_frozen = false;

anim_timer++;
if (flash_timer > 0) flash_timer--;
if (invulnerability_timer > 0) invulnerability_timer--;
if (attack_cooldown > 0) attack_cooldown--;

// Target Acquisition
if (instance_exists(oPlayer)) {
    target = instance_nearest(x, y, oPlayer);
} else {
    target = noone;
}

// Check Death
if (hp <= 0 && !is_dead) {
    is_dead = true;
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

// Contact Damage with Player
if (!is_dead && target != noone) {
    if (place_meeting(x, y, target)) {
        if (target.iframes <= 0 && target.state != PLAYER_STATE.HURT && target.state != PLAYER_STATE.DEATH) {
            var _kdir = (target.x >= x) ? 1 : -1;
            player_take_damage(contact_damage, _kdir);
        }
    }
}
