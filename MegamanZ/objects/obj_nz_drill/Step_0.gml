/// @desc Drill Movement & Collision
x += hsp;
y += vsp;
life--;

image_xscale = (hsp >= 0) ? -1 : 1;
if (hsp >= 0) {
    image_angle = point_direction(0, 0, hsp, vsp);
} else {
    image_angle = point_direction(0, 0, -hsp, -vsp);
}

if (life <= 0 || place_meeting(x, y, oSolid) || x < -60 || x > room_width + 60 || y < -60 || y > room_height + 60) {
    instance_create_layer(x, y, "Instances", oFX_HitSpark);
    instance_destroy();
    return;
}

if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone && _p.iframes <= 0 && _p.state != PLAYER_STATE.HURT && _p.state != PLAYER_STATE.DEATH) {
        player_take_damage(damage, (hsp >= 0) ? 1 : -1);
        instance_create_layer(x, y, "Instances", oFX_HitSpark);
        instance_destroy();
        return;
    }
}
