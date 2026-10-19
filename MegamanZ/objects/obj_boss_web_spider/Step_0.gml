/// @desc Web Spider Boss Step Event (Master Finite State Machine)

// 1. Target Tracking
if (instance_exists(oPlayer)) {
    target = instance_nearest(x, y, oPlayer);
} else {
    target = noone;
}

// 2. Invulnerability & Flash Countdown
if (flash_timer > 0) flash_timer--;
if (state == WS_STATE.WIRE_CUT_FALL) {
    is_invulnerable = true;
    invincible_timer = max(invincible_timer, 2);
} else if (invincible_timer > 0) {
    invincible_timer--;
    is_invulnerable = (invincible_timer > 0);
} else {
    is_invulnerable = false;
}

// Sync damage from external combat systems
if (hp < prev_hp) {
    var _diff = prev_hp - hp;
    prev_hp = hp;
    take_damage(_diff, false, false);
}

// Global safety check for death
if (hp <= 0 && state != WS_STATE.DEATH) {
    state = WS_STATE.DEATH;
    state_timer = 0;
    death_timer = 130;
    is_invulnerable = true;
    wire_active = false;
    vsp = 0;
    hsp = 0;
    if (instance_exists(obj_giant_web_network)) with (obj_giant_web_network) instance_destroy();
    if (instance_exists(obj_mini_spider)) with (obj_mini_spider) {
        if (object_exists(oFX_HitSpark)) instance_create_layer(x, y, "Instances", oFX_HitSpark);
        instance_destroy();
    }
    if (instance_exists(obj_lightning_web_proj)) with (obj_lightning_web_proj) instance_destroy();
}

// 3. Web Thread Damage & Wire Cut Detection
if (wire_active) {
    var _wire_x = anchor_x;
    var _wire_top = y_ceiling;
    var _wire_bottom = y - 16;
    
    // Check if player's Saber hitbox cuts the wire
    if (instance_exists(oSaberHitbox)) {
        with (oSaberHitbox) {
            if (is_active && bbox_right >= _wire_x - 14 && bbox_left <= _wire_x + 14 &&
                bbox_bottom >= _wire_top && bbox_top <= _wire_bottom) {
                var _is_fire = (element == "fire" || slash_type == "ryuenjin");
                other.take_damage(6, _is_fire, true, element);
            }
        }
    }
    
    // Check if player touches the vertical electric thread (dmg_thread = 3)
    if (target != noone && abs(target.x - _wire_x) <= 10 && target.y >= _wire_top && target.y <= _wire_bottom) {
        if (target.iframes <= 0 && target.state != PLAYER_STATE.HURT && target.state != PLAYER_STATE.DEATH) {
            var _kdir = (target.x >= _wire_x) ? 1 : -1;
            player_take_damage(dmg_thread, _kdir);
        }
    }
}

// 4. Contact Damage with Player (dmg_contact = 6)
if (state != WS_STATE.INTRO && state != WS_STATE.DEATH && !is_invulnerable && target != noone) {
    if (place_meeting(x, y, target)) {
        if (target.iframes <= 0 && target.state != PLAYER_STATE.HURT && target.state != PLAYER_STATE.DEATH) {
            var _kdir = (target.x >= x) ? 1 : -1;
            player_take_damage(dmg_contact, _kdir);
        }
    }
}

