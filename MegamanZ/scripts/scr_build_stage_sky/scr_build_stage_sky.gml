/// @desc Sky entry setup. Artwork and collisions live in rStage_Sky.
function scr_build_stage_sky() {
    // No boss in this stage. The exit continues the story as Zero in the jungle.
    music_stop_all();
    if (instance_exists(oEnemyParent)) return;

    // Teach one ground enemy after the empty opening screen, then add air threats.
    // Checkpoint landings remain clear on both sides.
    var _encounters = [
        [480, 1152, oEnemy_MettaurD2],
        [800, 1128, oEnemy_MettaurD2],
        [1040, 960, oEnemy_TonboroidS],

        // Stepped road and truck: leave traversal space between encounters.
        [1520, 1104, oEnemy_KnotBeretG],
        [1744, 1030, oEnemy_TonboroidS],
        [1960, 1104, oEnemy_SpikyMKII],
        [2312, 940, oEnemy_Guardian],

        // Tunnel: alternate ceiling and floor threats before the save screen.
        [2720, 1024, oEnemy_Batton],
        [2960, 1152, oEnemy_MettaurD2],
        [3200, 1152, oEnemy_KnotBeretB],

        // Bridge checkpoint and statue ladder landing are resting spots.
        [3900, 940, oEnemy_TentoroidRS],
        [4330, 720, oEnemy_Batton],
        [4330, 480, oEnemy_TentoroidRS]
    ];
    for (var _i = 0; _i < array_length(_encounters); _i++) {
        var _encounter = _encounters[_i];
        instance_create_layer(_encounter[0], _encounter[1], "Instances", _encounter[2]);
    }
}
