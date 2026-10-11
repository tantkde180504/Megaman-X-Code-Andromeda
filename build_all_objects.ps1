. "d:\MZ4\obj_helper.ps1"

# 1. oGame
Create-GMObject -Name "oGame" -Folder "Core" -Persistent $true -Events @{
    "0_0" = @"
window_set_size(VIEW_WIDTH * 2, VIEW_HEIGHT * 2);
surface_resize(application_surface, VIEW_WIDTH, VIEW_HEIGHT);
display_set_gui_size(VIEW_WIDTH, VIEW_HEIGHT);

global.current_char = CHAR_TYPE.X;
global.debug_overlay = false;

if (!instance_exists(oInput)) instance_create_layer(0, 0, "Instances", oInput);
if (!instance_exists(oCamera)) instance_create_layer(0, 0, "Instances", oCamera);
if (!instance_exists(oUI_HUD)) instance_create_layer(0, 0, "Instances", oUI_HUD);
"@;
    "3_0" = @"
if (global.input.tab_pressed) {
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        var _px = _p.x;
        var _py = _p.y;
        var _pfacing = _p.facing;
        var _php = _p.hp_current;
        var _pstate = _p.state;
        var _phsp = _p.hsp;
        var _pvsp = _p.vsp;
        
        with (_p) { instance_destroy(); }
        
        var _new_obj = (global.current_char == CHAR_TYPE.X) ? oPlayerZero : oPlayerX;
        global.current_char = (global.current_char == CHAR_TYPE.X) ? CHAR_TYPE.ZERO : CHAR_TYPE.X;
        
        var _new_p = instance_create_layer(_px, _py, "Instances", _new_obj);
        _new_p.facing = _pfacing;
        _new_p.hp_current = _php;
        _new_p.state = _pstate;
        _new_p.hsp = _phsp;
        _new_p.vsp = _pvsp;
        
        camera_shake(2, 6);
    }
}

if (global.input.restart_pressed) {
    room_restart();
}

if (global.input.debug_pressed) {
    global.debug_overlay = !global.debug_overlay;
}
"@;
    "7_4" = @"
if (!instance_exists(oInput)) instance_create_layer(0, 0, "Instances", oInput);
if (!instance_exists(oCamera)) instance_create_layer(0, 0, "Instances", oCamera);
if (!instance_exists(oUI_HUD)) instance_create_layer(0, 0, "Instances", oUI_HUD);

if (!instance_exists(oPlayer)) {
    var _obj = (global.current_char == CHAR_TYPE.X) ? oPlayerX : oPlayerZero;
    instance_create_layer(64, 180, "Instances", _obj);
}
"@;
    "8_64" = @"
if (global.debug_overlay) {
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(VIEW_WIDTH - 150, 4, VIEW_WIDTH - 4, 115, false);
    draw_set_alpha(1.0);
    draw_set_color(c_yellow);
    draw_text(VIEW_WIDTH - 146, 6, "DEBUG OVERLAY (F1)");
    draw_set_color(c_white);
    draw_text(VIEW_WIDTH - 146, 20, "FPS: " + string(fps) + " (" + string(fps_real) + ")");
    var _c_name = (global.current_char == CHAR_TYPE.X) ? "X" : "ZERO";
    draw_text(VIEW_WIDTH - 146, 34, "Char: " + _c_name + " [TAB]");
    if (instance_exists(oPlayer)) {
        var _p = instance_find(oPlayer, 0);
        var _state_names = ["IDLE", "RUN", "JUMP", "FALL", "DASH", "WALL_SLIDE", "WALL_JUMP", "LADDER", "HURT", "DEATH"];
        var _s_str = (_p.state < array_length(_state_names)) ? _state_names[_p.state] : string(_p.state);
        draw_text(VIEW_WIDTH - 146, 48, "State: " + _s_str);
        draw_text(VIEW_WIDTH - 146, 62, "Pos: " + string(round(_p.x)) + ", " + string(round(_p.y)));
        draw_text(VIEW_WIDTH - 146, 76, "Spd: " + string(_p.hsp) + ", " + string(_p.vsp));
        draw_text(VIEW_WIDTH - 146, 90, "Gnd: " + string(_p.grounded) + " | Wall: " + string(_p.touching_wall));
    }
}
"@
}

# 2. oInput
Create-GMObject -Name "oInput" -Folder "Core" -Persistent $true -Events @{
    "3_1" = @"
input_update();
"@
}

