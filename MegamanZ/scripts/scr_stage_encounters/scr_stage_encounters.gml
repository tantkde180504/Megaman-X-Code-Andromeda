/// @desc Authored rest screens and boss-only arenas, shared by placement and AI.
function stage_enemy_is_regular(_object) {
    if (_object != oEnemyParent && !object_is_ancestor(_object, oEnemyParent)) return false;
    if (_object == obj_boss_parent || object_is_ancestor(_object, obj_boss_parent)) return false;
    // These damageable objects belong to Web Spider's attacks, not stage mobs.
    return _object != oBoss_WebSpider_Projectile && _object != oBoss_WebSpider_WebNet;
}

function stage_encounters_add_zone(_left, _top, _right, _bottom) {
    array_push(global.enemy_free_zones, [_left, _top, _right, _bottom]);
}

function stage_encounters_add_checkpoint(_x, _y) {
    // A full screen plus breathing room; include airborne enemies above the floor.
    stage_encounters_add_zone(_x - VIEW_WIDTH * 0.65, _y - VIEW_HEIGHT + 32,
        _x + VIEW_WIDTH * 0.65, _y + 80);
}

function stage_encounters_reserved(_x, _y, _padding = 24) {
    if (!variable_global_exists("enemy_free_room") || global.enemy_free_room != room) return false;
    for (var _i = 0; _i < array_length(global.enemy_free_zones); _i++) {
        var _zone = global.enemy_free_zones[_i];
        if (_x >= _zone[0] - _padding && _x <= _zone[2] + _padding
            && _y >= _zone[1] - _padding && _y <= _zone[3] + _padding) return true;
    }
    return false;
}

function stage_encounters_configure(_checkpoint_x, _checkpoint_y) {
    global.enemy_free_room = room;
    global.enemy_free_zones = [];
    var _name = room_get_name(room);
    var _entry_y = room_height - 32;
    if (_name == "rStage_Sky") _entry_y = 1152;
    else if (_name == "rStage_WebSpider") _entry_y = 368;
    if (_name == "rStage_Sky" || _name == "rStage_WebSpider"
        || _name == "rStage_Intro" || _name == "Room1") {
        stage_encounters_add_zone(0, _entry_y - VIEW_HEIGHT, VIEW_WIDTH + 64, _entry_y + 80);
        stage_encounters_add_checkpoint(_checkpoint_x, _checkpoint_y);
        for (var _i = 0; _i < instance_number(oTrigger_Checkpoint); _i++) {
            var _checkpoint = instance_find(oTrigger_Checkpoint, _i);
            stage_encounters_add_checkpoint(_checkpoint.x, _checkpoint.y);
        }
    }
    if (_name == "rStage_Sky") {
        // Quiet final walkway: this story handoff has no boss encounter.
        stage_encounters_add_zone(4480, 192, room_width, 432);
    } else if (_name == "rStage_WebSpider") {
        // Rest before Door 1, save corridor, Door 2 and the entire boss chamber.
        stage_encounters_add_zone(4720, 1632, room_width, room_height);
    } else if (_name == "rStage_Intro") {
        // This arena currently has no boss; it still must not contain stage mobs.
        stage_encounters_add_zone(2060, 0, room_width, room_height);
    } else if (_name == "rBoss_NightmareZero") {
        stage_encounters_add_zone(0, 0, room_width, room_height);
    }
}

function stage_encounters_clear_reserved() {
    // Covers Room Editor instances as well as every procedural builder path.
    for (var _i = instance_number(oEnemyParent) - 1; _i >= 0; _i--) {
        var _enemy = instance_find(oEnemyParent, _i);
        if (stage_enemy_is_regular(_enemy.object_index)
            && stage_encounters_reserved(_enemy.x, _enemy.y)) instance_destroy(_enemy, false);
    }
    for (var _i = instance_number(oWebTrap) - 1; _i >= 0; _i--) {
        var _trap = instance_find(oWebTrap, _i);
        if (stage_encounters_reserved(_trap.x, _trap.y)) instance_destroy(_trap, false);
    }
}
