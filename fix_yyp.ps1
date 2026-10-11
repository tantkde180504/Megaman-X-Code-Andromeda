$yypPath = "d:\MZ4\MegamanZ\MegamanZ.yyp"

$folders = @(
    '{"$GMFolder":"","%Name":"Core","folderPath":"folders/Objects/Core.yy","name":"Core","resourceType":"GMFolder","resourceVersion":"2.0",},',
    '{"$GMFolder":"","%Name":"Effects","folderPath":"folders/Objects/Effects.yy","name":"Effects","resourceType":"GMFolder","resourceVersion":"2.0",},',
    '{"$GMFolder":"","%Name":"Environment","folderPath":"folders/Objects/Environment.yy","name":"Environment","resourceType":"GMFolder","resourceVersion":"2.0",},',
    '{"$GMFolder":"","%Name":"Objects","folderPath":"folders/Objects.yy","name":"Objects","resourceType":"GMFolder","resourceVersion":"2.0",},',
    '{"$GMFolder":"","%Name":"Player","folderPath":"folders/Objects/Player.yy","name":"Player","resourceType":"GMFolder","resourceVersion":"2.0",},',
    '{"$GMFolder":"","%Name":"Rooms","folderPath":"folders/Rooms.yy","name":"Rooms","resourceType":"GMFolder","resourceVersion":"2.0",},',
    '{"$GMFolder":"","%Name":"Scripts","folderPath":"folders/Scripts.yy","name":"Scripts","resourceType":"GMFolder","resourceVersion":"2.0",},',
    '{"$GMFolder":"","%Name":"Sprites","folderPath":"folders/Sprites.yy","name":"Sprites","resourceType":"GMFolder","resourceVersion":"2.0",},',
    '{"$GMFolder":"","%Name":"UI","folderPath":"folders/Objects/UI.yy","name":"UI","resourceType":"GMFolder","resourceVersion":"2.0",},',
    '{"$GMFolder":"","%Name":"Weapons","folderPath":"folders/Objects/Weapons.yy","name":"Weapons","resourceType":"GMFolder","resourceVersion":"2.0",},'
)