# 3. oCamera
Create-GMObject -Name "oCamera" -Folder "Core" -Persistent $true -Events @{
    "0_0" = @"
shake_intensity = 0;
shake_timer = 0;
shake_duration = 0;
cam_x = 0;
cam_y = 0;
"@;
    "3_2" = @"
if (instance_exists(oPlayer)) {
    var _p = instance_find(oPlayer, 0);
    var _pos = camera_update_follow(view_camera[0], _p.x, _p.y);
    cam_x = lerp(cam_x, _pos[0], 0.15);
    cam_y = lerp(cam_y, _pos[1], 0.15);
}

var _shk_x = 0;
var _shk_y = 0;
if (shake_timer > 0) {
    var _curr_intensity = shake_intensity * (shake_timer / max(1, shake_duration));
    _shk_x = random_range(-_curr_intensity, _curr_intensity);
    _shk_y = random_range(-_curr_intensity, _curr_intensity);
    shake_timer--;
} else {
    shake_intensity = 0;
}

camera_set_view_pos(view_camera[0], round(cam_x + _shk_x), round(cam_y + _shk_y));
"@
}

# 4. oUI_HUD
Create-GMObject -Name "oUI_HUD" -Folder "UI" -Persistent $true -Events @{
    "8_64" = @"
if (!instance_exists(oPlayer)) return;
var _p = instance_find(oPlayer, 0);

var _hx = 16;
var _hy = 16;
var _bar_h = 64;
var _bar_w = 8;

// Outer bracket
draw_set_color(c_black);
draw_rectangle(_hx - 2, _hy - 2, _hx + _bar_w + 1, _hy + _bar_h + 1, false);
draw_set_color(make_color_rgb(140, 160, 190));
draw_rectangle(_hx - 2, _hy - 2, _hx + _bar_w + 1, _hy + _bar_h + 1, true);

// HP bars
var _ticks = _p.hp_max;
var _tick_h = (_bar_h - 2) / _ticks;
for (var _i = 0; _i < _ticks; _i++) {
    var _by = _hy + _bar_h - 2 - ((_i + 1) * _tick_h);
    if (_i < _p.hp_current) {
        if (_p.hp_current <= 4) {
            draw_set_color(make_color_rgb(255, 60, 60));
        } else if (_p.hp_current <= 8) {
            draw_set_color(make_color_rgb(255, 210, 40));
        } else {
            draw_set_color(make_color_rgb(40, 240, 120));
        }
    } else {
        draw_set_color(make_color_rgb(40, 40, 50));
    }
    draw_rectangle(_hx, _by, _hx + _bar_w - 1, _by + _tick_h - 1, false);
}

// Icon & Label
if (global.current_char == CHAR_TYPE.X) {
    draw_set_color(make_color_rgb(60, 170, 255));
    draw_circle(_hx + 3, _hy - 8, 6, false);
    draw_set_color(c_white);
    draw_text(_hx - 1, _hy - 14, "X");
} else {
    draw_set_color(make_color_rgb(255, 50, 50));
    draw_circle(_hx + 3, _hy - 8, 6, false);
    draw_set_color(c_white);
    draw_text(_hx - 1, _hy - 14, "Z");
}

// Help banner
draw_set_color(c_black);
draw_set_alpha(0.6);
draw_rectangle(0, VIEW_HEIGHT - 14, VIEW_WIDTH, VIEW_HEIGHT, false);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(200, 220, 240));
draw_text(6, VIEW_HEIGHT - 13, "Arrows: Move | Z: Jump | X: Attack | C: Dash | V: Special | TAB: Switch | F1: Debug");
"@
}

# 5. Environment
Create-GMObject -Name "oSolid" -Folder "Environment" -SpriteName "sSolid" -Solid $true -Events @{}

Create-GMObject -Name "oOneWayPlatform" -Folder "Environment" -SpriteName "sOneWayPlatform" -Events @{}

Create-GMObject -Name "oHazardSpike" -Folder "Environment" -SpriteName "sHazardSpike" -Events @{
    "3_0" = @"
if (instance_exists(oPlayer)) {
    var _p = instance_place(x, y, oPlayer);
    if (_p != noone) {
        player_take_damage(4, -_p.facing);
    }
}
"@
}

Create-GMObject -Name "oLadder" -Folder "Environment" -SpriteName "sLadder" -Events @{}

