/// @desc Khởi tạo Hiệu Ứng Hạ Gục Mega Man X4 (Create Event)

player_id = noone;
character_type = "X";
death_style = "MMX4_PS1";     // "MMX4_PS1" (chuẩn Mega Man X4) hoặc "MMX1_SNES"
use_procedural_draw = true;    // Mặc định true: vẽ procedural phát sáng mượt mà bằng code GML

timer = 0;
state = 0;                     // 0: HIT_FREEZE, 1: CORE_IMPLOSION, 2: RING_BURST, 3: SCREEN_TRANSITION, 4: RESPAWN_FADEIN

origin_x = x;
origin_y = y - 18;             // Tâm ngực của nhân vật

rings = [];                    // Mảng chứa các struct DeathRing
sparks = [];                   // Tia lửa điện nhấp nháy ở Giai đoạn 1

core_scale = 0.4;
core_alpha = 1.0;
fade_alpha = 0.0;
white_flash_alpha = 0.0;

// Cấu hình bảng màu mặc định (Mega Man X)
col_glow_outer = make_color_rgb(0, 120, 255);   // Xanh dương đậm #0078FF
col_glow_mid   = make_color_rgb(0, 235, 255);   // Xanh cyan rực rỡ #00EBFF
col_core       = c_white;                       // Lõi trắng sáng rực #FFFFFF
col_fog        = c_aqua;                        // Chớp nhấp nháy xanh trắng

sound_played_scream = false;
sound_played_burst  = false;
respawn_done        = false;
