Add-Type -AssemblyName System.Drawing

function Create-GMSprite {
    param (
        [string]$ProjectDir,
        [string]$SpriteName,
        [int]$Width,
        [int]$Height,
        [int]$OriginX = 0,
        [int]$OriginY = 0,
        [System.Drawing.Color]$FillColor,
        [System.Drawing.Color]$BorderColor,
        [string]$Pattern = "box"
    )

    $frameGuid = [guid]::NewGuid().ToString()
    $layerGuid = [guid]::NewGuid().ToString()
    $keyframeGuid = [guid]::NewGuid().ToString()

    $sprDir = Join-Path $ProjectDir "sprites\$SpriteName"
    $layerDir = Join-Path $sprDir "layers\$frameGuid"
    New-Item -ItemType Directory -Path $layerDir -Force | Out-Null

    # Generate Image
    $bmp = New-Object System.Drawing.Bitmap($Width, $Height)
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $brush = New-Object System.Drawing.SolidBrush($FillColor)

    if ($Pattern -eq "box") {
        $gfx.FillRectangle($brush, 0, 0, $Width, $Height)
        if ($BorderColor -ne [System.Drawing.Color]::Transparent) {
            $pen = New-Object System.Drawing.Pen($BorderColor, 1)
            $gfx.DrawRectangle($pen, 0, 0, $Width - 1, $Height - 1)
            $pen.Dispose()
        }
    } elseif ($Pattern -eq "platform") {
        $gfx.FillRectangle($brush, 0, 0, $Width, 4)
        $pen = New-Object System.Drawing.Pen($BorderColor, 1)
        $gfx.DrawLine($pen, 0, 0, $Width - 1, 0)
        $pen.Dispose()
    } elseif ($Pattern -eq "spike") {
        $p1 = New-Object System.Drawing.Point(0, [int]($Height - 1))
        $p2 = New-Object System.Drawing.Point([int]($Width / 2), 0)
        $p3 = New-Object System.Drawing.Point([int]($Width - 1), [int]($Height - 1))
        [System.Drawing.Point[]]$points = @($p1, $p2, $p3)
        $gfx.FillPolygon($brush, $points)
        $pen = New-Object System.Drawing.Pen($BorderColor, 1)
        $gfx.DrawPolygon($pen, $points)
        $pen.Dispose()
    } elseif ($Pattern -eq "ladder") {
        $pen = New-Object System.Drawing.Pen($BorderColor, 2)
        $gfx.DrawLine($pen, 2, 0, 2, $Height - 1)
        $gfx.DrawLine($pen, $Width - 3, 0, $Width - 3, $Height - 1)
        $gfx.DrawLine($pen, 2, [int]($Height / 4), $Width - 3, [int]($Height / 4))
        $gfx.DrawLine($pen, 2, [int]($Height * 3 / 4), $Width - 3, [int]($Height * 3 / 4))
        $pen.Dispose()
    } elseif ($Pattern -eq "circle") {
        $gfx.FillEllipse($brush, 0, 0, $Width - 1, $Height - 1)
        if ($BorderColor -ne [System.Drawing.Color]::Transparent) {
            $pen = New-Object System.Drawing.Pen($BorderColor, 1)
            $gfx.DrawEllipse($pen, 0, 0, $Width - 1, $Height - 1)
            $pen.Dispose()
        }
    } elseif ($Pattern -eq "target") {
        $gfx.FillRectangle($brush, 0, 0, $Width, $Height)
        $pen = New-Object System.Drawing.Pen($BorderColor, 1)
        $gfx.DrawRectangle($pen, 0, 0, $Width - 1, $Height - 1)
        $pen2 = New-Object System.Drawing.Pen([System.Drawing.Color]::Yellow, 1)
        $gfx.DrawLine($pen2, 0, [int]($Height/2), $Width-1, [int]($Height/2))
        $gfx.DrawLine($pen2, [int]($Width/2), 0, [int]($Width/2), $Height-1)
        $pen.Dispose()
        $pen2.Dispose()
    }
    $brush.Dispose()
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

Create-GMSprite -ProjectDir $proj -SpriteName "sSolid" -Width 16 -Height 16 -OriginX 0 -OriginY 0 -FillColor ([System.Drawing.Color]::FromArgb(60, 70, 85)) -BorderColor ([System.Drawing.Color]::FromArgb(120, 150, 180)) -Pattern "box"
Create-GMSprite -ProjectDir $proj -SpriteName "sOneWayPlatform" -Width 16 -Height 8 -OriginX 0 -OriginY 0 -FillColor ([System.Drawing.Color]::FromArgb(80, 100, 120)) -BorderColor ([System.Drawing.Color]::FromArgb(240, 200, 50)) -Pattern "platform"
Create-GMSprite -ProjectDir $proj -SpriteName "sHazardSpike" -Width 16 -Height 16 -OriginX 0 -OriginY 0 -FillColor ([System.Drawing.Color]::FromArgb(220, 40, 40)) -BorderColor ([System.Drawing.Color]::FromArgb(255, 230, 230)) -Pattern "spike"
Create-GMSprite -ProjectDir $proj -SpriteName "sLadder" -Width 16 -Height 16 -OriginX 0 -OriginY 0 -FillColor ([System.Drawing.Color]::Transparent) -BorderColor ([System.Drawing.Color]::FromArgb(100, 160, 220)) -Pattern "ladder"
Create-GMSprite -ProjectDir $proj -SpriteName "sPlayerMask" -Width 18 -Height 32 -OriginX 9 -OriginY 32 -FillColor ([System.Drawing.Color]::FromArgb(0, 180, 255)) -BorderColor ([System.Drawing.Color]::FromArgb(255, 255, 255)) -Pattern "box"
Create-GMSprite -ProjectDir $proj -SpriteName "sBullet_Buster" -Width 8 -Height 6 -OriginX 4 -OriginY 3 -FillColor ([System.Drawing.Color]::FromArgb(255, 240, 50)) -BorderColor ([System.Drawing.Color]::FromArgb(255, 160, 0)) -Pattern "circle"
Create-GMSprite -ProjectDir $proj -SpriteName "sBullet_SemiCharge" -Width 16 -Height 12 -OriginX 8 -OriginY 6 -FillColor ([System.Drawing.Color]::FromArgb(80, 255, 120)) -BorderColor ([System.Drawing.Color]::FromArgb(255, 255, 255)) -Pattern "circle"
Create-GMSprite -ProjectDir $proj -SpriteName "sBullet_FullCharge" -Width 30 -Height 20 -OriginX 15 -OriginY 10 -FillColor ([System.Drawing.Color]::FromArgb(40, 190, 255)) -BorderColor ([System.Drawing.Color]::FromArgb(255, 100, 240)) -Pattern "circle"
Create-GMSprite -ProjectDir $proj -SpriteName "sSaberHitbox" -Width 44 -Height 36 -OriginX 10 -OriginY 18 -FillColor ([System.Drawing.Color]::FromArgb(40, 255, 120)) -BorderColor ([System.Drawing.Color]::FromArgb(255, 255, 255)) -Pattern "circle"
Create-GMSprite -ProjectDir $proj -SpriteName "sTargetDummy" -Width 20 -Height 36 -OriginX 10 -OriginY 36 -FillColor ([System.Drawing.Color]::FromArgb(180, 60, 60)) -BorderColor ([System.Drawing.Color]::FromArgb(255, 200, 200)) -Pattern "target"
Create-GMSprite -ProjectDir $proj -SpriteName "sFX_DashDust" -Width 16 -Height 16 -OriginX 8 -OriginY 16 -FillColor ([System.Drawing.Color]::FromArgb(200, 230, 255)) -BorderColor ([System.Drawing.Color]::Transparent) -Pattern "circle"
Create-GMSprite -ProjectDir $proj -SpriteName "sFX_HitSpark" -Width 16 -Height 16 -OriginX 8 -OriginY 8 -FillColor ([System.Drawing.Color]::FromArgb(255, 255, 180)) -BorderColor ([System.Drawing.Color]::FromArgb(255, 180, 0)) -Pattern "circle"

Write-Host "All 12 sprites generated cleanly!"
