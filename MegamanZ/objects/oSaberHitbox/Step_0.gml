if (!instance_exists(owner)) {
    instance_destroy();
    return;
}

// Destroy when attack ends
if (owner.slash_anim_timer <= 0 && owner.technique_state == TECHNIQUE.NONE) {
    instance_destroy();
    return;
}

var _px = owner.x;
var _py = owner.y;
var _facing = owner.facing;
var _frame = (owner.technique_state != TECHNIQUE.NONE) ? floor(owner.technique_frame) : floor(owner.slash_anim_frame);
var _active = false;
var _min_x = 0;
var _max_x = 0;
var _min_y = 0;
var _max_y = 0;

// Dynamic Hitbox matching the exact blade geometry in each frame
switch (slash_type) {
    case "slash1":
        // sZero_Slash1 (10 frames)
        if (_frame == 2) {
            _active = true; _min_x = 0; _max_x = 32; _min_y = -64; _max_y = -26;
        } else if (_frame == 3) {
            _active = true; _min_x = 16; _max_x = 66; _min_y = -64; _max_y = -16;
        } else if (_frame == 4) {
            _active = true; _min_x = 30; _max_x = 76; _min_y = -62; _max_y = -2;
        } else if (_frame == 5) {
            _active = true; _min_x = 34; _max_x = 80; _min_y = -42; _max_y = -2;
        } else if (_frame == 6) {
            _active = true; _min_x = 26; _max_x = 70; _min_y = -38; _max_y = -2;
        } else if (_frame == 7) {
            _active = true; _min_x = 24; _max_x = 58; _min_y = -38; _max_y = -2;
        } else if (_frame == 8) {
            _active = true; _min_x = 24; _max_x = 52; _min_y = -38; _max_y = -4;
        }
        break;

    case "slash2":
        // sZero_Slash2 (10 frames)
        if (_frame == 1) {
            _active = true; _min_x = 14; _max_x = 52; _min_y = -42; _max_y = -20;
        } else if (_frame == 2) {
            _active = true; _min_x = -4; _max_x = 68; _min_y = -42; _max_y = -18;
        } else if (_frame == 3) {
            // Massive 180 horizontal sweep: covers behind Zero (-36) to far front (+72)
            _active = true; _min_x = -36; _max_x = 72; _min_y = -44; _max_y = -6;
        } else if (_frame >= 4 && _frame <= 7) {
            _active = true; _min_x = -46; _max_x = 6; _min_y = -44; _max_y = -8;
        }
        break;

    case "slash3":
        // sZero_Slash3 (14 frames finisher)
        if (_frame == 2) {
            _active = true; _min_x = -26; _max_x = 24; _min_y = -62; _max_y = -24;
        } else if (_frame == 3) {
            _active = true; _min_x = -14; _max_x = 72; _min_y = -66; _max_y = -8;
        } else if (_frame == 4) {
            // Giant vertical cleave downwards to floor (reaches y+8)
            _active = true; _min_x = 8; _max_x = 80; _min_y = -65; _max_y = 8;
        } else if (_frame == 5) {
            // Impact shockwave into ground
            _active = true; _min_x = 8; _max_x = 80; _min_y = -56; _max_y = 8;
        } else if (_frame == 6) {
            _active = true; _min_x = 8; _max_x = 80; _min_y = -44; _max_y = 0;
        } else if (_frame == 7) {
            _active = true; _min_x = 8; _max_x = 48; _min_y = -44; _max_y = 0;
        } else if (_frame == 8) {
            _active = true; _min_x = 8; _max_x = 34; _min_y = -44; _max_y = 0;
        }
        break;

    case "air_slash":
        // sZero_AirSlash (9 frames)
        if (_frame == 1) {
            _active = true; _min_x = -16; _max_x = 16; _min_y = -78; _max_y = -30;
        } else if (_frame == 2) {
            _active = true; _min_x = -14; _max_x = 40; _min_y = -76; _max_y = -30;
        } else if (_frame == 3) {
            _active = true; _min_x = -16; _max_x = 60; _min_y = -82; _max_y = -32;
        } else if (_frame == 4) {
            // Full 360 circle covering overhead, front and back
            _active = true; _min_x = -32; _max_x = 72; _min_y = -82; _max_y = -22;
        } else if (_frame == 5 || _frame == 6) {
            _active = true; _min_x = -34; _max_x = 12; _min_y = -70; _max_y = -38;
        }
        break;

    case "dash_slash":
        // sZero_DashSlash (9 frames)
        if (_frame == 1) {
            _active = true; _min_x = -15; _max_x = 15; _min_y = -76; _max_y = -46;
        } else if (_frame == 2) {
            _active = true; _min_x = 0; _max_x = 40; _min_y = -78; _max_y = -44;
        } else if (_frame == 3) {
            _active = true; _min_x = -12; _max_x = 62; _min_y = -76; _max_y = -28;
        } else if (_frame == 4) {
            // Extended forward thrust sweep reach +76
            _active = true; _min_x = -26; _max_x = 76; _min_y = -68; _max_y = -10;
        } else if (_frame == 5 || _frame == 6) {
            _active = true; _min_x = -30; _max_x = 16; _min_y = -58; _max_y = -26;
        } else if (_frame == 7) {
            _active = true; _min_x = -20; _max_x = 12; _min_y = -70; _max_y = -46;
        }
        break;

    case "wall_slash":
        // sZero_WallSlash (9 frames)
        if (_frame == 1) {
            _active = true; _min_x = -4; _max_x = 24; _min_y = -66; _max_y = -24;
        } else if (_frame == 2) {
            _active = true; _min_x = 18; _max_x = 85; _min_y = -66; _max_y = -20;
        } else if (_frame == 3 || _frame == 4) {
            // Peak wall crescent reach +86 away from wall
            _active = true; _min_x = 18; _max_x = 86; _min_y = -62; _max_y = -20;
        } else if (_frame == 5) {
            _active = true; _min_x = 18; _max_x = 66; _min_y = -54; _max_y = -22;
        } else if (_frame == 6) {
            _active = true; _min_x = 18; _max_x = 42; _min_y = -56; _max_y = -30;
        }
        break;

    case "ladder_slash":
        // sZero_LadderSlash (9 frames)
        if (_frame == 2) {
            _active = true; _min_x = -2; _max_x = 25; _min_y = -66; _max_y = -40;
        } else if (_frame == 3) {
            _active = true; _min_x = 22; _max_x = 78; _min_y = -66; _max_y = -12;
        } else if (_frame == 4 || _frame == 5) {
            // Horizontal ladder slash reach +85
            _active = true; _min_x = 20; _max_x = 85; _min_y = -56; _max_y = -4;
        } else if (_frame == 6) {
            _active = true; _min_x = 22; _max_x = 62; _min_y = -52; _max_y = -10;
        }
        break;

    case "ryuenjin":
        // Ryuenjin (16 frames): 0 crouch, 1 ignition, 2..7 rising uppercut, 8..13 apex spiral, 14..15 fall
        if (_frame == 1) {
            _active = true; _min_x = -10; _max_x = 50; _min_y = -56; _max_y = 0;
        } else if (_frame >= 2 && _frame <= 7) {
            _active = true; _min_x = -14; _max_x = 44; _min_y = -96; _max_y = 0;
        } else if (_frame >= 8 && _frame <= 13) {
            _active = true; _min_x = -20; _max_x = 36; _min_y = -98; _max_y = 0;
        }
        break;

    case "hyouretsuzan":
        // Hyouretsuzan (9 frames): 0..1 ready, 2..3 dive plunge, 4..5 impact, 6..8 recover
        if (_frame == 2 || _frame == 3) {
            _active = true; _min_x = -18; _max_x = 18; _min_y = -60; _max_y = 10;
        } else if (_frame == 4 || _frame == 5) {
            _active = true; _min_x = -32; _max_x = 32; _min_y = -50; _max_y = 2;
        }
        break;

    case "kuuenzan":
    case "kuuenbu":
        // Kuuenbu (8 frames): full 360 degree spin slash
        if (_frame >= 0 && _frame <= 7) {
            _active = true; _min_x = -38; _max_x = 38; _min_y = -55; _max_y = 20;
        }
        break;

    case "raijingeki":
        // Raijingeki (24 frames): 0..11 charge sparks, 12..14 thrust, 15..19 blast, 20..22 dissipate, 23 recover
        if (_frame >= 12 && _frame <= 14) {
            _active = true; _min_x = 0; _max_x = 85; _min_y = -46; _max_y = 2;
        } else if (_frame >= 15 && _frame <= 19) {
            _active = true; _min_x = 0; _max_x = 135; _min_y = -46; _max_y = 2;
        } else if (_frame >= 20 && _frame <= 22) {
            _active = true; _min_x = 0; _max_x = 90; _min_y = -44; _max_y = 2;
        }
        // Multi-hit: allow hitting enemies every 6 frames during active blast
        if (_active) {
            multi_hit_timer++;
            if (multi_hit_timer >= multi_hit_interval) {
                multi_hit_timer = 0;
                ds_list_clear(hit_list);
            }
        }
        break;
}

