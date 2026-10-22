// Shared Enemy Properties (Section 4 Specification)
hp = 4;
max_hp = 4;
move_speed = 1.2;
grav = 0.25;
facing = -1;
state = 0;
state_timer = 0;
attack_cooldown = 0;
invulnerability_timer = 0;
flash_timer = 0;
contact_damage = 3;
projectile_damage = 2;
knockback = 1.8;
target = noone;
is_dead = false;
stage_frozen = false;
is_invulnerable = false;
shield_direction = 0; // 0: 360-degree, 1: Frontal shield

// Physics
hsp = 0;
vsp = 0;
grounded = false;
anim_timer = 0;
active_dist = 440;
