. "d:\MZ4\obj_helper.ps1"

# 1. oTrigger_Checkpoint
Create-GMObject -Name "oTrigger_Checkpoint" -Folder "Environment" -SpriteName "sTrigger" -Events @{
    "0_0" = @"
activated = false;
anim_timer = 0;
"@;
    "3_0" = @"
anim_timer++;
if (!activated && instance_exists(oPlayer)) {
    if (place_meeting(x, y, oPlayer)) {
        activated = true;
        global.checkpoint_x = x;
        global.checkpoint_y = y;
        camera_shake(1, 6);
        if (object_exists(oFX_HitSpark)) {
            instance_create_layer(x, y - 8, "Instances", oFX_HitSpark);
        }
    }
}
"@;
    "8_0" = @"
draw_self();
if (activated) {
    draw_set_color(make_color_rgb(40, 255, 120));
    draw_circle(x + 4, y - 4, 3, false);
}
"@
}

# 2. oTrigger_BossGate
Create-GMObject -Name "oTrigger_BossGate" -Folder "Environment" -SpriteName "sBossGate" -Solid $true -Events @{
    "0_0" = @"
gate_state = GATE_STATE.CLOSED;
door_y = 0;
walk_timer = 0;
"@;
    "3_0" = @"
if (gate_state == GATE_STATE.CLOSED && instance_exists(oPlayer)) {
    var _p = instance_find(oPlayer, 0);
    if (_p.x > x - 32 && _p.x < x && abs(_p.y - (y + 24)) < 36) {
        gate_state = GATE_STATE.OPENING;
    }
} else if (gate_state == GATE_STATE.OPENING) {
    door_y = max(-48, door_y - 3);
    if (door_y <= -48) {
        gate_state = GATE_STATE.WALKING;
        walk_timer = 45;
    }
} else if (gate_state == GATE_STATE.WALKING) {
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        _p.x += 1.5;
        _p.facing = 1;
        _p.state = PLAYER_STATE.RUN;
    }
    walk_timer--;
    if (walk_timer <= 0) {
        gate_state = GATE_STATE.CLOSING;
    }
} else if (gate_state == GATE_STATE.CLOSING) {
    door_y = min(0, door_y + 4);
    if (door_y >= 0) {
        gate_state = GATE_STATE.LOCKED;
        camera_shake(3, 8);
    }
}
"@;
    "8_0" = @"
// Draw frame
draw_set_color(make_color_rgb(50, 60, 75));
draw_rectangle(x - 2, y, x + 18, y + 48, false);

// Draw door slider
draw_sprite(sprite_index, 0, x, y + door_y);
"@
}

# 3. oPlatform_Falling
Create-GMObject -Name "oPlatform_Falling" -Folder "Environment" -SpriteName "sPlatform_Falling" -Events @{
    "0_0" = @"
fall_timer = 0;
falling = false;
vsp = 0;
orig_x = x;
orig_y = y;
respawn_timer = 0;
"@;
    "3_0" = @"
if (!falling) {
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        if (_p.grounded && place_meeting(x, y - 1, _p)) {
            fall_timer++;
            if (fall_timer >= 22) {
                falling = true;
            }
        }
    }
} else {
    vsp += 0.25;
    y += vsp;
    if (y > room_height + 32) {
        respawn_timer++;
        if (respawn_timer >= 120) {
            x = orig_x;
            y = orig_y;
            falling = false;
            vsp = 0;
            fall_timer = 0;
            respawn_timer = 0;
        }
    }
}
"@;
    "8_0" = @"
if (fall_timer > 0 && !falling) {
    var _shk = (fall_timer % 4 < 2) ? -1 : 1;
    draw_sprite(sprite_index, 0, x + _shk, y);
} else {
    draw_self();
}
"@
}

# 4. oIceSurface
Create-GMObject -Name "oIceSurface" -Folder "Environment" -SpriteName "sIce" -Solid $true -Events @{}

# 5. oWater
Create-GMObject -Name "oWater" -Folder "Environment" -SpriteName "sWater" -Events @{
    "8_0" = @"
draw_set_alpha(0.65);
draw_self();
draw_set_alpha(1.0);
"@
}

# 6. oWebTrap
Create-GMObject -Name "oWebTrap" -Folder "Environment" -SpriteName "sWebTrap" -Events @{
    "0_0" = @"
hp = 3;
flash_timer = 0;
"@;
    "3_0" = @"
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
"@;
    "8_0" = @"
if (flash_timer > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_self();
    gpu_set_fog(false, c_white, 0, 0);
} else {
    draw_self();
}
"@
}

