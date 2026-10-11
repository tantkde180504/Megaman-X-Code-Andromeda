Add-Type -AssemblyName System.Drawing

function Create-GMSpriteCustom {
    param (
        [string]$ProjectDir,
        [string]$SpriteName,
        [int]$Width,
        [int]$Height,
        [int]$OriginX = 0,
        [int]$OriginY = 0,
        [scriptblock]$DrawAction
    )

    $frameGuid = [guid]::NewGuid().ToString()
    $layerGuid = [guid]::NewGuid().ToString()
    $keyframeGuid = [guid]::NewGuid().ToString()

    $sprDir = Join-Path $ProjectDir "sprites\$SpriteName"
    $layerDir = Join-Path $sprDir "layers\$frameGuid"
    New-Item -ItemType Directory -Path $layerDir -Force | Out-Null

    $bmp = New-Object System.Drawing.Bitmap($Width, $Height)
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $gfx.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
    $gfx.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor

    & $DrawAction $gfx $Width $Height

    $gfx.Dispose()

    $pngPath1 = Join-Path $sprDir "$frameGuid.png"
    $pngPath2 = Join-Path $sprDir "$SpriteName.png"
    $pngPath3 = Join-Path $layerDir "$layerGuid.png"

    $bmp.Save($pngPath1, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Save($pngPath2, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Save($pngPath3, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()

    $yyContent = @"
{
  "`$GMSprite":"v2",
  "%Name":"$SpriteName",
  "bboxMode":0,
  "bbox_bottom":$($Height - 1),
  "bbox_left":0,
  "bbox_right":$($Width - 1),
  "bbox_top":0,
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
    {"`$GMSpriteFrame":"v1","%Name":"$frameGuid","name":"$frameGuid","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},
  ],
  "gridX":0,
  "gridY":0,
  "height":$Height,
  "HTile":false,
  "layers":[
    {"`$GMImageLayer":"","%Name":"$layerGuid","blendMode":0,"displayName":"default","isLocked":false,"name":"$layerGuid","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,},
  ],
  "name":"$SpriteName",
  "nineSlice":null,
  "origin":0,
  "parent":{
    "name":"Sprites",
    "path":"folders/Sprites.yy",
  },
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{
    "`$GMSequence":"v1",
    "%Name":"$SpriteName",
    "autoRecord":true,
    "backdropHeight":768,
    "backdropImageOpacity":0.5,
    "backdropImagePath":"",
    "backdropWidth":1366,
    "backdropXOffset":0.0,
    "backdropYOffset":0.0,
    "events":{
      "`$KeyframeStore<MessageEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MessageEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "eventStubScript":null,
    "eventToFunction":{},
    "length":1.0,
    "lockOrigin":false,
    "moments":{
      "`$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "name":"$SpriteName",
    "playback":1,
    "playbackSpeed":30.0,
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {"`$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"`$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
            {"`$Keyframe<SpriteFrameKeyframe>":"","Channels":{
                "0":{"`$SpriteFrameKeyframe":"","Id":{"name":"$frameGuid","path":"sprites/$SpriteName/$SpriteName.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},
              },"Disabled":false,"id":"$keyframeGuid","IsCreationKey":false,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},
          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":$OriginX,
    "yorigin":$OriginY,
  },
  "swatchColours":null,
  "swfPrecision":2.525,
  "textureGroupId":{
    "name":"Default",
    "path":"texturegroups/Default",
  },
  "type":0,
  "VTile":false,
  "width":$Width,
}
"@
    Set-Content -Path (Join-Path $sprDir "$SpriteName.yy") -Value $yyContent -Encoding UTF8
}

$proj = "d:\MZ4\MegamanZ"

# 1. sBossGate (16x48 sliding door)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sBossGate" -Width 16 -Height 48 -OriginX 0 -OriginY 0 -DrawAction {
    param($g, $w, $h)
    $b1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(60, 75, 95))
    $b2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 240, 100)) # Green sensor lights
    $p = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(140, 170, 210), 1)
    $g.FillRectangle($b1, 0, 0, $w, $h)
    $g.DrawRectangle($p, 0, 0, $w - 1, $h - 1)
    $g.FillRectangle($b2, 6, 8, 4, 4)
    $g.FillRectangle($b2, 6, 22, 4, 4)
    $g.FillRectangle($b2, 6, 36, 4, 4)
    $b1.Dispose(); $b2.Dispose(); $p.Dispose()
}

# 2. sHeartTank (16x16 red/gold heart)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sHeartTank" -Width 16 -Height 16 -OriginX 8 -OriginY 8 -DrawAction {
    param($g, $w, $h)
    $bGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 215, 0))
    $bRed = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 60))
    $g.FillEllipse($bGold, 1, 1, 14, 14)
    $g.FillEllipse($bRed, 3, 3, 5, 5)
    $g.FillEllipse($bRed, 8, 3, 5, 5)
    $p1 = New-Object System.Drawing.Point(3, 6)
    $p2 = New-Object System.Drawing.Point(13, 6)
    $p3 = New-Object System.Drawing.Point(8, 13)
    [System.Drawing.Point[]]$pts = @($p1, $p2, $p3)
    $g.FillPolygon($bRed, $pts)
    $bGold.Dispose(); $bRed.Dispose()
}

