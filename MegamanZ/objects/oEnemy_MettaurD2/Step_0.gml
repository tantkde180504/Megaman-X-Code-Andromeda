event_inherited();
if (hp <= 0) return;

// State Machine
switch (state) {
    case 0: // GUARD (ducking in helmet, invulnerable)
        is_deflecting = true;
        hsp = 0;
        if (instance_exists(oPlayer) && point_distance(x, y, oPlayer.x, oPlayer.y) < 160) {
            state_timer++;
            if (state_timer > 50) {
                state = 1;
                state_timer = 0;
                is_deflecting = false;
                facing = (oPlayer.x >= x) ? 1 : -1;
            }
        }
        break;

    case 1: // PEEK (pops head out)
        is_deflecting = false;
        hsp = 0;
        state_timer++;
        if (instance_exists(oPlayer)) facing = (oPlayer.x >= x) ? 1 : -1;
        if (state_timer > 20) {
            state = 2;
            state_timer = 0;
        }
        break;

    case 2: // SHOOT 3 BULLETS
        is_deflecting = false;
        hsp = 0;
        state_timer++;
        if (state_timer == 2) {
            // Spawn 3 energy pellets (straight, up 25 deg, down 25 deg)
            var _b1 = instance_create_layer(x + facing * 12, y - 12, "Instances", oEnemyBullet);
            _b1.hsp = facing * 2.8; _b1.vsp = 0;
            
            var _b2 = instance_create_layer(x + facing * 12, y - 12, "Instances", oEnemyBullet);
            _b2.hsp = facing * 2.5; _b2.vsp = -1.2;
            
            var _b3 = instance_create_layer(x + facing * 12, y - 12, "Instances", oEnemyBullet);
            _b3.hsp = facing * 2.5; _b3.vsp = 1.2;
        }
        if (state_timer > 25) {
            state = 3;
            state_timer = 0;
        }
        break;

    case 3: // WALK
        is_deflecting = false;
        hsp = facing * 1.1;
        
        // Turn around on wall
        if (place_meeting(x + hsp, y, oSolid)) {
            facing = -facing;
            hsp = facing * 1.1;
        }
        x += hsp;
        
        state_timer++;
        if (state_timer > 65) {
            state = 0;
            state_timer = 0;
            is_deflecting = true;
        }
        break;
}

// Gravity & Ground collision
vsp += grav;
if (place_meeting(x, y + vsp, oSolid)) {
    while (!place_meeting(x, y + sign(vsp), oSolid)) y += sign(vsp);
    vsp = 0;
    grounded = true;
} else {
    grounded = false;
}
y += vsp;
