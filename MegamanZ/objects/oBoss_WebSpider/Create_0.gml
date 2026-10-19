/// @desc Web Spider Boss Initialization
event_inherited();

// 1. Boss HP & Identity (Standard Mega Man X Boss: 28 HP)
boss_name = "WEB SPIDER";
max_hp = 28;
hp = max_hp;
prev_hp = max_hp;
hp_display = 0;
intro_done = false;
contact_damage = 4;
is_invulnerable = false;
flash_timer = 0;
invulnerability_timer = 0;

// 2. Physics & Scaling
grav = 0.0;
hsp = 0;
vsp = 0;
facing = -1;
image_xscale = 2.0;
image_yscale = 1.8;

// Determine ceiling anchor and floor level dynamically
anchor_x = x;
ceiling_y = y - 48;
ground_y = y + 160;

// Raycast up to find ceiling
var _scan_up = y;
while (_scan_up > 0 && !place_meeting(x, _scan_up, oSolid)) {
    _scan_up--;
}
if (_scan_up > 0) ceiling_y = _scan_up + 16; else ceiling_y = max(32, y - 80);

// Raycast down to find ground
var _scan_down = y;
while (_scan_down < room_height && !place_meeting(x, _scan_down, oSolid)) {
    _scan_down++;
}
if (_scan_down < room_height) ground_y = _scan_down - 28; else ground_y = y + 140;

arena_left = max(32, x - 200);
arena_right = min(room_width - 32, x + 200);

// Start positioned hanging from the ceiling
y = ceiling_y + 36;
drop_target_y = ground_y;
climb_speed = 3.0;

// 3. State Machine & Timers
state = SPIDER_STATE.INTRO;
state_timer = 0;
warning_timer = 90;
anim_frame = 0.0;
anim_spd = 0.15;

attack_pattern = 0;
phase = 1; // Transitions to Phase 2 at <= 14 HP (50%)
death_timer = 0;
web_trap_cooldown = 0;
