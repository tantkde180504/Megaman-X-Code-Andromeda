/// @desc Boss Parent Physics & Logic Update
// Đếm ngược hiệu ứng nhấp nháy trắng & bất tử
if (flash_timer > 0) flash_timer--;
if (invulnerability_timer > 0) invulnerability_timer--;

// Tìm kiếm mục tiêu người chơi
if (instance_exists(oPlayer)) {
    target = instance_nearest(x, y, oPlayer);
} else {
    target = noone;
}

// Kiểm tra chuyển Phase (khi máu giảm xuống <= 50%)
if (hp <= max_hp * 0.5 && phase == 1) {
    phase = 2;
}

// Xử lý vật lý trọng lực và va chạm với oSolid
vsp = min(vsp + grav, 10);

// Va chạm ngang với địa hình
if (place_meeting(x + hsp, y, oSolid)) {
    while (!place_meeting(x + sign(hsp), y, oSolid)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

// Va chạm dọc với địa hình
if (place_meeting(x, y + vsp, oSolid)) {
    while (!place_meeting(x, y + sign(vsp), oSolid)) {
        y += sign(vsp);
    }
    vsp = 0;
    grounded = true;
} else {
    grounded = false;
}
y += vsp;

// Sát thương va chạm (Contact Damage) với Người Chơi
if (!is_dead && !is_invulnerable && target != noone) {
    if (place_meeting(x, y, target)) {
        if (target.iframes <= 0 && target.state != PLAYER_STATE.HURT && target.state != PLAYER_STATE.DEATH) {
            var _kdir = (target.x >= x) ? 1 : -1;
            player_take_damage(contact_damage, _kdir);
        }
    }
}
