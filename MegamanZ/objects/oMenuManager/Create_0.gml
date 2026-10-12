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

// Cutscene data (MMX5 Typewriter Engine)
cutscene_page = 0;
cutscene_text = "";
cutscene_target_text = "";
cutscene_char_idx = 0;
cutscene_type_speed = 0.9;
cutscene_timer = 0;
cutscene_scanline = 0;
cutscene_speaker = "OPERATOR // HUNTER BASE";

// Story Pages Script (Context & Mission Briefing)
story_pages = [
    // Page 0: Background Context
    "YEAR 21XX...\n\nFollowing countless fierce battles against Maverick uprisings, Earth has achieved a temporary era of peace.\n\nHowever, a catastrophic surge of ancient cosmic energy designated 'CODE ANDROMEDA' has suddenly erupted within the Frontier Orbital Defense Satellite!\n\nA virulent Maverick virus has seized total control of the security grid, turning thousands of automated defense units into a rogue army threatening to bombard Earth!",
    
    // Page 1: Emergency Transmission
    "CRITICAL DISPATCH // HUNTER BASE COMMAND:\n\nScout Squad 17 has ceased all transmissions immediately upon entering the orbital skyway sector.\n\nAutomated defense siege cannons are aligning their targeting coordinates toward planetary population centers. Time is rapidly running out before catastrophic bombardment!\n\nThe Maverick Hunters have mobilized. Our elite vanguard must deploy immediately!",
    
    // Page 2: Mission Briefing
    "MISSION DIRECTIVE: [ORBITAL HIGHWAY INFILTRATION]\n\n* DEPLOYED HUNTER: [CHAR_NAME]\n* PRIMARY OBJECTIVE: Penetrate the Ruined Skyway defense perimeter, neutralize all rogue mechaniloids, and reach the gateway to the Andromeda core!\n\nWarp Beam coordinates locked...\nDeploy immediately, Hunter!"
];
