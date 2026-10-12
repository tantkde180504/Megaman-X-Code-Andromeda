timer++;
vsp = min(5.0, vsp + grav);
y += vsp;
x += hsp;

var _explode = false;

// Explode on ground
if (place_meeting(x, y, oSolid)) {
    _explode = true;
}

// Explode on player
if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        player_take_damage(damage, (_p.x >= x) ? 1 : -1);
        _explode = true;
    }
}

if (_explode) {
    instance_create_layer(x, y - 6, "Instances", oFX_EnemyExplosion);
    camera_shake(2, 6);
    instance_destroy();
}
