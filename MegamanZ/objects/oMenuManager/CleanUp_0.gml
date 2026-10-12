// Clean up any dynamically allocated memory if needed
if (variable_instance_exists(id, "dialogue_font") && font_exists(dialogue_font)) {
    font_delete(dialogue_font);
}
