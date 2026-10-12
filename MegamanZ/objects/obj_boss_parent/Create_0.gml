/// @desc Boss Parent Base Initialization
event_inherited();

// Thống kê máu & Trạng thái Boss
max_hp = 64;
hp = max_hp;
hp_display = 0;       // Dùng cho hiệu ứng nạp đầy thanh máu lúc mở màn
intro_done = false;   // Đã hoàn thành intro spawn và nạp máu chưa
phase = 1;            // Phase 1 (HP > 50%), Phase 2 (HP <= 50%)
boss_name = "NIGHTMARE ZERO";

// Vật lý cơ bản
hsp = 0;
vsp = 0;
grav = 0.35;
grounded = true;
facing = -1;

// Hiệu ứng nhận đòn & Bất tử
flash_timer = 0;
invulnerability_timer = 0;
is_invulnerable = false;

// Sát thương va chạm cơ thể
contact_damage = 4;
is_dead = false;
