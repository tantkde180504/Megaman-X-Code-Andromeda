/// @desc Megaman X4 Core Constants & Enums

// Character selection
enum CHAR_TYPE {
    X,
    ZERO
}

// Player state machine states
enum PLAYER_STATE {
    IDLE,
    RUN,
    JUMP,
    FALL,
    DASH,
    WALL_SLIDE,
    WALL_JUMP,
    LADDER,
    HURT,
    DEATH,
    INTRO,
    TELEPORT_OUT
}

// Zero special techniques
enum TECHNIQUE {
    NONE,
    RYUENJIN,       // Up + Special (ground) - Flame dragon uppercut
    HYOURETSUZAN,   // Down + Special (air) - Ice plunge stab
    KUUENZAN,       // Neutral / Direction + Special (air) - Spinning saber
    RAIJINGEKI      // Neutral Special (ground) - Lightning thrust
}

// Boss Gate State
enum GATE_STATE {
    CLOSED,
    OPENING,
    WALKING,
    WAIT_CLOSE,
    CLOSING,
    LOCKED
}

// Web Spider Boss States (Mega Man X4 Authentic Specification)
enum WS_STATE {
    INTRO,
    PHASE1_CANOPY_HIDE,
    PHASE1_DESCEND,
    PHASE1_FIRE_WEB,
    PHASE1_ASCEND,
    PHASE2_TRANSITION,
    PHASE2_WEB_MOVE,
    PHASE2_ATTACK_WEB,
    PHASE2_SPAWN_SPIDERS,
    WIRE_CUT_FALL,
    DEATH
}

// Mini Spider Minion States
enum SPIDER_MINION_STATE {
    AIR,
    FLOOR,
    WALL
}

// Legacy alias for compatibility
enum SPIDER_STATE {
    INTRO,
    CEILING_IDLE,
    CEILING_MOVE,
    DESCEND,
    ASCEND,
    ATTACK_WEB,
    HURT,
    DEATH
}

// Target Resolution
#macro VIEW_WIDTH 480
#macro VIEW_HEIGHT 270

// Physics Constants (Original X4 Frame-Accurate Tuning)
#macro GRAVITY 0.25
#macro WATER_GRAVITY 0.12
#macro MAX_FALL_SPEED 8.0
#macro MAX_WATER_FALL_SPEED 3.5
#macro RUN_SPEED 2.5
#macro DASH_SPEED 5.0
#macro DASH_JUMP_SPEED 5.4
#macro DASH_DURATION 16
#macro AIR_DASH_DURATION 14
#macro JUMP_VELOCITY -5.5
#macro WATER_JUMP_VELOCITY -4.5
#macro JUMP_RELEASE_GRAV 0.45
#macro WALL_SLIDE_SPEED 1.5
#macro WALL_JUMP_X_SPEED 3.0
#macro WALL_JUMP_Y_SPEED -5.0
#macro WALL_JUMP_LOCK_FRAMES 8
#macro COYOTE_FRAMES 4
#macro BUFFER_FRAMES 6

// X-Buster Constants
#macro CHARGE_LV1_FRAMES 30
#macro CHARGE_LV2_FRAMES 60

// Zero Combo Timing
#macro COMBO_RESET_FRAMES 20
