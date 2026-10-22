if (variable_global_exists("stage_ready") && !global.stage_ready) return;

timer++;
vsp += grav;

// Ground / Solid bounce
if (place_meeting(x, y + vsp, oSolid)) {
    while (!place_meeting(x, y + sign(vsp), oSolid)) y += sign(vsp);
    vsp = -vsp * 0.52;
    hsp *= 0.72;
    bounce_count++;
}
y += vsp;

if (place_meeting(x + hsp, y, oSolid)) {
    hsp = -hsp * 0.5;
}
x += hsp;

fuse_timer--;

// Detonation check: fuse time or direct player hit after first frame
var _hit_player = false;
if (timer > 6 && instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        _hit_player = true;
    }
}

if (fuse_timer <= 0 || _hit_player) {
    // Explosion burst!
    instance_create_layer(x, y - 8, "Instances", oFX_EnemyExplosion);
    camera_shake(3, 8);
    
    // Blast radius damage
    if (instance_exists(oPlayer)) {
        var _dist = point_distance(x, y, oPlayer.x, oPlayer.y - 16);
        if (_dist < 32 && oPlayer.iframes <= 0 && oPlayer.state != PLAYER_STATE.HURT && oPlayer.state != PLAYER_STATE.DEATH) {
            player_take_damage(damage, (oPlayer.x >= x) ? 1 : -1);
        }
    }
    instance_destroy();
}
