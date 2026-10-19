/// @desc Web Projectile Step
vsp += grav;
x += hsp;
y += vsp;
anim_timer += 0.25;
lifetime--;

if (lifetime <= 0) {
    instance_destroy();
    return;
}

// Terrain collision
if (place_meeting(x, y, oSolid)) {
    if (object_exists(oFX_HitSpark)) {
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
    }
    instance_destroy();
    return;
}

// Player collision & damage
if (instance_exists(oPlayer)) {
    var _p = instance_nearest(x, y, oPlayer);
    if (place_meeting(x, y, _p)) {
        if (_p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
            var _kdir = (hsp != 0) ? sign(hsp) : ((_p.x >= x) ? 1 : -1);
            player_take_damage(damage, _kdir);
            instance_destroy();
            return;
        }
    }
}