is_active = _active;

if (_active) {
    // Transform coordinates based on Zero's facing direction
    var _x1 = (_facing == 1) ? (_px + _min_x) : (_px - _max_x);
    var _x2 = (_facing == 1) ? (_px + _max_x) : (_px - _min_x);
    var _y1 = _py + _min_y;
    var _y2 = _py + _max_y;
    
    var _bx1 = min(_x1, _x2);
    var _bx2 = max(_x1, _x2);
    var _by1 = min(_y1, _y2);
    var _by2 = max(_y1, _y2);
    
    x = _bx1;
    y = _by1;
    image_xscale = max(1, _bx2 - _bx1) / 16.0;
    image_yscale = max(1, _by2 - _by1) / 16.0;
    
    // Check collisions with Enemies (oEnemyParent, includes oTargetDummy and all 8 enemies)
    var _enemies = ds_list_create();
    var _num_e = instance_place_list(x, y, oEnemyParent, _enemies, false);
    for (var i = 0; i < _num_e; i++) {
        var _tgt = _enemies[| i];
        if (ds_list_find_index(hit_list, _tgt) == -1) {
            ds_list_add(hit_list, _tgt);
            if (variable_instance_exists(_tgt, "is_deflecting") && _tgt.is_deflecting && slash_type != "slash3") {
                instance_create_layer(_tgt.x, _tgt.y - 12, "Instances", oFX_HitSpark);
                camera_shake(1, 4);
            } else {
                var _is_fire = (element == "fire" || slash_type == "ryuenjin");
                deal_damage_to_target(_tgt, damage, _tgt.x, _tgt.y - 12, _is_fire, false, element);
                camera_shake(2, 6);
            }
        }
    }
    ds_list_destroy(_enemies);
    
    // Check collisions with Web Trap
    var _webs = ds_list_create();
    var _num_w = instance_place_list(x, y, oWebTrap, _webs, false);
    for (var i = 0; i < _num_w; i++) {
        var _w = _webs[| i];
        if (ds_list_find_index(hit_list, _w) == -1) {
            ds_list_add(hit_list, _w);
            if (element == "fire") {
                _w.hp = 0;
            } else {
                _w.hp -= damage;
            }
            _w.flash_timer = 6;
            if (_w.hp <= 0 && object_exists(oFX_HitSpark)) {
                instance_create_layer(_w.x, _w.y, "Instances", oFX_HitSpark);
            }
        }
    }
    ds_list_destroy(_webs);
} else {
    // Inactive frame: position out of bounds so no collision occurs
    x = -9999;
    y = -9999;
    image_xscale = 0;
    image_yscale = 0;
}
