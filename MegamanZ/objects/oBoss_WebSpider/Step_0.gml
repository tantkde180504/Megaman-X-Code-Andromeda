/// @desc Web Spider Boss State Machine & AI Update

// 1. Target Tracking
if (instance_exists(oPlayer)) {
    target = instance_nearest(x, y, oPlayer);
} else {
    target = noone;
}

// 2. Invulnerability & Flash Timers
if (flash_timer > 0) flash_timer--;
if (invulnerability_timer > 0) {
    invulnerability_timer--;
    is_invulnerable = (invulnerability_timer > 0);
} else {
    is_invulnerable = false;
}

// 3. Damage & Phase Check
if (hp < prev_hp) {
    var _dmg = prev_hp - hp;
    prev_hp = hp;
    flash_timer = 8;
    invulnerability_timer = 24;
    is_invulnerable = true;
    camera_shake(2, 6);
    
    // Interrupt into brief hurt recoil if not already in critical state
    if (state != SPIDER_STATE.INTRO && state != SPIDER_STATE.DEATH && _dmg >= 2) {
        state = SPIDER_STATE.HURT;
        state_timer = 0;
    }
}

if (hp <= max_hp * 0.5 && phase == 1) {
    phase = 2; // Enters Phase 2: faster attacks, web net traps
    climb_speed = 4.0;
}

if (hp <= 0 && state != SPIDER_STATE.DEATH) {
    state = SPIDER_STATE.DEATH;
    state_timer = 0;
    death_timer = 120;
    is_invulnerable = true;
    hsp = 0;
    vsp = 0;
}

// 4. Contact Damage with Player
if (state != SPIDER_STATE.INTRO && state != SPIDER_STATE.DEATH && !is_invulnerable && target != noone) {
    if (place_meeting(x, y, target)) {
        if (target.iframes <= 0 && target.state != PLAYER_STATE.HURT && target.state != PLAYER_STATE.DEATH) {
            var _kdir = (target.x >= x) ? 1 : -1;
            player_take_damage(contact_damage, _kdir);
        }
    }
}