Create-GMObject -Name "oTargetDummy" -Folder "Environment" -SpriteName "sTargetDummy" -Events @{
    "0_0" = @"
hp_max = 32;
hp = 32;
flash_timer = 0;
"@;
    "3_0" = @"
if (flash_timer > 0) flash_timer--;
if (hp <= 0) {
    hp = hp_max;
    camera_shake(3, 8);
    instance_create_layer(x, y - 18, "Instances", oFX_HitSpark);
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

var _bw = 24;
var _bh = 4;
var _bx = x - (_bw / 2);
var _by = bbox_top - 8;
draw_set_color(c_black);
draw_rectangle(_bx - 1, _by - 1, _bx + _bw + 1, _by + _bh + 1, false);
draw_set_color(c_red);
var _fill = max(0, (_bw * (hp / hp_max)));
draw_rectangle(_bx, _by, _bx + _fill, _by + _bh, false);
"@
}

# 6. FX
Create-GMObject -Name "oFX_DashDust" -Folder "Effects" -SpriteName "sFX_DashDust" -Events @{
    "0_0" = @"
image_alpha = 1.0;
"@;
    "3_0" = @"
image_alpha -= 0.1;
y -= 0.2;
if (image_alpha <= 0) instance_destroy();
"@
}

Create-GMObject -Name "oFX_HitSpark" -Folder "Effects" -SpriteName "sFX_HitSpark" -Events @{
    "0_0" = @"
image_alpha = 1.0;
image_xscale = 0.5;
image_yscale = 0.5;
"@;
    "3_0" = @"
image_alpha -= 0.12;
image_xscale += 0.1;
image_yscale += 0.1;
if (image_alpha <= 0) instance_destroy();
"@
}

# 7. Projectiles
Create-GMObject -Name "oBullet_Buster" -Folder "Weapons" -SpriteName "sBullet_Buster" -Events @{
    "0_0" = @"
damage = 1;
life = 60;
"@;
    "3_0" = @"
if (place_meeting(x, y, oSolid)) {
    instance_create_layer(x, y, "Instances", oFX_HitSpark);
    instance_destroy();
    return;
}
var _tgt = instance_place(x, y, oTargetDummy);
if (_tgt != noone) {
    deal_damage_to_target(_tgt, damage, x, y);
    instance_destroy();
    return;
}
life--;
if (life <= 0) instance_destroy();
"@
}

Create-GMObject -Name "oBullet_SemiCharge" -Folder "Weapons" -SpriteName "sBullet_SemiCharge" -Events @{
    "0_0" = @"
damage = 2;
life = 70;
hit_target = noone;
"@;
    "3_0" = @"
if (place_meeting(x, y, oSolid)) {
    instance_create_layer(x, y, "Instances", oFX_HitSpark);
    instance_destroy();
    return;
}
var _tgt = instance_place(x, y, oTargetDummy);
if (_tgt != noone && _tgt != hit_target) {
    hit_target = _tgt;
    deal_damage_to_target(_tgt, damage, x, y);
}
life--;
if (life <= 0) instance_destroy();
"@
}

Create-GMObject -Name "oBullet_FullCharge" -Folder "Weapons" -SpriteName "sBullet_FullCharge" -Events @{
    "0_0" = @"
damage = 4;
life = 80;
hit_list = ds_list_create();
"@;
    "3_0" = @"
if (place_meeting(x, y, oSolid)) {
    instance_create_layer(x, y, "Instances", oFX_HitSpark);
    instance_destroy();
    return;
}
var _tgt = instance_place(x, y, oTargetDummy);
if (_tgt != noone && ds_list_find_index(hit_list, _tgt) == -1) {
    ds_list_add(hit_list, _tgt);
    deal_damage_to_target(_tgt, damage, x, y);
    camera_shake(2, 6);
}
life--;
if (life <= 0) instance_destroy();
"@;
    "12_0" = @"
if (ds_exists(hit_list, ds_type_list)) ds_list_destroy(hit_list);
"@
}

Create-GMObject -Name "oSaberHitbox" -Folder "Weapons" -SpriteName "sSaberHitbox" -Events @{
    "0_0" = @"
damage = 2;
life = 6;
element = "slash";
hit_list = ds_list_create();
"@;
    "3_0" = @"
var _tgt = instance_place(x, y, oTargetDummy);
if (_tgt != noone && ds_list_find_index(hit_list, _tgt) == -1) {
    ds_list_add(hit_list, _tgt);
    deal_damage_to_target(_tgt, damage, x, y);
    camera_shake(2, 6);
}
life--;
if (life <= 0) instance_destroy();
"@;
    "12_0" = @"
if (ds_exists(hit_list, ds_type_list)) ds_list_destroy(hit_list);
"@
}

# 8. Player Base & Characters
Create-GMObject -Name "oPlayer" -Folder "Player" -SpriteName "sPlayerMask" -Events @{
    "0_0" = @"
player_physics_init();
state = PLAYER_STATE.IDLE;
hp_max = 16;
hp_current = 16;
iframes = 0;
hurt_timer = 0;
death_timer = 0;
is_dash_jumping = false;
anim_timer = 0;
"@;
    "3_0" = @"
anim_timer++;
if (iframes > 0) iframes--;
player_state_execute();
player_handle_movement_and_collision();
"@
}

Create-GMObject -Name "oPlayerX" -Folder "Player" -ParentName "oPlayer" -SpriteName "sPlayerMask" -Events @{
    "0_0" = @"
event_inherited();
charge_timer = 0;
charge_level = 0;
shoot_anim_timer = 0;
"@;
    "3_0" = @"
event_inherited();

// Buster Charging
if (global.input.shoot) {
    charge_timer++;
    if (charge_timer >= CHARGE_LV2_FRAMES) {
        charge_level = 2;
    } else if (charge_timer >= CHARGE_LV1_FRAMES) {
        charge_level = 1;
    } else {
        charge_level = 0;
    }
}

// Firing
if (global.input.shoot_released || (global.input.shoot_pressed && charge_timer < 5)) {
    var _bx = x + (facing * 14);
    var _by = y - 16;
    
    if (charge_level == 2) {
        var _b = instance_create_layer(_bx, _by, "Instances", oBullet_FullCharge);
        _b.hspeed = facing * 9;
        _b.image_xscale = facing;
        camera_shake(2, 6);
    } else if (charge_level == 1) {
        var _b = instance_create_layer(_bx, _by, "Instances", oBullet_SemiCharge);
        _b.hspeed = facing * 8;
        _b.image_xscale = facing;
    } else {
        if (instance_number(oBullet_Buster) < 3) {
            var _b = instance_create_layer(_bx, _by, "Instances", oBullet_Buster);
            _b.hspeed = facing * 7;
            _b.image_xscale = facing;
        }
    }
    
    charge_timer = 0;
    charge_level = 0;
    shoot_anim_timer = 12;
}

if (shoot_anim_timer > 0) shoot_anim_timer--;
"@;
    "8_0" = @"
// Iframes blinking
if (iframes > 0 && (iframes div 3) % 2 == 0) return;

// Draw X Character Visuals
var _c_primary = make_color_rgb(0, 140, 240);    // X Blue
var _c_secondary = make_color_rgb(0, 210, 255);  // Cyan trim
var _c_skin = make_color_rgb(255, 215, 175);
var _c_white = c_white;

// Feet / Shadow
draw_set_color(c_black);
draw_set_alpha(0.3);
draw_ellipse(x - 8, y - 2, x + 8, y + 2, false);
draw_set_alpha(1.0);

// Torso / Body
var _body_y = y - 22;
draw_set_color(_c_primary);
draw_rectangle(x - 6, _body_y, x + 6, y - 10, false);
draw_set_color(_c_secondary);
draw_circle(x, _body_y + 4, 3, false); // Chest core gem

// Legs
draw_set_color(_c_primary);
if (state == PLAYER_STATE.RUN) {
    var _leg_offset = sin(anim_timer * 0.3) * 4;
    draw_rectangle(x - 6, y - 10, x - 1, y + _leg_offset, false);
    draw_rectangle(x + 1, y - 10, x + 6, y - _leg_offset, false);
} else {
    draw_rectangle(x - 6, y - 10, x - 1, y, false);
    draw_rectangle(x + 1, y - 10, x + 6, y, false);
}

// Helmet & Face
var _head_y = y - 28;
draw_set_color(_c_primary);
draw_circle(x, _head_y, 7, false);
draw_set_color(_c_skin);
draw_rectangle(x - (facing * 2), _head_y - 2, x + (facing * 5), _head_y + 4, false);
draw_set_color(c_red);
draw_circle(x, _head_y - 3, 2, false); // Helmet forehead gem

// Buster Arm
var _arm_x = x + (facing * 8);
var _arm_y = y - 16;
draw_set_color(_c_primary);
draw_rectangle(_arm_x - 3, _arm_y - 3, _arm_x + 6, _arm_y + 3, false);
draw_set_color(_c_secondary);
draw_rectangle(_arm_x + 4, _arm_y - 2, _arm_x + 7, _arm_y + 2, false); // Buster muzzle

// Charge particles / aura
if (charge_level == 1) {
    draw_set_color(make_color_rgb(80, 255, 120));
    draw_set_alpha(0.6);
    var _pulse = (sin(anim_timer * 0.4) * 3);
    draw_circle(x, y - 16, 14 + _pulse, true);
    draw_set_alpha(1.0);
} else if (charge_level == 2) {
    draw_set_color(make_color_rgb(255, 100, 220));
    draw_set_alpha(0.7);
    var _pulse = (sin(anim_timer * 0.5) * 4);
    draw_circle(x, y - 16, 18 + _pulse, true);
    draw_set_color(make_color_rgb(40, 200, 255));
    draw_circle(x, y - 16, 12 - _pulse, true);
    draw_set_alpha(1.0);
}
"@
}

Create-GMObject -Name "oPlayerZero" -Folder "Player" -ParentName "oPlayer" -SpriteName "sPlayerMask" -Events @{
    "0_0" = @"
event_inherited();
combo_step = 0;
combo_timer = 0;
slash_anim_timer = 0;
technique_state = TECHNIQUE.NONE;
technique_timer = 0;
"@;
    "3_0" = @"
event_inherited();

// Techniques input (Special button)
if (global.input.special_pressed) {
    if (grounded && global.input.up) {
        technique_state = TECHNIQUE.RYUENJIN;
        technique_timer = 24;
        vsp = -6.5;
        hsp = facing * 1.0;
        var _h = instance_create_layer(x + (facing * 16), y - 24, "Instances", oSaberHitbox);
        _h.damage = 4;
        _h.element = "fire";
        camera_shake(3, 8);
    } else if (!grounded && global.input.down) {
        technique_state = TECHNIQUE.HYOURETSUZAN;
        technique_timer = 30;
        vsp = 8.0;
        hsp = 0;
        var _h = instance_create_layer(x, y + 8, "Instances", oSaberHitbox);
        _h.damage = 4;
        _h.element = "ice";
    } else if (!grounded) {
        technique_state = TECHNIQUE.KUUENZAN;
        technique_timer = 20;
        var _h = instance_create_layer(x, y - 16, "Instances", oSaberHitbox);
        _h.damage = 3;
        _h.element = "slash";
    } else {
        technique_state = TECHNIQUE.RAIJINGEKI;
        technique_timer = 22;
        hsp = 0;
        var _h = instance_create_layer(x + (facing * 20), y - 16, "Instances", oSaberHitbox);
        _h.damage = 5;
        _h.element = "electric";
        camera_shake(2, 8);
    }
}

// Saber Combos (Attack button)
if (global.input.shoot_pressed) {
    if (!grounded) {
        slash_anim_timer = 12;
        var _h = instance_create_layer(x + (facing * 16), y - 16, "Instances", oSaberHitbox);
        _h.damage = 2.5;
    } else if (state == PLAYER_STATE.DASH) {
        slash_anim_timer = 14;
        var _h = instance_create_layer(x + (facing * 18), y - 16, "Instances", oSaberHitbox);
        _h.damage = 3.0;
    } else {
        if (combo_step == 0) {
            combo_step = 1;
            combo_timer = COMBO_RESET_FRAMES;
            slash_anim_timer = 10;
            var _h = instance_create_layer(x + (facing * 16), y - 16, "Instances", oSaberHitbox);
            _h.damage = 2.0;
        } else if (combo_step == 1) {
            combo_step = 2;
            combo_timer = COMBO_RESET_FRAMES;
            slash_anim_timer = 10;
            var _h = instance_create_layer(x + (facing * 16), y - 16, "Instances", oSaberHitbox);
            _h.damage = 2.0;
        } else if (combo_step == 2) {
            combo_step = 3;
            combo_timer = 25;
            slash_anim_timer = 16;
            var _h = instance_create_layer(x + (facing * 22), y - 16, "Instances", oSaberHitbox);
            _h.damage = 4.0;
            camera_shake(3, 8);
        }
    }
}

// Saber Dash Cancel (SDC)
if (combo_step == 1 && global.input.dash_pressed) {
    combo_step = 0;
    combo_timer = 0;
    slash_anim_timer = 0;
    state = PLAYER_STATE.DASH;
    dash_timer = DASH_DURATION;
    dash_dir = facing;
    hsp = dash_dir * DASH_SPEED;
}

if (combo_timer > 0) {
    combo_timer--;
    if (combo_timer <= 0) combo_step = 0;
}

if (technique_timer > 0) {
    technique_timer--;
    if (technique_timer <= 0) technique_state = TECHNIQUE.NONE;
}
if (technique_state == TECHNIQUE.HYOURETSUZAN && grounded) {
    technique_state = TECHNIQUE.NONE;
    camera_shake(4, 10);
}

if (slash_anim_timer > 0) slash_anim_timer--;
"@;
    "8_0" = @"
// Iframes blinking
if (iframes > 0 && (iframes div 3) % 2 == 0) return;

var _c_primary = make_color_rgb(220, 30, 40);   // Zero Crimson Red
var _c_white = c_white;
var _c_hair = make_color_rgb(255, 220, 60);      // Blonde ponytail
var _c_saber = make_color_rgb(40, 255, 120);     // Green Saber

// Shadow
draw_set_color(c_black);
draw_set_alpha(0.3);
draw_ellipse(x - 8, y - 2, x + 8, y + 2, false);
draw_set_alpha(1.0);

// Ponytail hair
draw_set_color(_c_hair);
var _hair_wave = sin(anim_timer * 0.25) * 3;
draw_line_width(x - (facing * 6), y - 26, x - (facing * 16), y - 16 + _hair_wave, 3);
draw_line_width(x - (facing * 16), y - 16 + _hair_wave, x - (facing * 22), y - 6 + _hair_wave, 2);

// Torso / Body
var _body_y = y - 22;
draw_set_color(_c_primary);
draw_rectangle(x - 6, _body_y, x + 6, y - 10, false);
draw_set_color(_c_white);
draw_circle(x - 2, _body_y + 4, 2, false);
draw_circle(x + 2, _body_y + 4, 2, false); // Dual white chest orbs

// Legs
draw_set_color(_c_primary);
if (state == PLAYER_STATE.RUN) {
    var _leg_offset = sin(anim_timer * 0.3) * 4;
    draw_rectangle(x - 6, y - 10, x - 1, y + _leg_offset, false);
    draw_rectangle(x + 1, y - 10, x + 6, y - _leg_offset, false);
} else {
    draw_rectangle(x - 6, y - 10, x - 1, y, false);
    draw_rectangle(x + 1, y - 10, x + 6, y, false);
}

// Helmet
var _head_y = y - 28;
draw_set_color(_c_primary);
draw_circle(x, _head_y, 7, false);
draw_set_color(make_color_rgb(255, 215, 175));
draw_rectangle(x - (facing * 2), _head_y - 2, x + (facing * 5), _head_y + 4, false);
draw_set_color(make_color_rgb(0, 180, 255));
draw_circle(x, _head_y - 3, 2, false); // Cyan helmet gem

// Z-Saber Blade / Slash Arcs
if (slash_anim_timer > 0) {
    draw_set_color(_c_saber);
    draw_set_alpha(0.8);
    var _arc_x = x + (facing * 16);
    var _arc_y = y - 16;
    draw_circle(_arc_x, _arc_y, 16, true);
    draw_line_width(x + (facing * 6), y - 16, _arc_x + (facing * 12), _arc_y, 3);
    draw_set_alpha(1.0);
} else {
    // Sheathed / ready saber
    draw_set_color(_c_saber);
    draw_line_width(x + (facing * 6), y - 16, x + (facing * 18), y - 24, 2);
}

// Technique VFX
if (technique_state == TECHNIQUE.RYUENJIN) {
    draw_set_color(make_color_rgb(255, 120, 20)); // Flame
    draw_set_alpha(0.8);
    draw_ellipse(x - 8, y - 40, x + 8, y, false);
    draw_set_alpha(1.0);
} else if (technique_state == TECHNIQUE.HYOURETSUZAN) {
    draw_set_color(make_color_rgb(100, 220, 255)); // Ice
    draw_set_alpha(0.8);
    draw_triangle(x - 6, y - 10, x + 6, y - 10, x, y + 16, false);
    draw_set_alpha(1.0);
} else if (technique_state == TECHNIQUE.KUUENZAN) {
    draw_set_color(_c_saber);
    draw_set_alpha(0.7);
    draw_circle(x, y - 16, 22, true);
    draw_set_alpha(1.0);
} else if (technique_state == TECHNIQUE.RAIJINGEKI) {
    draw_set_color(make_color_rgb(255, 255, 80)); // Lightning
    draw_set_alpha(0.8);
    draw_line_width(x, y - 16, x + (facing * 36), y - 16, 4);
    draw_set_alpha(1.0);
}
"@
}

Write-Host "All objects created successfully!"
