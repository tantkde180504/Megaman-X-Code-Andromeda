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
    '{"id":{"name":"rStage_Intro","path":"rooms/rStage_Intro/rStage_Intro.yy",},},',
    '{"id":{"name":"rStage_WebSpider","path":"rooms/rStage_WebSpider/rStage_WebSpider.yy",},},',

    # Scripts
    '{"id":{"name":"scr_constants","path":"scripts/scr_constants/scr_constants.yy",},},',
    '{"id":{"name":"scr_input","path":"scripts/scr_input/scr_input.yy",},},',
    '{"id":{"name":"scr_camera","path":"scripts/scr_camera/scr_camera.yy",},},',
    '{"id":{"name":"scr_player_physics","path":"scripts/scr_player_physics/scr_player_physics.yy",},},',
    '{"id":{"name":"scr_player_states","path":"scripts/scr_player_states/scr_player_states.yy",},},',
    '{"id":{"name":"scr_combat","path":"scripts/scr_combat/scr_combat.yy",},},',
    '{"id":{"name":"scr_build_test_room","path":"scripts/scr_build_test_room/scr_build_test_room.yy",},},',
    '{"id":{"name":"scr_build_stage_intro","path":"scripts/scr_build_stage_intro/scr_build_stage_intro.yy",},},',
    '{"id":{"name":"scr_build_stage_web_spider","path":"scripts/scr_build_stage_web_spider/scr_build_stage_web_spider.yy",},},',

    # Sprites
    '{"id":{"name":"sSheet_Goc","path":"sprites/sSheet_Goc/sSheet_Goc.yy",},},',
    '{"id":{"name":"sX_Run","path":"sprites/sX_Run/sX_Run.yy",},},',
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
    '{"id":{"name":"sBossGate","path":"sprites/sBossGate/sBossGate.yy",},},',
    '{"id":{"name":"sHeartTank","path":"sprites/sHeartTank/sHeartTank.yy",},},',
    '{"id":{"name":"sSubTank","path":"sprites/sSubTank/sSubTank.yy",},},',
    '{"id":{"name":"sCapsule_Light","path":"sprites/sCapsule_Light/sCapsule_Light.yy",},},',
    '{"id":{"name":"sPlatform_Falling","path":"sprites/sPlatform_Falling/sPlatform_Falling.yy",},},',
    '{"id":{"name":"sIce","path":"sprites/sIce/sIce.yy",},},',
    '{"id":{"name":"sWater","path":"sprites/sWater/sWater.yy",},},',
    '{"id":{"name":"sWebTrap","path":"sprites/sWebTrap/sWebTrap.yy",},},',
    '{"id":{"name":"sTrigger","path":"sprites/sTrigger/sTrigger.yy",},},',
    '{"id":{"name":"sBG_Far","path":"sprites/sBG_Far/sBG_Far.yy",},},',
    '{"id":{"name":"sBG_Mid","path":"sprites/sBG_Mid/sBG_Mid.yy",},},',

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
    '{"id":{"name":"oPlayerZero","path":"objects/oPlayerZero/oPlayerZero.yy",},},',
    '{"id":{"name":"oTrigger_Checkpoint","path":"objects/oTrigger_Checkpoint/oTrigger_Checkpoint.yy",},},',
    '{"id":{"name":"oTrigger_BossGate","path":"objects/oTrigger_BossGate/oTrigger_BossGate.yy",},},',
    '{"id":{"name":"oPlatform_Falling","path":"objects/oPlatform_Falling/oPlatform_Falling.yy",},},',
    '{"id":{"name":"oIceSurface","path":"objects/oIceSurface/oIceSurface.yy",},},',
    '{"id":{"name":"oWater","path":"objects/oWater/oWater.yy",},},',
    '{"id":{"name":"oWebTrap","path":"objects/oWebTrap/oWebTrap.yy",},},',
    '{"id":{"name":"oPickup_HeartTank","path":"objects/oPickup_HeartTank/oPickup_HeartTank.yy",},},',
    '{"id":{"name":"oPickup_SubTank","path":"objects/oPickup_SubTank/oPickup_SubTank.yy",},},',
    '{"id":{"name":"oCapsule_Light","path":"objects/oCapsule_Light/oCapsule_Light.yy",},},',
    '{"id":{"name":"oParallaxBackground","path":"objects/oParallaxBackground/oParallaxBackground.yy",},}'
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
    {"roomId":{"name":"rStage_Intro","path":"rooms/rStage_Intro/rStage_Intro.yy",},},
    {"roomId":{"name":"rStage_WebSpider","path":"rooms/rStage_WebSpider/rStage_WebSpider.yy",},},
  ],
  "templateType":"game",
  "TextureGroups":[
    {"`$GMTextureGroup":"","%Name":"Default","autocrop":true,"border":2,"compressFormat":"bz2","customOptions":"","directory":"","groupParent":null,"isScaled":true,"loadType":"default","mipsToGenerate":0,"name":"Default","resourceType":"GMTextureGroup","resourceVersion":"2.0","targets":-1,},
  ],
}
"@

Set-Content -Path $yypPath -Value $yypContent -Encoding UTF8
Write-Host "Project manifest updated with sSheet_Goc and sX_Run!"