# 3. sSubTank (16x16 cyan energy tank)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sSubTank" -Width 16 -Height 16 -OriginX 8 -OriginY 8 -DrawAction {
    param($g, $w, $h)
    $bMetal = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(120, 140, 160))
    $bCyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 220, 255))
    $g.FillRectangle($bMetal, 3, 1, 10, 14)
    $g.FillRectangle($bCyan, 5, 4, 6, 8)
    $bMetal.Dispose(); $bCyan.Dispose()
}

# 4. sCapsule_Light (32x48 Dr. Light capsule)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sCapsule_Light" -Width 32 -Height 48 -OriginX 16 -OriginY 48 -DrawAction {
    param($g, $w, $h)
    $bBase = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(70, 85, 105))
    $bGlass = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 200, 255))
    $p = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 210, 240), 1)
    $g.FillRectangle($bBase, 2, 40, 28, 8) # Pedestal
    $g.FillRectangle($bBase, 4, 0, 24, 8)  # Top dome
    $g.FillRectangle($bGlass, 6, 8, 20, 32) # Chamber
    $g.DrawRectangle($p, 6, 8, 20, 32)
    $bBase.Dispose(); $bGlass.Dispose(); $p.Dispose()
}

# 5. sPlatform_Falling (32x12 jungle canopy platform)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sPlatform_Falling" -Width 32 -Height 12 -OriginX 0 -OriginY 0 -DrawAction {
    param($g, $w, $h)
    $bGreen = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(45, 140, 60))
    $bWood = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(90, 60, 40))
    $p = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(75, 190, 90), 1)
    $g.FillRectangle($bWood, 0, 4, 32, 8)
    $g.FillRectangle($bGreen, 0, 0, 32, 4)
    $g.DrawRectangle($p, 0, 0, 31, 11)
    $bGreen.Dispose(); $bWood.Dispose(); $p.Dispose()
}

# 6. sIce (16x16 icy surface)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sIce" -Width 16 -Height 16 -OriginX 0 -OriginY 0 -DrawAction {
    param($g, $w, $h)
    $bIce = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(140, 220, 255))
    $p = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(230, 250, 255), 1)
    $g.FillRectangle($bIce, 0, 0, 16, 16)
    $g.DrawRectangle($p, 0, 0, 15, 15)
    $g.DrawLine($p, 2, 4, 13, 4)
    $bIce.Dispose(); $p.Dispose()
}

# 7. sWater (32x32 water surface)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sWater" -Width 32 -Height 32 -OriginX 0 -OriginY 0 -DrawAction {
    param($g, $w, $h)
    $bWater = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 100, 220))
    $p = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 200, 255), 1)
    $g.FillRectangle($bWater, 0, 0, 32, 32)
    $g.DrawLine($p, 0, 2, 31, 2)
    $g.DrawLine($p, 0, 6, 31, 6)
    $bWater.Dispose(); $p.Dispose()
}

# 8. sWebTrap (24x24 spider web mesh)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sWebTrap" -Width 24 -Height 24 -OriginX 12 -OriginY 12 -DrawAction {
    param($g, $w, $h)
    $p = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(240, 240, 240), 1)
    $g.DrawLine($p, 0, 0, 23, 23)
    $g.DrawLine($p, 0, 23, 23, 0)
    $g.DrawLine($p, 12, 0, 12, 23)
    $g.DrawLine($p, 0, 12, 23, 12)
    $g.DrawEllipse($p, 4, 4, 15, 15)
    $g.DrawEllipse($p, 8, 8, 7, 7)
    $p.Dispose()
}

# 9. sTrigger (16x16 checkpoint flag / marker)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sTrigger" -Width 16 -Height 16 -OriginX 0 -OriginY 0 -DrawAction {
    param($g, $w, $h)
    $bFlag = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 220, 120))
    $p = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 1)
    $g.FillRectangle($bFlag, 2, 2, 8, 6)
    $g.DrawLine($p, 2, 2, 2, 14)
    $bFlag.Dispose(); $p.Dispose()
}

# 10. Parallax Backdrops: sBG_Far, sBG_Mid, sBG_Near (480x270)
Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sBG_Far" -Width 480 -Height 270 -OriginX 0 -OriginY 0 -DrawAction {
    param($g, $w, $h)
    $bSky = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(15, 30, 60))
    $bMountain = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(35, 55, 90))
    $g.FillRectangle($bSky, 0, 0, $w, $h)
    $p1 = New-Object System.Drawing.Point(0, 270)
    $p2 = New-Object System.Drawing.Point(80, 140)
    $p3 = New-Object System.Drawing.Point(180, 270)
    $p4 = New-Object System.Drawing.Point(280, 120)
    $p5 = New-Object System.Drawing.Point(400, 270)
    $p6 = New-Object System.Drawing.Point(480, 180)
    $p7 = New-Object System.Drawing.Point(480, 270)
    [System.Drawing.Point[]]$pts = @($p1, $p2, $p3, $p4, $p5, $p6, $p7)
    $g.FillPolygon($bMountain, $pts)
    $bSky.Dispose(); $bMountain.Dispose()
}

Create-GMSpriteCustom -ProjectDir $proj -SpriteName "sBG_Mid" -Width 480 -Height 270 -OriginX 0 -OriginY 0 -DrawAction {
    param($g, $w, $h)
    $bForest = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(25, 75, 50))
    for ($i = 0; $i -lt 480; $i += 40) {
        $g.FillEllipse($bForest, $i - 10, 180, 60, 100)
    }
    $bForest.Dispose()
}

Write-Host "All Phase 2 sprites generated successfully!"
