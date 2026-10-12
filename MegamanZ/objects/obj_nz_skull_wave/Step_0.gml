/// @desc Skull Movement & Floor Hugging
x += hsp;
life--;
burst_timer++;

image_xscale = (hsp >= 0) ? -1 : 1;

// Giữ đạn bám sát mặt đất
if (!place_meeting(x, y + 1, oSolid) && y < room_height - 16) {
    y += 2;
} else if (place_meeting(x, y, oSolid)) {
    y -= 1;
}

// Định kỳ sinh các đợt nổ bùng mặt đất phía sau
if (burst_timer >= 12) {
    burst_timer = 0;
    instance_create_layer(x - hsp * 2, y, "Instances", obj_nz_floor_burst);
}

if (life <= 0 || place_meeting(x + hsp, y, oSolid)) {
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
