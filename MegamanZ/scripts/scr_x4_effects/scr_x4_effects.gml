/// @desc One-shot sprite effects. Source animation owns its expansion/fade shapes.
function fx_x4_spawn(_sprite, _x, _y, _facing = 1, _rate = 0.5) {
    var _fx = instance_create_layer(_x, _y, "Instances", oFX_X4Burst);
    _fx.sprite_index = _sprite;
    _fx.image_xscale = _facing;
    _fx.fx_rate = max(0.05, _rate);
    return _fx;
}

function fx_x4_advance() {
    if (fx_frame >= sprite_get_number(sprite_index)) {
        instance_destroy();
        return;
    }
    image_index = floor(fx_frame);
    fx_frame += fx_rate;
}

// Called in player context exactly when the movement state first enters DASH.
function player_spawn_x4_dash_flash() {
    var _sprite = object_index == oPlayerZero ? sFX_X4_DashZero : sFX_X4_DashX;
    // Use the committed dash direction, even if facing changes on the next step.
    fx_x4_spawn(_sprite, x - dash_dir * 14, bbox_bottom - 6, dash_dir);
}

function player_spawn_x4_dash_dust(_x, _y) {
    var _dust = instance_create_layer(_x, _y, "Instances", oFX_DashDust);
    _dust.image_xscale = facing;
    return _dust;
}

function player_spawn_x4_wall_dust(_scale = 1) {
    // Source plume extends left of its right-edge origin: right wall = +1.
    var _contact_x = touching_wall > 0 ? bbox_right + 1 : bbox_left - 1;
    var _dust = fx_x4_spawn(sFX_X4_WallDust, _contact_x, bbox_bottom - 8, touching_wall * _scale);
    _dust.image_yscale = _scale;
    return _dust;
}

function player_update_x4_wall_slide() {
    if (state != PLAYER_STATE.WALL_SLIDE || grounded || touching_wall == 0 || vsp <= 0) {
        wall_fx_timer = 0;
        return;
    }
    if (wall_fx_timer <= 0) {
        player_spawn_x4_wall_dust(0.5);
        wall_fx_timer = 10;
    }
    wall_fx_timer--;
}
