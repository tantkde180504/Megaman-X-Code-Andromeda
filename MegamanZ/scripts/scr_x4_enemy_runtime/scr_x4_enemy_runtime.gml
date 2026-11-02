/// @desc Reusable baseline AI for the sourced X4 library. Runs in enemy context.
enum X4_AI_KIND { PATROL, SHOOTER, HOVER, HOPPER, ORBIT, CHARGER, NEST, FALLING }
enum X4_AI_STATE { PATROL, WINDUP, ATTACK, RECOVER }

function x4_enemy_apply(_key) {
    enemy_profile_key = _key;
    enemy_profile = x4_enemy_profile(_key);
    sprite_index = enemy_profile.sprite;
    mask_index = sprite_index;
    image_speed = 0;
    image_index = 0;
    hp = enemy_profile.hp;
    max_hp = hp;
    move_speed = enemy_profile.speed;
    is_invulnerable = enemy_profile.invulnerable;
    contact_damage = enemy_profile.kind == X4_AI_KIND.FALLING ? 4 : 3;
    projectile_damage = 2;
    facing = -1;
    state = X4_AI_STATE.PATROL;
    state_timer = 0;
    attack_cooldown = 60;
    x4_anim_tick = 0;
    x4_clip_start = -1;
    x4_x_subpixel = 0;
    x4_y_subpixel = 0;
    start_x = x;
    start_y = y;
    x4_bursts_left = 0;
    x4_burst_timer = 0;
    x4_lifetime = 600;
    // These tuning values are instance fields so a placed prefab can override them.
    detect_range = 260;
    windup_frames = 24;
    recovery_frames = 40;
    fire_cooldown = 100;
    bullet_speed = 3.2;
    jump_speed = -5.5;
    charge_speed = 3.5;
    charge_frames = 32;
}

function x4_enemy_change_state(_next) {
    state = _next;
    state_timer = 0;
    x4_anim_tick = 0;
}

function x4_enemy_fire() {
    if (target == noone || !instance_exists(target)) return;
    var _muzzle_y = y - (enemy_profile.ground ? enemy_profile.body_height * 0.6 : 0);
    var _muzzle_x = x + facing * 12;
    if (stage_encounters_reserved(_muzzle_x, _muzzle_y, 48)) return;
    var _angle = point_direction(_muzzle_x, _muzzle_y, target.x, target.y - 16);
    var _bullet = instance_create_layer(_muzzle_x, _muzzle_y, "Instances", oEnemyBullet);
    _bullet.hsp = lengthdir_x(bullet_speed, _angle);
    _bullet.vsp = lengthdir_y(bullet_speed, _angle);
    _bullet.damage = projectile_damage;
    _bullet.life = 150;
}

function x4_enemy_ground_motion(_avoid_cliffs = true) {
    x4_x_subpixel += hsp;
    var _dx = round(x4_x_subpixel);
    x4_x_subpixel -= _dx;
    repeat (abs(_dx)) {
        var _step = sign(_dx);
        if (place_meeting(x + _step, y, oSolid)
            || (_avoid_cliffs && grounded && !place_meeting(x + _step * 10, y + 2, oSolid))) {
            facing = -facing;
            hsp = 0;
            x4_x_subpixel = 0;
            break;
        }
        x += _step;
    }
    vsp = min(vsp + grav, 8);
    x4_y_subpixel += vsp;
    var _dy = round(x4_y_subpixel);
    x4_y_subpixel -= _dy;
    grounded = place_meeting(x, y + 1, oSolid);
    repeat (abs(_dy)) {
        var _step_y = sign(_dy);
        if (place_meeting(x, y + _step_y, oSolid)) {
            grounded = _step_y > 0;
            vsp = 0;
            x4_y_subpixel = 0;
            break;
        }
        y += _step_y;
    }
}

