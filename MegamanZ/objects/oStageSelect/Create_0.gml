// Stage Select Controller - Mega Man X Style
display_set_gui_size(VIEW_WIDTH, VIEW_HEIGHT);

enum STAGE_SELECT_STATE {
    ELEVATOR_SCROLL,
    BRIEFING,
    STAGE_SELECT,
    LAUNCH
}

state = STAGE_SELECT_STATE.ELEVATOR_SCROLL;
anim_timer = 0;
fade_alpha = 0.0;
flash_alpha = 0.0;

// Background elevator scroll
// Texture is 320x512 (within 5..325, 5..517)
// Viewport height in texture coords: 180 (scaled by 1.5 = 270)
// scroll_y moves from 5 to (512 - 180 + 5) = 337
scroll_y = 5.0;
scroll_max = 337.0;
scroll_spd = 2.2;

// Model LargeX data
x_pos = 36;
y_base = 175;
x_anim_state = "idle"; // "idle", "normal", "boss_map", "launch"
x_frame_idx = 0.0;
x_frame_spd = 0.12;

// LargeX Sprite Coordinates
// Row 1 (6 frames, normal discussion)
r1_boxes = [
    [3, 3, 52, 93],
    [66, 3, 52, 93],
    [129, 3, 52, 93],
    [192, 3, 53, 93],
    [255, 3, 57, 93],
    [321, 3, 57, 93]
];

// Row 2 (3 frames, boss/map discussion)
r2_boss_boxes = [
    [7, 111, 71, 82],
    [86, 111, 71, 82],
    [166, 111, 71, 82]
];

// Row 2 Frame 5 (Index 4, launch pose)
r2_launch_box = [309, 113, 54, 80];

// Dialogue Briefing (one sentence per enter)
dialogue_sentences = [
    {
        speaker: "COMMAND HQ",
        text: "SENSORS DETECTED MAVERICK DISTURBANCES ACROSS KEY SECTORS.",
        anim: "normal"
    },
    {
        speaker: "ALIA",
        text: "RECON DRONES CONFIRMED CHAOS IN THE JUNGLE RUINS AND HIGHWAY.",
        anim: "normal"
    },
    {
        speaker: "ALIA",
        text: "CAUTION: NIGHTMARE ZERO IS AMBUSHING IN THE DEEP JUNGLE SHRINE!",
        anim: "boss_map"
    },
    {
        speaker: "MEGA MAN X",
        text: "NIGHTMARE ZERO... I WILL NOT ALLOW HIM TO TARNISH ZERO'S NAME!",
        anim: "boss_map"
    },
    {
        speaker: "COMMAND HQ",
        text: "SELECT DESTINATION SECTOR AND COMMENCE HUNTER DEPLOYMENT.",
        anim: "normal"
    }
];

dialogue_idx = 0;
dialogue_char_idx = 0.0;
dialogue_type_spd = 0.75;
dialogue_is_typing = false;

// Selectable stages
stages = [
    {
        name: "JUNGLE SECTOR",
        code: "AREA 54",
        boss: "NIGHTMARE ZERO",
        danger: "EXTREME (S-RANK)",
        desc: "DEEP FOREST RUINS OVERRUN BY ROGUE REPLOIDS. VIRAL PHANTOM DETECTED.",
        room_id: rStage_WebSpider,
        spawn_x: 64,
        spawn_y: 352,
        anim: "boss_map"
    },
    {
        name: "CENTRAL HIGHWAY",
        code: "SECTOR 01",
        boss: "MAVERICK SCOUTS",
        danger: "MODERATE (B-RANK)",
        desc: "COLLAPSED HIGHWAY INFRASTRUCTURE. ELIMINATE RECON PATROLS.",
        room_id: rStage_Intro,
        spawn_x: 64,
        spawn_y: 480,
        anim: "normal"
    },
    {
        name: "TRAINING FACILITY",
        code: "SIMULATION ROOM",
        boss: "TARGET DUMMIES",
        danger: "TRAINING (D-RANK)",
        desc: "WEAPONS TESTING GROUND. PRACTICE COMBAT MANEUVERS AND TECHNIQUES.",
        room_id: Room1,
        spawn_x: 64,
        spawn_y: 440,
        anim: "normal"
    },
    {
        name: "BOSS CLASH ARENA",
        code: "DIRECT DUEL",
        boss: "NIGHTMARE ZERO",
        danger: "MAXIMUM (S-RANK)",
        desc: "ISOLATED HIGH-TECH COMBAT CHAMBER FOR DIRECT DUEL.",
        room_id: rBoss_NightmareZero,
        spawn_x: 80,
        spawn_y: 240,
        anim: "boss_map"
    }
];

selected_stage = 0;
stage_count = array_length(stages);
launch_timer = 0;
teleport_beam_alpha = 0.0;
