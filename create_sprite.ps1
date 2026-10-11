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
        [System.Drawing.Color]$BorderColor
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
    $gfx.FillRectangle($brush, 0, 0, $Width, $Height)
    if ($BorderColor -ne [System.Drawing.Color]::Transparent) {
        $pen = New-Object System.Drawing.Pen($BorderColor, 1)
        $gfx.DrawRectangle($pen, 0, 0, $Width - 1, $Height - 1)
        $pen.Dispose()
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

Create-GMSprite -ProjectDir "d:\MZ4\MegamanZ" -SpriteName "sSolid" -Width 16 -Height 16 -OriginX 0 -OriginY 0 -FillColor ([System.Drawing.Color]::FromArgb(70, 80, 95)) -BorderColor ([System.Drawing.Color]::FromArgb(120, 150, 180))
