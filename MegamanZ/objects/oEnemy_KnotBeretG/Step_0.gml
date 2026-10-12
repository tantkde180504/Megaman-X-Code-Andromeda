event_inherited();
if (is_dead) return;

state_timer++;

// State Machine
switch (state) {
    case 0: // IDLE (Row 1): Wait when player is not in range
        hsp = 0;
        if (target != noone) {
            var _dist = point_distance(x, y, target.x, target.y);
            // Spot player when in range and initial cooldown passed
            if (_dist < 260 && state_timer > 20) {
                facing = (target.x >= x) ? 1 : -1;
                state = 1; // RUN towards player
                state_timer = 0;
            }
        }
        break;

    case 1: // RUN (Row 3): Run towards player
        if (target != noone) {
            facing = (target.x >= x) ? 1 : -1;
        }
        hsp = facing * move_speed;
        
        // Check cliff edge ahead
        var _ahead_x = x + facing * 20;
        var _solid_ahead = place_meeting(_ahead_x, y + 16, oSolid);
        var _deep_cliff = !place_meeting(_ahead_x, y + 64, oSolid);
        
        if (grounded && !_solid_ahead && _deep_cliff) {
            // High cliff ahead! Stop and enter cliff peek
            hsp = 0;
            state = 5; // CLIFF_PEEK
            state_timer = 0;
            break;
        }
        
        // Stop if running into a solid wall
        if (place_meeting(x + hsp, y, oSolid)) {
            hsp = 0;
        }
        
        // Check attack range
        if (target != noone) {
            var _dist = point_distance(x, y, target.x, target.y);
            // In range: randomly choose straight or diagonal shot
            if (_dist < 180 && state_timer > 25) {
                hsp = 0;
                facing = (target.x >= x) ? 1 : -1;
                state = choose(2, 3); // 2: SHOOT_STRAIGHT, 3: SHOOT_DIAGONAL
                state_timer = 0;
            } else if (_dist > 340 && state_timer > 120) {
                state = 0; // IDLE
                state_timer = 0;
            }
        }
        break;

    case 2: // SHOOT_STRAIGHT (Row 2, first 2 frames)
        hsp = 0;
        if (state_timer == 8) {
            var _b = instance_create_layer(x + facing * 26, y - 24, "Instances", oEnemyBullet);
            _b.damage = projectile_damage;
            _b.hsp = facing * bullet_speed;
            _b.vsp = 0;
            camera_shake(1, 2);
        }
        // After shooting finishes, immediately go to bomb throw animation (Row 4)
        if (state_timer >= 22) {
            state = 4; // BOMB_THROW
            state_timer = 0;
        }
        break;

    case 3: // SHOOT_DIAGONAL (Row 2, next 2 frames)
        hsp = 0;
        if (state_timer == 8) {
            var _b = instance_create_layer(x + facing * 18, y - 44, "Instances", oEnemyBullet);
            _b.damage = projectile_damage;
            _b.hsp = facing * (bullet_speed * 0.707);
            _b.vsp = -(bullet_speed * 0.707);
            camera_shake(1, 2);
        }
        // After shooting finishes, immediately go to bomb throw animation (Row 4)
        if (state_timer >= 22) {
            state = 4; // BOMB_THROW
            state_timer = 0;
        }
        break;

    case 4: // BOMB_THROW (Row 4, 7 frames)
        hsp = 0;
        if (state_timer == 20) {
            var _g = instance_create_layer(x + facing * 16, y - 36, "Instances", oEnemy_Grenade);
            _g.damage = projectile_damage;
            _g.hsp = facing * grenade_speed_x;
            _g.vsp = grenade_speed_y;
            camera_shake(1, 3);
        }
        if (state_timer >= 35) {
            state = 0; // Back to IDLE wait
            state_timer = 0;
        }
        break;

    case 5: // CLIFF_PEEK (Row 5, first 2 frames)
        hsp = 0;
        if (state_timer >= 24) {
            state = 6; // CLIFF_JUMP
            state_timer = 0;
        }
        break;

    case 6: // CLIFF_JUMP (Row 5, next 2 frames)
        if (state_timer == 1) {
            hsp = facing * 2.2;
            vsp = -2.5;
            grounded = false;
        }
        if (state_timer >= 12 || vsp > 0) {
            state = 7; // FALL
            state_timer = 0;
        }
        break;

    case 7: // FALL (Row 6, first 2 frames)
        hsp = facing * 1.5;
        if (grounded || place_meeting(x, y + 1, oSolid)) {
            hsp = 0;
            state = 8; // LAND
            state_timer = 0;
        }
        break;

    case 8: // LAND (Row 6, next 3 frames)
        hsp = 0;
        if (state_timer >= 15) {
            state = 1; // Resume RUN towards player
            state_timer = 0;
        }
        break;
}

// Horizontal collision
if (hsp != 0) {
    if (place_meeting(x + hsp, y, oSolid)) {
        while (!place_meeting(x + sign(hsp), y, oSolid)) x += sign(hsp);
        hsp = 0;
    } else {
        x += hsp;
    }
}

// Vertical collision & gravity
vsp += grav;
if (place_meeting(x, y + vsp, oSolid)) {
    while (!place_meeting(x, y + sign(vsp), oSolid)) y += sign(vsp);
    vsp = 0;
    grounded = true;
} else {
    grounded = false;
}
y += vsp;
