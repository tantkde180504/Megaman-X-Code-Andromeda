/// @desc Web Spider Boss Create (Authentic Mega Man X4 Architecture)
event_inherited();

// 1. Core Boss Stats (Authentic MMX4)
boss_name = "WEB SPIDER";
hp_max = 48;
hp = hp_max;
prev_hp = hp_max;
hp_display = 0;
intro_done = false;

phase = 1;
dmg_contact = 6;
dmg_thread = 3;
dmg_lightning_web = 4;
dmg_mini_spider = 4;

invincible_timer = 0;
flash_timer = 0;
is_invulnerable = false;

// 2. Arena Geometry & Scaling
image_xscale = 2.0;
image_yscale = 1.8;
facing = 1;
hsp = 0;
vsp = 0;

// Dynamic ceiling and floor detection
y_ceiling = 32;
var _scan_up = y;
while (_scan_up > 0 && !place_meeting(x, _scan_up, oSolid)) {
    _scan_up--;
}
if (_scan_up > 0) y_ceiling = _scan_up + 16; else y_ceiling = max(32, y - 80);

y_floor = room_height - 48;
var _scan_down = y;
while (_scan_down < room_height && !place_meeting(x, _scan_down, oSolid)) {
    _scan_down++;
}
if (_scan_down < room_height) y_floor = _scan_down - 24; else y_floor = y + 140;

arena_left = max(32, x - 180);
arena_right = min(room_width - 32, x + 180);
arena_center_x = (arena_left + arena_right) * 0.5;
arena_center_y = y_ceiling + ((y_floor - y_ceiling) * 0.45);

// Silk thread anchor
anchor_x = x;
wire_active = false;
wire_cut_timer = 0;

// 3. Phase 2 Web Network & 9 Web Nodes
center_node_x = arena_center_x;
center_node_y = arena_center_y;
web_radius = 88;

web_nodes = array_create(9);
web_nodes[0] = [center_node_x, center_node_y]; // Node 0: Center
for (var i = 0; i < 8; i++) {
    var _ang = i * 45;
    web_nodes[i + 1] = [center_node_x + lengthdir_x(web_radius, _ang), center_node_y + lengthdir_y(web_radius, _ang)];
}
current_node = 0;
target_node = 0;
web_network_inst = noone;

// 4. State Machine & Attack Variables
state = WS_STATE.INTRO;
state_timer = 0;
warning_timer = 90;
anim_timer = 0;
anim_frame = 0.0;

target_x = x;
target_y = y;
p2_attack_cycle = 0; // alternates web attack vs mini spiders
death_timer = 0;
weakness_frame = 0;
ground_timer = 0;

// Start positioned at ceiling
y = y_ceiling - 40;

// 5. take_damage method (Weakness Reaction: Zero's fire slash / Ryuenjin)
take_damage = function(_amount, _is_weakness = false, _hit_wire = false, _element = "normal") {
    if (state == WS_STATE.INTRO || state == WS_STATE.DEATH || is_invulnerable) return;
    
    // Check Weakness: Zero's fire slash (Ryuenjin / element == "fire") or wire cut
    var _fire_weakness = (_is_weakness || _element == "fire");
    
    if (_fire_weakness || _hit_wire) {
        // Trigger 14-frame weakness hurt reaction (Row 2 & Row 3)
        wire_active = false;
        state = WS_STATE.WIRE_CUT_FALL;
        state_timer = 0;
        ground_timer = 0;
        weakness_frame = 0;
        vsp = 0;
        flash_timer = 16;
        invincible_timer = 999; // Remains invulnerable throughout falling and recovery!
        is_invulnerable = true;
        hp = max(0, hp - max(_amount, 6)); // bonus damage on weakness
        camera_shake(3, 8);
        return;
    }
    
    hp = max(0, hp - _amount);
    flash_timer = 8;
    invincible_timer = 24;
    is_invulnerable = true;
    camera_shake(2, 6);
    
    if (hp <= 0 && state != WS_STATE.DEATH) {
        state = WS_STATE.DEATH;
        state_timer = 0;
        death_timer = 120;
        is_invulnerable = true;
        wire_active = false;
    }
};