// 5. State Machine Logic
switch (state) {
    // =========================================================================
    // 0. INTRO: WARNING flash & health bar fill
    // =========================================================================
    case SPIDER_STATE.INTRO:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        y = ceiling_y + 36;
        anchor_x = x;
        
        if (warning_timer > 0) {
            warning_timer--;
        } else {
            // Fill health bar
            if (hp_display < hp) {
                hp_display = min(hp, hp_display + 1);
                if (hp_display % 4 == 0) camera_shake(1, 2);
            } else {
                intro_done = true;
                state = SPIDER_STATE.CEILING_IDLE;
                state_timer = 0;
            }
        }
        break;
        
    // =========================================================================
    // 1. CEILING_IDLE: Hanging on silk thread under ceiling
    // =========================================================================
    case SPIDER_STATE.CEILING_IDLE:
        hsp = 0;
        vsp = 0;
        y = ceiling_y + 36;
        anchor_x = x;
        if (instance_exists(target)) facing = (target.x >= x) ? 1 : -1;
        
        anim_frame = (anim_frame + anim_spd) % 4;
        state_timer++;
        
        var _idle_limit = (phase == 2) ? 45 : 70;
        if (state_timer >= _idle_limit) {
            state_timer = 0;
            attack_pattern = (attack_pattern + 1) % 3;
            
            if (attack_pattern == 0) {
                // Pattern 1: Horizontal web spray
                state = SPIDER_STATE.ATTACK_WEB;
            } else if (attack_pattern == 1) {
                // Pattern 2: Move along ceiling towards player
                state = SPIDER_STATE.CEILING_MOVE;
            } else {
                // Pattern 3: Drop down to ground
                state = SPIDER_STATE.DESCEND;
                drop_target_y = ground_y;
            }
        }
        break;
        
    // =========================================================================
    // 2. CEILING_MOVE: Crawling along ceiling
    // =========================================================================
    case SPIDER_STATE.CEILING_MOVE:
        vsp = 0;
        y = ceiling_y + 36;
        var _target_x = (instance_exists(target)) ? target.x : x;
        var _dir = sign(_target_x - x);
        if (_dir == 0) _dir = 1;
        facing = _dir;
        
        var _spd = (phase == 2) ? 2.5 : 1.8;
        x = clamp(x + (_dir * _spd), arena_left, arena_right);
        anchor_x = x;
        
        anim_frame = (anim_frame + 0.18) % 4;
        state_timer++;
        
        if (state_timer >= 60 || abs(x - _target_x) < 20) {
            state_timer = 0;
            // Drop down right above player!
            state = SPIDER_STATE.DESCEND;
            drop_target_y = ground_y;
        }
        break;
        
    // =========================================================================
    // 3. DESCEND: Dropping down on silk thread
    // =========================================================================
    case SPIDER_STATE.DESCEND:
        hsp = 0;
        var _drop_spd = (phase == 2) ? 5.0 : 4.0;
        y = min(drop_target_y, y + _drop_spd);
        
        if (instance_exists(target)) facing = (target.x >= x) ? 1 : -1;
        anim_frame = 0; // Swing/drop frame
        
        if (y >= drop_target_y) {
            y = drop_target_y;
            camera_shake(2, 6);
            state_timer = 0;
            state = SPIDER_STATE.ATTACK_WEB;
        }
        break;
        
    // =========================================================================
    // 4. ATTACK_WEB: Firing web projectiles
    // =========================================================================
    case SPIDER_STATE.ATTACK_WEB:
        hsp = 0;
        vsp = 0;
        if (instance_exists(target)) facing = (target.x >= x) ? 1 : -1;
        state_timer++;
        
        // Frame 20: Shoot web projectiles
        if (state_timer == 20) {
            var _base_angle = 0;
            if (instance_exists(target)) {
                _base_angle = point_direction(x, y - 10, target.x, target.y);
            } else {
                _base_angle = (facing == 1) ? 0 : 180;
            }
            
            // Pattern 1: 3 web projectiles in arc (-25, 0, +25 degrees)
            for (var _a = -25; _a <= 25; _a += 25) {
                var _p = instance_create_layer(x + (facing * 16), y - 10, "Instances", oBoss_WebSpider_Projectile);
                var _rad = degtorad(_base_angle + _a);
                var _proj_spd = 3.8;
                _p.hsp = cos(_rad) * _proj_spd;
                _p.vsp = -sin(_rad) * _proj_spd;
            }
            camera_shake(1, 4);
            
            // Phase 2: Also spawn expanding Lightning Web net
            if (phase == 2) {
                var _net = instance_create_layer(x + (facing * 24), y - 10, "Instances", oBoss_WebSpider_WebNet);
                _net.hsp = facing * 2.5;
                _net.vsp = -1.5;
            }
        }
        
        // After attack, return to ceiling
        if (state_timer >= 50) {
            state_timer = 0;
            state = SPIDER_STATE.ASCEND;
        }
        break;
        
    // =========================================================================
    // 5. ASCEND: Climbing back up to ceiling on silk thread
    // =========================================================================
    case SPIDER_STATE.ASCEND:
        hsp = 0;
        y = max(ceiling_y + 36, y - climb_speed);
        if (instance_exists(target)) facing = (target.x >= x) ? 1 : -1;
        
        if (y <= ceiling_y + 36) {
            y = ceiling_y + 36;
            state_timer = 0;
            state = SPIDER_STATE.CEILING_IDLE;
        }
        break;
        
    // =========================================================================
    // 6. HURT: Recoil shudder on hit
    // =========================================================================
    case SPIDER_STATE.HURT:
        hsp = 0;
        vsp = 0;
        state_timer++;
        if (state_timer >= 20) {
            state_timer = 0;
            state = SPIDER_STATE.ASCEND;
        }
        break;
        
    // =========================================================================
    // 7. DEATH: Defeat explosion sequence
    // =========================================================================
    case SPIDER_STATE.DEATH:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        death_timer--;
        
        if (death_timer % 6 == 0) {
            var _ex = x + irandom_range(-28, 28);
            var _ey = y + irandom_range(-28, 28);
            if (object_exists(oFX_EnemyExplosion)) {
                instance_create_layer(_ex, _ey, "Instances", oFX_EnemyExplosion);
            }
            camera_shake(2, 4);
        }
        
        if (death_timer <= 0) {
            global.boss_defeated = true;
            instance_destroy();
        }
        break;
}
