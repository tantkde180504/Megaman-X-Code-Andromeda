# Megaman X4 GameMaker Studio 2 Project — Context & Architecture

## 1. Project Overview
- **Project Name:** MegamanZ (Megaman X4 Fan-Recreation)
- **Engine:** GameMaker Studio 2 / 2026 LTS (Runtime 2026.0.0.23)
- **Native Resolution:** 480 × 270 (16:9), upscaled pixel-perfect to 960×540, 1440×810, 1920×1080
- **Target Framerate:** 60 FPS fixed step
- **Physics Philosophy:** Pure custom physics engine (NO built-in physics). Deterministic, frame-accurate Mega Man X4 feel.

---

## 2. Directory Structure & Naming Conventions

```
d:\MZ4\
├── megaman_x4_gamemaker_plan.md     # Master plan from user
├── CONTEXT.md                       # Architecture & execution record
└── MegamanZ/                        # GameMaker project root
    ├── MegamanZ.yyp                 # Main GMS2 project manifest
    ├── MegamanZ.resource_order      # Resource tree ordering
    ├── options/                     # Platform options
    ├── rooms/
    │   └── Room1/                   # Test movement playground (480x270)
    ├── objects/
    │   ├── Core/                    # oGame, oCamera, oInput
    │   ├── Environment/             # oSolid, oOneWayPlatform, oHazardSpike, oLadder
    │   ├── Player/                  # oPlayer (parent), oPlayerX, oPlayerZero
    │   ├── Weapons/                 # oBullet_Buster, oBullet_Charged, oSaberSlash
    │   └── UI/                      # oUI_HUD
    ├── scripts/
    │   ├── scr_constants/           # Enums, macros, physics values
    │   ├── scr_input/               # Input buffer, gamepad & keyboard polling
    │   ├── scr_player_physics/      # Movement, sub-pixel math, collision
    │   ├── scr_player_states/       # State machine methods (idle, run, dash, jump...)
    │   ├── scr_combat/              # Damage dealing, hitboxes, iframes
    │   └── scr_camera/              # Camera tracking, deadzone, screen shake
    └── sprites/                     # Visual assets & masks
```

---

## 3. Physics & Frame Constants (Original X4 Calibration)

| Parameter | Value | Notes |
|:---|:---|:---|
| `GRAVITY` | 0.25 px/frame² | Constant downwards acceleration |
| `MAX_FALL_SPEED` | 8.0 px/frame | Terminal fall speed |
| `RUN_SPEED` | 2.5 px/frame | Horizontal running speed |
| `DASH_SPEED` | 5.0 px/frame | Dash speed |
| `DASH_FRAMES` | 16 frames | Dash duration (~0.27s), cancellable by jump/dash slash |
| `JUMP_VELOCITY` | -5.5 px/frame | Full jump impulse |
| `JUMP_RELEASE_GRAV` | 0.45 px/frame² | Extra gravity when jump is released early (variable jump) |
| `WALL_SLIDE_SPEED` | 1.5 px/frame | Max descent speed while sliding on wall |
| `WALL_JUMP_X_SPEED`| 3.0 px/frame | Kick velocity away from wall |
| `WALL_JUMP_Y_SPEED`| -5.0 px/frame| Kick upward velocity |
| `WALL_JUMP_LOCK`   | 8 frames | Temporary horizontal input lockout after wall jump |
| `COYOTE_FRAMES`    | 4 frames | Jump allowed after stepping off ledge |
| `JUMP_BUFFER`      | 6 frames | Pre-jump input buffer window |

---

## 4. Phase Execution Roadmap

- **Phase 0 (Core Engine):** [COMPLETED] Physics, collision (solids, one-way platforms, ladders, spikes), input buffer, camera lerp & screenshake, playground test room.
- **Phase 1 (Player Systems):** [COMPLETED] Dual-character framework (X & Zero), buster charging (Lv1, Lv2, Lv3), 3-hit saber combo, air slash, dash slash, saber dash cancel, techniques (Ryuenjin, Hyouretsuzan, Kuuenzan, Raijingeki), HP & HUD.
- **Phase 2 (Level Pipeline & Stages):** [COMPLETED]
  - Parallax Background System (`oParallaxBackground` with far & mid mountain/forest layers)
  - Interactive stage gimmicks: Falling leaf platforms (`oPlatform_Falling`), Slippery ice surface (`oIceSurface`), Water buoyancy & swim physics (`oWater`), Destructible sticky web traps (`oWebTrap`).
  - Checkpoint System (`oTrigger_Checkpoint` with dynamic respawn coordinates and full health restoration on death).
  - Boss Gate Transition (`oTrigger_BossGate` with door slide open, automated player walk-through, screen scroll, and lock).
  - Collectibles & Armor Upgrade: Heart Tank (`oPickup_HeartTank` for permanent +2 max HP), Sub-Tank (`oPickup_SubTank`), Dr. Light Capsule (`oCapsule_Light` granting Leg Parts / Air Dash).
  - Air Dash mechanic: Dash in mid-air once per airborne cycle.
  - 2 Complete Stages:
    - `rStage_Intro` (Intro Stage — Ruined Skyway, 2400×540)
    - `rStage_WebSpider` (Stage 1 — Deep Jungle, 2400×810)
    - Quick Stage switching via keys `1` (Playground), `2` (Intro Stage), `3` (Web Spider Stage).
- **Phase 3 (Enemies & Bosses):** [NEXT] Enemy parent, common enemy types (Walker, Shooter, Flyer), Web Spider boss state machine & phases.
- **Phase 4 (Special Weapons):** 8 weapons for X, palette swap shader, Giga Attacks (Nova Strike, Rakuhouha).
- **Phase 5 (Progression & UI):** Title screen, Character Select, Stage Select (8 bosses), Pause menu, Save/Load (JSON).
- **Phase 6 (Audio & VFX):** Audio manager with BGM looping & SFX, particle engine, hitstop & screen flash.
- **Phase 7 (Endgame):** Colonel, Spaceport, Final Weapon 1-3, Sigma 3-phase fight, endings.
- **Phase 8 (QA & Polish):** Bug fixes, balance pass, release build.
