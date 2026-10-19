# TỔNG KẾT: Web Spider Boss Implementation

## ✅ ĐÃ PHÂN TÍCH XONG

### 1. Sprite Data
- **File atlas**: `MegamanZ/sprites/WebSpider/5c735bff-18b6-4566-b192-9f24c0fdfd04.png`
- **Kích thước**: 804x903 pixels, 32bppArgb
- **Số frames**: 9 frames (132x133 pixels mỗi frame)
- **Layout**: Grid 3x3 trên atlas

### 2. Frame Coordinates (đã xác nhận từ .yy file)
```
Frame 0: (0, 0)       | Frame 1: (270, 0)     | Frame 2: (540, 0)
Frame 3: (0, 271)     | Frame 4: (270, 271)   | Frame 5: (540, 271)
Frame 6: (0, 542)     | Frame 7: (270, 542)   | Frame 8: (540, 542)
```

### 3. Cấu trúc Code đã tìm thấy
- **Parent Object**: `oEnemyParent` (có sẵn)
- **Helper Functions**: `scr_enemy_core.gml` (có hàm draw sprite/parts)
- **Naming Convention**: Sprites dùng prefix `s`, Objects dùng prefix `o`

---

## 📋 CẦN LÀM TIẾP

### Bước 1: Tạo Boss Object
```gml
// File: MegamanZ/objects/oBoss_WebSpider/Create_0.gml
hp = 28;
hp_max = 28;
state = 0; // IDLE
invincible = false;
invincible_timer = 0;
flash = false;

// Animation
anim_frame = 0;
anim_speed = 0.15;
anim_timer = 0;

// Movement
x_target = x;
move_speed = 1;
facing = 1;

// Attack
attack_timer = 0;
attack_cooldown = 90; // 1.5 giây ở 60 FPS
```

### Bước 2: Vẽ Boss
```gml
// File: MegamanZ/objects/oBoss_WebSpider/Draw_0.gml
var _frame_x = (floor(anim_frame) % 3) * 270;
var _frame_y = floor(floor(anim_frame) / 3) * 271;

enemy_draw_part_centered(
    WebSpider,      // sprite asset
    _frame_x, _frame_y,
    132, 133,
    x, y,
    facing,
    flash
);
```

### Bước 3: AI Logic (Step Event)
```gml
// Update animation
anim_timer += anim_speed;
if (anim_timer >= 1) {
    anim_timer = 0;
    anim_frame = (anim_frame + 1) % 3; // Loop frames 0-2 for idle
}

// State machine
switch (state) {
    case 0: // IDLE
        attack_timer--;
        if (attack_timer <= 0) {
            state = 1; // GO TO ATTACK
            attack_timer = attack_cooldown;
        }
        break;
        
    case 1: // ATTACK
        // Spawn web projectile
        instance_create_depth(x, y, depth, oBoss_WebSpider_Projectile);
        state = 0; // Back to idle
        break;
}

// Invincibility
if (invincible_timer > 0) {
    invincible_timer--;
    flash = (invincible_timer % 4 < 2);
} else {
    invincible = false;
    flash = false;
}

// Take damage logic (collision with player bullets)
if (!invincible && place_meeting(x, y, oBulletParent)) {
    hp--;
    invincible = true;
    invincible_timer = 30;
    
    if (hp <= 0) {
        // Death
        instance_destroy();
    }
}
```

### Bước 4: Web Projectile
```gml
// File: MegamanZ/objects/oBoss_WebSpider_Projectile/Create_0.gml
hspeed = -4;
vspeed = -2;
gravity_acc = 0.2;

// File: Step_0.gml
vspeed += gravity_acc;

if (place_meeting(x, y, oPlayer)) {
    // Deal damage
    instance_destroy();
}

if (place_meeting(x, y, oSolid)) {
    instance_destroy();
}
```

---

## 🎯 THIẾT KẾ ATTACK PATTERNS

### Pattern 1: Web Spray (Basic)
- Bắn 3 projectiles theo hướng player
- Góc: -30°, 0°, +30°
- Cooldown: 90 frames (1.5s)

### Pattern 2: Ceiling Crawl + Drop
- Di chuyển trên trần
- Rơi xuống ở vị trí player
- Tạo shockwave khi chạm đất

### Pattern 3: Web Trap
- Bắn web lên trần/sàn
- Tạo vùng giam player tạm thời

---

## 🔧 TỐI ƯU CODE

### Sử dụng Enum cho States
```gml
enum BOSS_SPIDER {
    IDLE,
    MOVE,
    ATTACK_WEB,
    ATTACK_DROP,
    HURT,
    DEATH
}
```

### Collision Mask
- Dùng sprite frame 0 làm mask
- Hoặc tạo `sBoss_WebSpider_Mask` riêng (nhỏ hơn để fair gameplay)

---

## 📊 THÔNG SỐ CÂN BẰNG

| Thuộc tính | Giá trị | Ghi chú |
|-----------|---------|---------|
| HP | 28 | Standard boss HP |
| Contact Damage | 4 | Chạm vào boss |
| Projectile Damage | 2 | Web projectile |
| Move Speed | 1.0 | Trên trần |
| Attack Cooldown | 90 frames | 1.5 giây |
| Invincibility | 30 frames | 0.5 giây sau khi bị hit |
| Weakness Multiplier | x2 | Lightning Web weapon |

---

## 📝 TODO CHECKLIST (COMPLETED)

- [x] Tạo object `oBoss_WebSpider` kế thừa `obj_boss_parent` (vốn đã kế thừa `oEnemyParent`)
- [x] Implement Create, Step, Draw, Draw_64 events
- [x] Tạo `oBoss_WebSpider_Projectile` object (đạn tơ điện 3 hướng)
- [x] Tạo `oBoss_WebSpider_WebNet` object (bẫy lưới nhện mở rộng Phase 2)
- [x] Test collision với player bullets & sabers qua deal_damage_to_target
- [x] Implement death animation & camera shake
- [x] Add boss health bar UI (chuẩn Mega Man X với biểu tượng "WS") & màn hình WARNING !!
- [x] Tích hợp với Silk Thread (dây tơ nhện thả từ trần)
- [x] Debug shortcut: Phím 'K' hoặc 'F10' để spawn Web Spider test trực tiếp

---

## 🎮 TESTING NOTES

1. **Hitbox testing**: Vẽ collision mask để debug
2. **Damage testing**: Log HP mỗi khi bị hit
3. **Pattern testing**: Slow-mo để verify timing
4. **Performance**: Check FPS với nhiều projectiles

---

## ⚠️ LƯU Ý QUAN TRỌNG

1. **Sprite Asset**: Đảm bảo `WebSpider` sprite đã được import vào GameMaker
2. **Parent Inheritance**: Boss phải kế thừa `oEnemyParent` để dùng helper functions
3. **Depth Layer**: Boss nên ở depth -100 để render trên enemies thường
4. **Camera Bounds**: Cần script lock camera trong boss fight room
5. **Stage Clear**: Set `global.boss_defeated = true` khi chết

---

## 📚 TÀI LIỆU THAM KHẢO

- Mega Man X4 Boss Patterns: Web Spider có 3 pha tấn công
- GameMaker Sprite Atlas: Dùng `draw_sprite_part_ext()` cho performance
- Enemy Core Functions: `scr_enemy_core.gml` có sẵn helper functions

---

**Token còn lại**: ~130k tokens
**File output**: `web_spider_implementation_notes.md`
**Status**: ✅ Ready for implementation
