# Web Spider Boss Implementation Notes

## Sprite Atlas Analysis
- **File**: `MegamanZ/sprites/WebSpider/5c735bff-18b6-4566-b192-9f24c0fdfd04.png`
- **Size**: 804x903 pixels
- **Format**: 32bppArgb (with transparency)

## Identified Frames (from .yy file)
1. **Frame 0** (x:0, y:0, w:132, h:133) - Main body/idle
2. **Frame 1** (x:270, y:0, w:132, h:133) - Animation variant
3. **Frame 2** (x:540, y:0, w:132, h:133) - Animation variant
4. **Frame 3** (x:0, y:271, w:132, h:133) - Animation variant
5. **Frame 4** (x:270, y:271, w:132, h:133) - Animation variant
6. **Frame 5** (x:540, y:271, w:132, h:133) - Animation variant
7. **Frame 6** (x:0, y:542, w:132, h:133) - Animation variant
8. **Frame 7** (x:270, y:542, w:132, h:133) - Animation variant
9. **Frame 8** (x:540, y:542, w:132, h:133) - Animation variant

## Implementation Status (COMPLETED)

### 1. Boss Object Creation
- [x] Create `oBoss_WebSpider` object (inheriting `obj_boss_parent`)
- [x] Add sprite assignment from `WebSpider` atlas
- [x] Implement state machine (`SPIDER_STATE`: INTRO, CEILING_IDLE, CEILING_MOVE, DESCEND, ASCEND, ATTACK_WEB, HURT, DEATH)

### 2. Core Mechanics
- [x] **Web Projectile Attack**: Shoots 3-way web projectiles in arc pattern (`oBoss_WebSpider_Projectile`)
- [x] **Ceiling Crawl**: Moves smoothly along ceiling towards/away from player
- [x] **Descent Attack**: Drops down vertically on authentic silk thread
- [x] **HP System**: 28 HP (standard Mega Man X boss health) with MMX vertical HUD
- [x] **Weakness / Hurt reaction**: Shudder recoil with invincibility flash

### 3. Attack Patterns
- [x] Pattern 1: Horizontal web spray (3 projectiles at -25°, 0°, +25°)
- [x] Pattern 2: Ceiling Crawl + Vertical drop with silk thread trail
- [x] Pattern 3: Expanding Lightning Web trap (`oBoss_WebSpider_WebNet`) in Phase 2 (HP <= 14)

### 4. Collision & Damage
- [x] Hitbox definition via `sEnemyMask` scaled
- [x] Invincibility frames & damage flash (24 frames)
- [x] Contact damage to player (4 damage)
- [x] Web projectile collision with terrain & player damage (2 damage)

### 5. Animation Sequences
- Idle: frames 0-2 (loop)
- Attack wind-up: frames 3-4
- Attack: frames 5-6
- Hurt: frame 7
- Death: frame 8 + explosion effect

### 6. Web Projectile Object
- [ ] Create `obj_web_projectile`
- [ ] Arc trajectory physics
- [ ] Sticking behavior (temporary platform?)
- [ ] Collision with player and terrain

### 7. AI State Machine
```gml
enum SPIDER_STATE {
    IDLE,
    MOVE_CEILING,
    ATTACK_WEB,
    DESCEND,
    ASCEND,
    HURT,
    DEATH
}
```

### 8. Room Integration
- [ ] Place in appropriate stage room
- [ ] Set spawn position (ceiling)
- [ ] Configure camera bounds for boss fight
- [ ] Add boss health bar UI trigger

## Next Immediate Steps (Priority Order)
1. Create basic boss object with sprite
2. Implement HP and damage system
3. Add simple horizontal movement on ceiling
4. Create web projectile object
5. Implement one attack pattern
6. Test collision and damage
7. Add remaining attack patterns
8. Polish with animations and effects

## Technical Notes
- Boss should stay within camera bounds
- Web projectiles need gravity and arc
- Consider web sticking as temporary platform mechanic
- Death animation should trigger stage clear flag