# 7. oPickup_HeartTank
Create-GMObject -Name "oPickup_HeartTank" -Folder "Environment" -SpriteName "sHeartTank" -Events @{
    "0_0" = @"
bob_timer = 0;
"@;
    "3_0" = @"
bob_timer++;
if (instance_exists(oPlayer)) {
    if (place_meeting(x, y, oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        _p.hp_max += 2;
        _p.hp_current = _p.hp_max;
        camera_shake(3, 10);
        if (object_exists(oFX_HitSpark)) {
            instance_create_layer(x, y, "Instances", oFX_HitSpark);
        }
        instance_destroy();
    }
}
"@;
    "8_0" = @"
var _oy = sin(bob_timer * 0.1) * 3;
draw_sprite(sprite_index, 0, x, y + _oy);
"@
}

# 8. oPickup_SubTank
Create-GMObject -Name "oPickup_SubTank" -Folder "Environment" -SpriteName "sSubTank" -Events @{
    "0_0" = @"
bob_timer = 0;
"@;
    "3_0" = @"
bob_timer++;
if (instance_exists(oPlayer)) {
    if (place_meeting(x, y, oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        _p.hp_current = _p.hp_max;
        camera_shake(2, 8);
        if (object_exists(oFX_HitSpark)) {
            instance_create_layer(x, y, "Instances", oFX_HitSpark);
        }
        instance_destroy();
    }
}
"@;
    "8_0" = @"
var _oy = sin(bob_timer * 0.1) * 3;
draw_sprite(sprite_index, 0, x, y + _oy);
"@
}

# 9. oCapsule_Light
Create-GMObject -Name "oCapsule_Light" -Folder "Environment" -SpriteName "sCapsule_Light" -Events @{
    "0_0" = @"
activated = false;
text_timer = 0;
"@;
    "3_0" = @"
if (!activated && instance_exists(oPlayer)) {
    var _p = instance_find(oPlayer, 0);
    if (point_distance(x, y, _p.x, _p.y) < 28) {
        activated = true;
        text_timer = 180;
        global.has_air_dash = true;
        _p.has_air_dash = true;
        camera_shake(4, 15);
        if (object_exists(oFX_HitSpark)) {
            instance_create_layer(x, y - 24, "Instances", oFX_HitSpark);
        }
    }
}
if (text_timer > 0) text_timer--;
"@;
    "8_0" = @"
draw_self();

// Glow when activated
if (activated) {
    draw_set_color(make_color_rgb(100, 220, 255));
    draw_set_alpha(0.5);
    draw_circle(x, y - 24, 16, true);
    draw_set_alpha(1.0);
}

// Dr. Light Dialogue Banner
if (text_timer > 0) {
    var _cx = camera_get_view_x(view_camera[0]);
    var _cy = camera_get_view_y(view_camera[0]);
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_cx + 20, _cy + 20, _cx + VIEW_WIDTH - 20, _cy + 70, false);
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(100, 220, 255));
    draw_rectangle(_cx + 20, _cy + 20, _cx + VIEW_WIDTH - 20, _cy + 70, true);
    draw_text(_cx + 28, _cy + 26, "DR. LIGHT CAPSULE:");
    draw_set_color(c_white);
    draw_text(_cx + 28, _cy + 42, "Take this Leg Parts upgrade! Press DASH in mid-air to AIR DASH!");
}
"@
}

# 10. oParallaxBackground
Create-GMObject -Name "oParallaxBackground" -Folder "Environment" -Persistent $true -Events @{
    "0_0" = @"
depth = 500;
"@;
    "8_0" = @"
var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);

// Draw Far Mountain Background
var _far_x = (_cx * 0.15) mod VIEW_WIDTH;
draw_sprite(sBG_Far, 0, _cx - _far_x, _cy);
draw_sprite(sBG_Far, 0, _cx - _far_x + VIEW_WIDTH, _cy);

// Draw Mid Hills / Forest Background
var _mid_x = (_cx * 0.45) mod VIEW_WIDTH;
draw_sprite(sBG_Mid, 0, _cx - _mid_x, _cy);
draw_sprite(sBG_Mid, 0, _cx - _mid_x + VIEW_WIDTH, _cy);
"@
}

Write-Host "All Phase 2 objects created successfully!"
