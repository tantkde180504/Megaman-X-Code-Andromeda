var _flash = (flash_timer > 0);

switch (state) {
    case 0: // SHIELD_PATROL: Massive protective curved shield locked in front
        // 1. Draw drone body
        var _drone_frames = [
            [35, 5, 29, 26, 14, 13],
            [75, 5, 29, 26, 14, 13],
            [115, 5, 29, 26, 14, 13]
        ];
        var _df = _drone_frames[floor(anim_timer / 6) % 3];
        enemy_draw_sprite(Guardian_Sheet, _df[0], _df[1], _df[2], _df[3], _df[4], _df[5], x - facing * 4, y, facing, _flash);
        
        // 2. Draw massive frontal curved energy shield in front of drone!
        var _shield_frames = [
            [58, 54, 24, 51, 12, 25],
            [95, 50, 35, 47, 17, 23]
        ];
        var _sf = _shield_frames[floor(anim_timer / 8) % 2];
        enemy_draw_sprite(Guardian_Sheet, _sf[0], _sf[1], _sf[2], _sf[3], _sf[4], _sf[5], x + facing * 8, y, facing, _flash);
        break;

    case 1: // LOCK_CHARGE: Sensor eye glows, shield prepares to part
        var _df = [115, 5, 29, 26, 14, 13];
        enemy_draw_sprite(Guardian_Sheet, _df[0], _df[1], _df[2], _df[3], _df[4], _df[5], x - facing * 4, y, facing, _flash);
        // Tilted shield frame
        enemy_draw_sprite(Guardian_Sheet, 274, 52, 23, 51, 11, 25, x + facing * 8, y, facing, _flash);
        break;

    case 2: // OPEN_ATTACK: Shield parted, twin laser cannons revealed & firing!
        // Open shield frame with cannons exposed
        enemy_draw_sprite(Guardian_Sheet, 138, 46, 49, 37, 24, 18, x, y, facing, _flash);
        break;

    case 3: // RECOVER: Shield snapping back in place
        enemy_draw_sprite(Guardian_Sheet, 314, 50, 31, 51, 15, 25, x + facing * 6, y, facing, _flash);
        break;
}