// 5. Finite State Machine
switch (state) {
    // =========================================================================
    // A. STATE_INTRO: Repliforce salute & health bar fill
    // =========================================================================
    case WS_STATE.INTRO:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        wire_active = true;
        anchor_x = x;
        
        // Slide down to mid-air
        var _intro_stop_y = y_ceiling + 70;
        if (y < _intro_stop_y) {
            y = min(_intro_stop_y, y + 2.5);
        }
        
        anim_timer += 0.12;
        anim_frame = floor(anim_timer) % 4; // Row 1 intro salute
        
        if (warning_timer > 0) {
            warning_timer--;
        } else {
            // Fill health bar
            if (hp_display < hp) {
                hp_display = min(hp, hp_display + 1);
                if (hp_display % 4 == 0) camera_shake(1, 2);
            } else {
                // Zip back up into canopy
                y -= 4.0;
                if (y <= y_ceiling - 48) {
                    y = y_ceiling - 48;
                    wire_active = false;
                    intro_done = true;
                    state = WS_STATE.PHASE1_CANOPY_HIDE;
                    state_timer = 0;
                }
            }
        }
        break;
        
    // =========================================================================
    // B.1. STATE_PHASE1_CANOPY_HIDE: Hide in canopy & spawn leaves
    // =========================================================================
    case WS_STATE.PHASE1_CANOPY_HIDE:
        hsp = 0;
        vsp = 0;
        y = y_ceiling - 48;
        wire_active = false;
        
        // Select target X near player or key columns
        if (state_timer == 0) {
            if (target != noone) {
                target_x = clamp(target.x + choose(-48, 0, 48), arena_left + 32, arena_right - 32);
            } else {
                target_x = choose(arena_left + 40, arena_center_x, arena_right - 40);
            }
        }
        
        state_timer++;
        
        // Spawn leaves falling down to telegraph drop position
        if (state_timer % 6 == 0 && state_timer <= 42) {
            var _lx = target_x + irandom_range(-16, 16);
            instance_create_layer(_lx, y_ceiling, "Instances", obj_web_leaf_telegraph);
        }
        
        if (state_timer >= 45) {
            x = target_x;
            anchor_x = target_x;
            wire_active = true;
            state = WS_STATE.PHASE1_DESCEND;
            state_timer = 0;
            
            // Choose random drop height (low, mid, high)
            target_y = choose(y_floor - 24, y_ceiling + 80, y_ceiling + 50);
        }
        break;
        
    // =========================================================================
    // B.2. STATE_PHASE1_DESCEND: Lao nhanh xuống theo phương thẳng đứng
    // =========================================================================
    case WS_STATE.PHASE1_DESCEND:
        hsp = 0;
        wire_active = true;
        anchor_x = x;
        y = min(target_y, y + 5.5);
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        
        if (y >= target_y) {
            y = target_y;
            camera_shake(1, 4);
            state = WS_STATE.PHASE1_FIRE_WEB;
            state_timer = 0;
        }
        break;
        
    // =========================================================================
    // B.3. STATE_PHASE1_FIRE_WEB: Tích điện vàng và bắn Lightning Web
    // =========================================================================
    case WS_STATE.PHASE1_FIRE_WEB:
        hsp = 0;
        vsp = 0;
        wire_active = true;
        anchor_x = x;
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        state_timer++;
        
        // Shoot at frame 25
        if (state_timer == 25) {
            var _base_dir = (target != noone) ? point_direction(x, y - 10, target.x, target.y - 12) : ((facing == 1) ? 0 : 180);
            var _proj = instance_create_layer(x + (facing * 16), y - 10, "Instances", obj_lightning_web_proj);
            _proj.direction = _base_dir;
            _proj.speed = 2.6;
            camera_shake(1, 4);
        }
        
        if (state_timer >= 35) {
            state = WS_STATE.PHASE1_ASCEND;
            state_timer = 0;
        }
        break;
        
    // =========================================================================
    // B.4. STATE_PHASE1_ASCEND: Kéo ngược thân lên trần
    // =========================================================================
    case WS_STATE.PHASE1_ASCEND:
        hsp = 0;
        wire_active = true;
        y = max(y_ceiling - 48, y - 4.5);
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        
        if (y <= y_ceiling - 48) {
            y = y_ceiling - 48;
            wire_active = false;
            state_timer = 0;
            
            // Phase transition check: HP <= 24
            if (hp <= 24) {
                state = WS_STATE.PHASE2_TRANSITION;
                phase = 2;
            } else {
                state = WS_STATE.PHASE1_CANOPY_HIDE;
            }
        }
        break;
        
    // =========================================================================
    // C.1. STATE_PHASE2_TRANSITION: Lao xuống tâm & dựng mạng nhện khổng lồ
    // =========================================================================
    case WS_STATE.PHASE2_TRANSITION:
        is_invulnerable = true;
        state_timer++;
        
        // 0..20: Thả tơ di chuyển từ trên vòm cây xuống đúng tâm mạng nhện
        if (state_timer < 20) {
            wire_active = true;
            anchor_x = center_node_x;
            var _cdir = point_direction(x, y, center_node_x, center_node_y);
            var _cdist = point_distance(x, y, center_node_x, center_node_y);
            if (_cdist > 4.0) {
                x += lengthdir_x(6.0, _cdir);
                y += lengthdir_y(6.0, _cdir);
            } else {
                x = center_node_x;
                y = center_node_y;
            }
        } else {
            wire_active = false;
            x = center_node_x;
            y = center_node_y;
        }
        
        // Tại tick 22: Tiếp đất tâm mạng, chổng bụng truyền điện tích và bung mạng nhện khổng lồ
        if (state_timer == 22 && !instance_exists(obj_giant_web_network)) {
            web_network_inst = instance_create_layer(center_node_x, center_node_y, "Instances", obj_giant_web_network);
            camera_shake(4, 12);
            if (object_exists(oFX_HitSpark)) {
                instance_create_layer(center_node_x, center_node_y, "Instances", oFX_HitSpark);
            }
        }
        
        if (state_timer >= 70) {
            state = WS_STATE.PHASE2_WEB_MOVE;
            state_timer = 0;
            current_node = 0;
            is_invulnerable = false;
        }
        break;
        
    // =========================================================================
    // C.2. STATE_PHASE2_WEB_MOVE: Bò trên các điểm nút của mạng nhện
    // =========================================================================
    case WS_STATE.PHASE2_WEB_MOVE:
        wire_active = false;
        anim_timer += 0.2;
        
        if (state_timer == 0) {
            // Pick a new node from 8 outer vertices
            var _avail = [];
            for (var i = 1; i <= 8; i++) {
                if (i != current_node) array_push(_avail, i);
            }
            target_node = _avail[irandom(array_length(_avail) - 1)];
        }
        state_timer++;
        
        var _dest_x = web_nodes[target_node][0];
        var _dest_y = web_nodes[target_node][1];
        var _dist = point_distance(x, y, _dest_x, _dest_y);
        var _dir = point_direction(x, y, _dest_x, _dest_y);
        facing = (x >= _dest_x) ? -1 : 1;
        
        if (_dist <= 4.0) {
            x = _dest_x;
            y = _dest_y;
            current_node = target_node;
            state_timer = 0;
            
            // Alternate between Attack Web and Spawn Spiders
            p2_attack_cycle = (p2_attack_cycle + 1) % 2;
            if (p2_attack_cycle == 0) {
                state = WS_STATE.PHASE2_ATTACK_WEB;
            } else {
                state = WS_STATE.PHASE2_SPAWN_SPIDERS;
            }
        } else {
            x += lengthdir_x(3.5, _dir);
            y += lengthdir_y(3.5, _dir);
        }
        break;
        
    // =========================================================================
    // C.3. STATE_PHASE2_ATTACK_WEB: Tích điện & bắn Lightning Web đuổi theo
    // =========================================================================
    case WS_STATE.PHASE2_ATTACK_WEB:
        wire_active = false;
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        state_timer++;
        
        if (state_timer == 20) {
            var _base_dir = (target != noone) ? point_direction(x, y - 10, target.x, target.y - 12) : ((facing == 1) ? 0 : 180);
            var _proj = instance_create_layer(x + (facing * 16), y - 10, "Instances", obj_lightning_web_proj);
            _proj.direction = _base_dir;
            _proj.speed = 2.6;
            camera_shake(1, 4);
        }
        
        if (state_timer >= 45) {
            state = WS_STATE.PHASE2_WEB_MOVE;
            state_timer = 0;
        }
        break;
        
    // =========================================================================
    // C.4. STATE_PHASE2_SPAWN_SPIDERS: Thả 4 nhện con bay đường vòng cung xuống sàn
    // =========================================================================
    case WS_STATE.PHASE2_SPAWN_SPIDERS:
        wire_active = false;
        if (target != noone) facing = (target.x >= x) ? 1 : -1;
        state_timer++;
        
        // Rhythmic, sequential mini spider ejection from the open back hatch (Row 4)
        // Spawn 4 spiders at ticks 18, 25, 32, 39:
        var _spawn_ticks = [18, 25, 32, 39];
        var _hsp_configs = [-0.85, -0.30, 0.30, 0.85];
        var _crawl_dirs  = [-1, -1, 1, 1];
        
        for (var i = 0; i < 4; i++) {
            if (state_timer == _spawn_ticks[i]) {
                var _hatch_x = x - (facing * 8);
                var _hatch_y = y - 18;
                var _sp = instance_create_layer(_hatch_x, _hatch_y, "Instances", obj_mini_spider);
                _sp.hsp = _hsp_configs[i];
                _sp.vsp = -3.2; // graceful pop-up arc out of the back hatch
                _sp.crawl_dir = _crawl_dirs[i];
                _sp.spider_state = SPIDER_MINION_STATE.AIR;
                
                camera_shake(1, 3);
                if (object_exists(oFX_HitSpark)) {
                    instance_create_layer(_hatch_x, _hatch_y, "Instances", oFX_HitSpark);
                }
            }
        }
        
        if (state_timer >= 55) {
            state = WS_STATE.PHASE2_WEB_MOVE;
            state_timer = 0;
        }
        break;
        
    // =========================================================================
    // D. STATE_WIRE_CUT_FALL: Rơi tự do & chuỗi 14 frames khi trúng chém lửa Zero
    // =========================================================================
    case WS_STATE.WIRE_CUT_FALL:
        wire_active = false;
        is_invulnerable = true;
        invincible_timer = max(invincible_timer, 2);
        state_timer++;
        
        switch (weakness_phase) {
            // -----------------------------------------------------------------
            // Phase 0: Rơi tự do từ trên cao xuống sàn (Frames 0..1)
            // -----------------------------------------------------------------
            case 0:
                vsp = min(vsp + 0.50, 9.5);
                y += vsp;
                
                // Frame 0..1: Rơi lộn nhào trong không trung
                if (vsp < 4.0) {
                    weakness_frame = 0;
                } else {
                    weakness_frame = 1;
                }
                
                // Khi chạm sàn
                if (y >= y_floor) {
                    y = y_floor;
                    vsp = 0;
                    ground_timer = 0;
                    weakness_frame = 2; // Frame 2: Va đập đất tóe tia lửa
                    weakness_phase = 1; // Chuyển sang Phase 1 trên sàn!
                    camera_shake(3, 8);
                    if (object_exists(oFX_HitSpark)) {
                        instance_create_layer(x, y_floor, "Instances", oFX_HitSpark);
                    }
                }
                break;
                
            // -----------------------------------------------------------------
            // Phase 1: Nằm trên sàn, co giật, lăn lộn, gượng dậy (Frames 2..12)
            // -----------------------------------------------------------------
            case 1:
                y = y_floor;
                vsp = 0;
                ground_timer++;
                
                // Frame 2: Va đập đất (giữ 8 frames)
                if (ground_timer < 8) {
                    weakness_frame = 2;
                } 
                // Frames 3..12: Chuỗi 10 frames giãy giụa và đứng dậy (mỗi frame 3 ticks = 30 ticks)
                else if (ground_timer < 8 + (10 * 3)) {
                    var _step = floor((ground_timer - 8) / 3);
                    weakness_frame = clamp(3 + _step, 3, 12);
                } 
                // Hoàn thành giãy giụa -> Chuyển sang Phase 2 bật lò xo đu tơ lên trần!
                else {
                    weakness_phase = 2;
                    weakness_frame = 13; // Frame 13: Thế bật lò xo phóng lên
                    vsp = -7.0;
                    anchor_x = x;
                }
                break;
                
            // -----------------------------------------------------------------
            // Phase 2: Đu tơ phóng vút ngược lên lại vòm cây trần nhà (Frame 13)
            // -----------------------------------------------------------------
            case 2:
                weakness_frame = 13;
                vsp = max(vsp - 0.25, -9.0); // Tăng dần tốc độ kéo lên trần
                y += vsp;
                
                // Khi đã chạm tới vòm cây trên trần nhà an toàn
                if (y <= y_ceiling - 40) {
                    y = y_ceiling - 40;
                    vsp = 0;
                    hsp = 0;
                    state_timer = 0;
                    ground_timer = 0;
                    weakness_phase = 0;
                    is_invulnerable = false;
                    invincible_timer = 0;
                    
                    // Tiếp tục trận đấu!
                    if (hp <= 24) {
                        if (instance_exists(web_network_inst)) {
                            state = WS_STATE.PHASE2_WEB_MOVE;
                        } else {
                            state = WS_STATE.PHASE2_TRANSITION;
                        }
                        phase = 2;
                    } else {
                        state = WS_STATE.PHASE1_CANOPY_HIDE;
                    }
                }
                break;
        }
        break;
        
    // =========================================================================
    // E. STATE_DEATH: Trùm co giật chịu chuỗi nổ liên hoàn và đại nổ kết liễu
    // =========================================================================
    case WS_STATE.DEATH:
        hsp = 0;
        vsp = 0;
        is_invulnerable = true;
        wire_active = false;
        death_timer--;
        
        // Giai đoạn 1: Chuỗi nổ liên hoàn rải đều khắp cơ thể trùm (death_timer 130 -> 30)
        if (death_timer > 28) {
            if (death_timer % 4 == 0) {
                var _ex = x + irandom_range(-34, 34);
                var _ey = y + irandom_range(-28, 28);
                if (object_exists(oFX_EnemyExplosion)) {
                    instance_create_layer(_ex, _ey, "Instances", oFX_EnemyExplosion);
                }
                camera_shake(3, 5);
            }
            if (death_timer % 7 == 0 && object_exists(oFX_HitSpark)) {
                instance_create_layer(x + irandom_range(-20, 20), y + irandom_range(-20, 20), "Instances", oFX_HitSpark);
            }
        } 
        // Giai đoạn 2: Đại nổ kết liễu tỏa tròn 6 vụ nổ đồng thời (Star-burst blast) tại tick 28
        else if (death_timer == 28) {
            for (var _ang = 0; _ang < 360; _ang += 60) {
                var _bx = x + lengthdir_x(32, _ang);
                var _by = y + lengthdir_y(26, _ang);
                if (object_exists(oFX_EnemyExplosion)) {
                    instance_create_layer(_bx, _by, "Instances", oFX_EnemyExplosion);
                }
            }
            if (object_exists(oFX_EnemyExplosion)) {
                instance_create_layer(x, y, "Instances", oFX_EnemyExplosion);
            }
            camera_shake(7, 24);
        }
        
        // Giai đoạn 3: Tiêu diệt hoàn toàn trùm và mở cờ thắng màn
        if (death_timer <= 0) {
            global.boss_defeated = true;
            if (instance_exists(oTrigger_BossGate)) {
                with (oTrigger_BossGate) {
                    if (gate_state != GATE_STATE.LOCKED) {
                        gate_state = GATE_STATE.OPENING;
                    }
                }
            }
            instance_destroy();
        }
        break;
}