$resources = @(
    # Rooms
    '{"id":{"name":"Room1","path":"rooms/Room1/Room1.yy",},},',

    # Scripts
    '{"id":{"name":"scr_constants","path":"scripts/scr_constants/scr_constants.yy",},},',
    '{"id":{"name":"scr_input","path":"scripts/scr_input/scr_input.yy",},},',
    '{"id":{"name":"scr_camera","path":"scripts/scr_camera/scr_camera.yy",},},',
    '{"id":{"name":"scr_player_physics","path":"scripts/scr_player_physics/scr_player_physics.yy",},},',
    '{"id":{"name":"scr_player_states","path":"scripts/scr_player_states/scr_player_states.yy",},},',
    '{"id":{"name":"scr_combat","path":"scripts/scr_combat/scr_combat.yy",},},',
    '{"id":{"name":"scr_build_test_room","path":"scripts/scr_build_test_room/scr_build_test_room.yy",},},',

    # Sprites
    '{"id":{"name":"sSolid","path":"sprites/sSolid/sSolid.yy",},},',
    '{"id":{"name":"sOneWayPlatform","path":"sprites/sOneWayPlatform/sOneWayPlatform.yy",},},',
    '{"id":{"name":"sHazardSpike","path":"sprites/sHazardSpike/sHazardSpike.yy",},},',
    '{"id":{"name":"sLadder","path":"sprites/sLadder/sLadder.yy",},},',
    '{"id":{"name":"sPlayerMask","path":"sprites/sPlayerMask/sPlayerMask.yy",},},',
    '{"id":{"name":"sBullet_Buster","path":"sprites/sBullet_Buster/sBullet_Buster.yy",},},',
    '{"id":{"name":"sBullet_SemiCharge","path":"sprites/sBullet_SemiCharge/sBullet_SemiCharge.yy",},},',
    '{"id":{"name":"sBullet_FullCharge","path":"sprites/sBullet_FullCharge/sBullet_FullCharge.yy",},},',
    '{"id":{"name":"sSaberHitbox","path":"sprites/sSaberHitbox/sSaberHitbox.yy",},},',
    '{"id":{"name":"sTargetDummy","path":"sprites/sTargetDummy/sTargetDummy.yy",},},',
    '{"id":{"name":"sFX_DashDust","path":"sprites/sFX_DashDust/sFX_DashDust.yy",},},',
    '{"id":{"name":"sFX_HitSpark","path":"sprites/sFX_HitSpark/sFX_HitSpark.yy",},},',

    # Objects
    '{"id":{"name":"oGame","path":"objects/oGame/oGame.yy",},},',
    '{"id":{"name":"oInput","path":"objects/oInput/oInput.yy",},},',
    '{"id":{"name":"oCamera","path":"objects/oCamera/oCamera.yy",},},',
    '{"id":{"name":"oUI_HUD","path":"objects/oUI_HUD/oUI_HUD.yy",},},',
    '{"id":{"name":"oSolid","path":"objects/oSolid/oSolid.yy",},},',
    '{"id":{"name":"oOneWayPlatform","path":"objects/oOneWayPlatform/oOneWayPlatform.yy",},},',
    '{"id":{"name":"oHazardSpike","path":"objects/oHazardSpike/oHazardSpike.yy",},},',
    '{"id":{"name":"oLadder","path":"objects/oLadder/oLadder.yy",},},',
    '{"id":{"name":"oTargetDummy","path":"objects/oTargetDummy/oTargetDummy.yy",},},',
    '{"id":{"name":"oFX_DashDust","path":"objects/oFX_DashDust/oFX_DashDust.yy",},},',
    '{"id":{"name":"oFX_HitSpark","path":"objects/oFX_HitSpark/oFX_HitSpark.yy",},},',
    '{"id":{"name":"oBullet_Buster","path":"objects/oBullet_Buster/oBullet_Buster.yy",},},',
    '{"id":{"name":"oBullet_SemiCharge","path":"objects/oBullet_SemiCharge/oBullet_SemiCharge.yy",},},',
    '{"id":{"name":"oBullet_FullCharge","path":"objects/oBullet_FullCharge/oBullet_FullCharge.yy",},},',
    '{"id":{"name":"oSaberHitbox","path":"objects/oSaberHitbox/oSaberHitbox.yy",},},',
    '{"id":{"name":"oPlayer","path":"objects/oPlayer/oPlayer.yy",},},',
    '{"id":{"name":"oPlayerX","path":"objects/oPlayerX/oPlayerX.yy",},},',
    '{"id":{"name":"oPlayerZero","path":"objects/oPlayerZero/oPlayerZero.yy",},}'
)

$foldersStr = ($folders -join "`n    ") + "`n  "
$resourcesStr = ($resources -join "`n    ") + "`n  "

$yypContent = @"
{
  "`$GMProject":"v1",
  "%Name":"MegamanZ",
  "AudioGroups":[
    {"`$GMAudioGroup":"v1","%Name":"audiogroup_default","exportDir":"","name":"audiogroup_default","resourceType":"GMAudioGroup","resourceVersion":"2.0","targets":-1,},
  ],
  "configs":{
    "children":[],
    "name":"Default",
  },
  "defaultScriptType":0,
  "Folders":[
    $foldersStr],
  "ForcedPrefabProjectReferences":[],
  "IncludedFiles":[],
  "isEcma":false,
  "LibraryEmitters":[],
  "MetaData":{
    "IDEVersion":"2026.0.0.16",
  },
  "name":"MegamanZ",
  "resources":[
    $resourcesStr],
  "resourceType":"GMProject",
  "resourceVersion":"2.0",
  "RoomOrderNodes":[
    {"roomId":{"name":"Room1","path":"rooms/Room1/Room1.yy",},},
  ],
  "templateType":"game",
  "TextureGroups":[
    {"`$GMTextureGroup":"","%Name":"Default","autocrop":true,"border":2,"compressFormat":"bz2","customOptions":"","directory":"","groupParent":null,"isScaled":true,"loadType":"default","mipsToGenerate":0,"name":"Default","resourceType":"GMTextureGroup","resourceVersion":"2.0","targets":-1,},
  ],
}
"@

Set-Content -Path $yypPath -Value $yypContent -Encoding UTF8
Write-Host "MegamanZ.yyp rewritten with valid commas."
