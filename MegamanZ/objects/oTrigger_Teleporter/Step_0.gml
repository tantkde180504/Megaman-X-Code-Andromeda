/// @desc The Sky exit hands the story over to Zero in the jungle.
if (activated || room != rStage_Sky || destination_room == noone) exit;
if (global.input_locked || !global.stage_ready || instance_exists(obj_sky_jungle_transition)) exit;
if (!instance_exists(oPlayer)) exit;
var _player = instance_find(oPlayer, 0);
if (_player.hp_current <= 0 || !_player.grounded
    || (_player.state != PLAYER_STATE.IDLE && _player.state != PLAYER_STATE.RUN
        && _player.state != PLAYER_STATE.DASH)) exit;
if (abs(_player.x - x) > 18 || abs(_player.y - y) > 24) exit;

activated = true;
_player.hsp = 0;
_player.vsp = 0;
_player.state = PLAYER_STATE.IDLE;
instance_create_layer(0, 0, "Instances", obj_sky_jungle_transition);
