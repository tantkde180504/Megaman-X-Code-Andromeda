// Menu States
enum MENU_STATE {
    SPLASH,         // Capcom tribute & Fanmade splash intro
    TITLE,          // Main Title screen with Press Start
    MAIN_MENU,      // Game Start, How to Play, Credits, Exit
    HOW_TO_PLAY,    // Controls guide modal
    CREDITS,        // Credits modal
    CHAR_SELECT,    // Mega Man X vs Zero Character Select
    CUTSCENE,       // MMX5-style Story Cutscene & Mission Briefing
    TRANSITION_OUT  // Fade out into rStage_Intro
}

state = MENU_STATE.SPLASH;
state_timer = 0;
fade_alpha = 1.0;
flash_alpha = 0.0;
anim_timer = 0;

// Starfield particles (Deep Space Parallax)
star_count = 65;
stars = array_create(star_count);
for (var i = 0; i < star_count; i++) {
    stars[i] = {
        x: irandom(VIEW_WIDTH),
        y: irandom(VIEW_HEIGHT),
        spd: random_range(0.3, 1.8),
        alpha: random_range(0.3, 0.9),
        size: choose(1, 1, 1, 2)
    };
}

// Cyber grid perspective line offset
grid_offset = 0.0;

// Main Menu data
menu_options = ["GAME START", "HOW TO PLAY", "CREDITS", "EXIT GAME"];
menu_index = 0;
menu_count = array_length(menu_options);

// Character Select data (0: X, 1: Zero)
selected_char = 0;
char_anim_frame = 0.0;
char_confirmed = false;
char_confirm_timer = 0;

// Cutscene Data & Typewriter Engine (Mega Man X4 Post-Character Select Cutscene)
cutscene_step = 0;
cutscene_char_idx = 0.0;
cutscene_text = "";
cutscene_target_text = "";
cutscene_speaker_name = "";
cutscene_speaker_key = ""; // "hero", "alia", or ""
cutscene_is_typing = false;
cutscene_type_speed = 0.8; // Authentic typewriter cadence
cutscene_scanline = 0;

// Cutscene Steps Script (English Localized - Mega Man X4 Authentic Style):
// Phase 1: Prologue Lore (No mugshots, narrative text in lower box)
// Phase 2: Character Dialogue (Hero on left, Alia on right, animated talking mouths)
cutscene_script = [
    // Step 0: Prologue Title
    {
        is_dialogue: false,
        speaker_key: "",
        speaker_name: "",
        text: "2126: MEGAMAN X CODE: ANDROMEDA"
    },
    // Step 1: Prologue Lore
    {
        is_dialogue: false,
        speaker_key: "",
        speaker_name: "",
        text: "Following the fierce battles against Sigma, [HERO] continues the perilous duty of a Maverick Hunter, purging rogue Reploids infected by the Maverick virus and wiping out the remnants of Sigma's forces."
    },
    // Step 2: Alia calls Hero
    {
        is_dialogue: true,
        speaker_key: "alia",
        speaker_name: "ALIA",
        text: "[HERO]! [HERO]! Can you hear me?"
    },
    // Step 3: Hero responds
    {
        is_dialogue: true,
        speaker_key: "hero",
        speaker_name: "[CHAR_NAME]",
        text: "Loud and clear. What's the situation, Alia?"
    },
    // Step 4: Alia briefs about Jungle
    {
        is_dialogue: true,
        speaker_key: "alia",
        speaker_name: "ALIA",
        text: "A contingent of Reploids in the Jungle Sector has gone completely berserk. Head to the area and investigate at once!"
    },
    // Step 5: Hero acknowledges
    {
        is_dialogue: true,
        speaker_key: "hero",
        speaker_name: "[CHAR_NAME]",
        text: "Understood! On my way."
    },
    // Step 6: Alia warns of mysterious signal
    {
        is_dialogue: true,
        speaker_key: "alia",
        speaker_name: "ALIA",
        text: "Wait--sensors are detecting an anomalous energy signature deep within the jungle core. After neutralizing the hostile Reploids, trace that signal. It may be the catalyst driving them mad."
    },
    // Step 7: Hero departs
    {
        is_dialogue: true,
        speaker_key: "hero",
        speaker_name: "[CHAR_NAME]",
        text: "Roger that, Alia. I'm moving out now!"
    }
];
cutscene_step_count = array_length(cutscene_script);
title_intro_input_cooldown = 0;
if (room == rTitle && !instance_exists(obj_title_intro)) {
    instance_create_layer(0, 0, "Instances", obj_title_intro);
}