function x4_enemy_tick() {
    var _kind = enemy_profile.kind;
    state_timer++;
    x4_anim_tick++;
    var _target_in_range = false;
    if (target != noone && instance_exists(target)) {
        _target_in_range = point_distance(x, y, target.x, target.y) <= detect_range;
    }

    if (_kind == X4_AI_KIND.FALLING) {
        hsp = facing * move_speed;
        vsp = enemy_profile.fall_speed;
        x += hsp;
        y += vsp;
        x4_lifetime--;
        if (place_meeting(x, y, oSolid) || y > room_height + 128 || x4_lifetime <= 0) {
            instance_create_layer(x, y, "Instances", oFX_EnemyExplosion);
            instance_destroy();
        }
        return;
    }

    if (state == X4_AI_STATE.PATROL && _target_in_range && attack_cooldown <= 0
        && (enemy_profile.shots > 0 || _kind == X4_AI_KIND.CHARGER || _kind == X4_AI_KIND.NEST)) {
        facing = target.x < x ? -1 : 1;
        x4_enemy_change_state(X4_AI_STATE.WINDUP);
    }

    if (state == X4_AI_STATE.WINDUP) {
        hsp = 0;
        if (state_timer >= windup_frames) {
            x4_enemy_change_state(X4_AI_STATE.ATTACK);
            if (_kind == X4_AI_KIND.CHARGER) {
                hsp = facing * charge_speed;
                vsp = enemy_profile.ground ? vsp : 0;
            } else if (_kind == X4_AI_KIND.NEST) {
                if (instance_number(oEnemy_X4_Kunbien) < 3
                    && !stage_encounters_reserved(x + facing * 40, y + 24)) {
                    instance_create_layer(x + facing * 40, y + 24, "Instances", oEnemy_X4_Kunbien);
                }
            } else {
                x4_bursts_left = enemy_profile.shots;
                x4_burst_timer = 0;
            }
        }
    } else if (state == X4_AI_STATE.ATTACK) {
        if (x4_bursts_left > 0) {
            if (x4_burst_timer <= 0) {
                x4_enemy_fire();
                x4_bursts_left--;
                x4_burst_timer = 8;
            } else x4_burst_timer--;
        }
        if (state_timer >= charge_frames && x4_bursts_left <= 0) {
            // Resume hovering from the reached position, never teleport to home.
            if (_kind == X4_AI_KIND.CHARGER) { start_x = x; start_y = y; }
            hsp = 0;
            attack_cooldown = fire_cooldown;
            x4_enemy_change_state(X4_AI_STATE.RECOVER);
        }
    } else if (state == X4_AI_STATE.RECOVER && state_timer >= recovery_frames) {
        x4_enemy_change_state(X4_AI_STATE.PATROL);
    }

    if (enemy_profile.ground) {
        if (state == X4_AI_STATE.PATROL) {
            hsp = facing * move_speed;
            if (_kind == X4_AI_KIND.HOPPER && grounded && state_timer >= 55) {
                vsp = jump_speed;
                state_timer = 0;
            }
        }
        x4_enemy_ground_motion(_kind != X4_AI_KIND.HOPPER);
    } else if (_kind == X4_AI_KIND.CHARGER && state == X4_AI_STATE.ATTACK) {
        if (!place_meeting(x + hsp, y, oSolid)) x += hsp;
        else state_timer = charge_frames;
    } else if (_kind == X4_AI_KIND.HOVER || _kind == X4_AI_KIND.ORBIT) {
        var _radius = enemy_profile.radius;
        x = start_x + sin(anim_timer * 0.025) * _radius;
        y = start_y + sin(anim_timer * 0.05) * (_kind == X4_AI_KIND.ORBIT ? _radius : 8);
    }
}

function x4_enemy_draw() {
    var _clip = enemy_profile.idle;
    if (state == X4_AI_STATE.WINDUP || state == X4_AI_STATE.ATTACK) _clip = enemy_profile.attack;
    else if (enemy_profile.ground && (abs(hsp) > 0.1 || !grounded)) _clip = enemy_profile.move;
    if (x4_clip_start != _clip[0]) { x4_clip_start = _clip[0]; x4_anim_tick = 0; }
    var _frame = _clip[0] + (floor(x4_anim_tick / 5) mod _clip[1]);
    if (flash_timer > 0) gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(sprite_index, _frame, floor(x), floor(y),
        facing * enemy_profile.native_facing, 1, 0, c_white, 1);
    if (flash_timer > 0) gpu_set_fog(false, c_white, 0, 0);
}
