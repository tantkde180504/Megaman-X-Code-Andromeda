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

// Dynamic dialogue font for Vietnamese diacritics support
dialogue_font = -1;
try {
    dialogue_font = font_add("Segoe UI", 10, true, false, 32, 8000);
} catch (_ex) {
    dialogue_font = -1;
}

// Cutscene Steps Script:
// Phase 1: Prologue Lore (No mugshots, text at bottom)
// Phase 2: Character Dialogue (Hero on left, Alia on right, animated mouths while typing)
cutscene_script = [
    // Step 0: Prologue Title
    {
        is_dialogue: false,
        speaker_key: "",
        speaker_name: "",
        text: "2126: MegaMan X Code: Andromeda"
    },
    // Step 1: Prologue Lore
    {
        is_dialogue: false,
        speaker_key: "",
        speaker_name: "",
        text: "Sau cuộc chiến với Sigma, [HERO] tiếp tục trên hành trình của một Maverick Hunter, tiêu diệt những Reploid nhiễm virus Maverick và tàn dư của Sigma."
    },
    // Step 2: Alia calls Hero
    {
        is_dialogue: true,
        speaker_key: "alia",
        speaker_name: "ALIA",
        text: "[HERO]..[HERO]..nghe thấy tôi nói không?"
    },
    // Step 3: Hero responds
    {
        is_dialogue: true,
        speaker_key: "hero",
        speaker_name: "[CHAR_NAME]",
        text: "Tôi nghe, có chuyện gì vậy Alia?"
    },
    // Step 4: Alia briefs about Jungle
    {
        is_dialogue: true,
        speaker_key: "alia",
        speaker_name: "ALIA",
        text: "Ở khu vực jungle đang có một nhóm Reploid bị mất kiểm soát, hãy tới đó kiểm tra."
    },
    // Step 5: Hero acknowledges
    {
        is_dialogue: true,
        speaker_key: "hero",
        speaker_name: "[CHAR_NAME]",
        text: "Đã rõ!"
    },
    // Step 6: Alia warns of mysterious signal
    {
        is_dialogue: true,
        speaker_key: "alia",
        speaker_name: "ALIA",
        text: "Tuy nhiên ở sâu trong khu vực phát hiện tính hiệu lạ, sau khi kiểm soát đám Reploid, hãy tìm kiếm tính hiệu đó. Có thể nó là lý do đám Reploid có hành động lạ."
    },
    // Step 7: Hero departs
    {
        is_dialogue: true,
        speaker_key: "hero",
        speaker_name: "[CHAR_NAME]",
        text: "Đã rõ, tôi sẽ đi ngay!"
    }
];
cutscene_step_count = array_length(cutscene_script);
