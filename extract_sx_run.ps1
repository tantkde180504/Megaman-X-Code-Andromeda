Add-Type -AssemblyName System.Drawing

$srcPath = "d:\MZ4\MegamanZ\sprites\sSheet_Goc\d39637a4-0e02-4a7e-961d-6aa3225312b5.png"
$srcBmp = New-Object System.Drawing.Bitmap($srcPath)

$sprName = "sX_Run"
$outDir = "d:\MZ4\MegamanZ\sprites\$sprName"
$layerSubDir = Join-Path $outDir "layers"
if (Test-Path $outDir) { Remove-Item -Recurse -Force $outDir }
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

$canvasW = 56
$canvasH = 52
$originX = 28
$originY = 50

# 16 frame bounding boxes: [left, right, top, bottom, base_y]
$framesData = @(
    # Row 7 (8 frames)
    @(114, 146, 427, 473, 473),
    @(153, 183, 427, 473, 473),
    @(191, 222, 427, 473, 473),
    @(230, 269, 427, 473, 473),
    @(275, 322, 427, 473, 473),
    @(329, 376, 427, 473, 473),
    @(384, 422, 427, 473, 473),
    @(433, 462, 427, 473, 473),
    # Row 8 (8 frames)
    @(119, 145, 483, 529, 529),
    @(155, 189, 483, 529, 529),
    @(196, 235, 483, 529, 529),
    @(240, 281, 483, 529, 529),
    @(291, 332, 483, 529, 529),
    @(340, 377, 483, 529, 529),
    @(388, 419, 483, 529, 529),
    @(427, 453, 483, 529, 529)
)

$frameGuids = @()
$layerGuids = @()
$keyframeGuids = @()

for ($i = 0; $i -lt 16; $i++) {
    $fg = [guid]::NewGuid().ToString()
    $lg = [guid]::NewGuid().ToString()
    $kg = [guid]::NewGuid().ToString()
    $frameGuids += $fg
    $layerGuids += $lg
    $keyframeGuids += $kg

    $fd = $framesData[$i]
    $bLeft = $fd[0]; $bRight = $fd[1]; $bTop = $fd[2]; $bBottom = $fd[3]; $baseY = $fd[4]

    # Find exact sub-bounds of non-transparent pixels in this box
    $minX = 9999; $maxX = -1; $minY = 9999; $maxY = -1
    for ($x = $bLeft; $x -le $bRight; $x++) {
        for ($y = $bTop; $y -le $bBottom; $y++) {
            $p = $srcBmp.GetPixel($x, $y)
            if ($p.A -gt 10) {
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }

    $subW = $maxX - $minX + 1
    $subH = $maxY - $minY + 1

    # Create canvas
    $dstBmp = New-Object System.Drawing.Bitmap($canvasW, $canvasH)
    $dstGfx = [System.Drawing.Graphics]::FromImage($dstBmp)
    $dstGfx.Clear([System.Drawing.Color]::Transparent)

    $destX = [int](($canvasW - $subW) / 2)
    # Align to baseline
    $destY = $originY - ($baseY - $minY)

    for ($sx = 0; $sx -lt $subW; $sx++) {
        for ($sy = 0; $sy -lt $subH; $sy++) {
            $px = $srcBmp.GetPixel($minX + $sx, $minY + $sy)
            if ($px.A -gt 10) {
                $targetX = $destX + $sx
                $targetY = $destY + $sy
                if ($targetX -ge 0 -and $targetX -lt $canvasW -and $targetY -ge 0 -and $targetY -lt $canvasH) {
                    $dstBmp.SetPixel($targetX, $targetY, $px)
                }
            }
        }
    }
    $dstGfx.Dispose()

    # Save frame PNG
    $fPng = Join-Path $outDir "$fg.png"
    $dstBmp.Save($fPng, [System.Drawing.Imaging.ImageFormat]::Png)

    # If first frame, save composite sX_Run.png
    if ($i -eq 0) {
        $compPng = Join-Path $outDir "$sprName.png"
        $dstBmp.Save($compPng, [System.Drawing.Imaging.ImageFormat]::Png)
    }

    # Save layer PNG
    $layerDir = Join-Path $layerSubDir "$fg"
    New-Item -ItemType Directory -Path $layerDir -Force | Out-Null
    $lPng = Join-Path $layerDir "$lg.png"
    $dstBmp.Save($lPng, [System.Drawing.Imaging.ImageFormat]::Png)

    $dstBmp.Dispose()
    Write-Host "Processed Frame $($i + 1): subW=$subW, subH=$subH -> saved to $fg.png"
}

$srcBmp.Dispose()

# Now build sX_Run.yy
$framesJson = @()
$keyframesJson = @()

for ($i = 0; $i -lt 16; $i++) {
    $fg = $frameGuids[$i]
    $kg = $keyframeGuids[$i]
    $framesJson += @"
    {"`$GMSpriteFrame":"v1","%Name":"$fg","name":"$fg","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},
"@

    $keyframesJson += @"
            {"`$Keyframe<SpriteFrameKeyframe>":"","Channels":{
                "0":{"`$SpriteFrameKeyframe":"","Id":{"name":"$fg","path":"sprites/$sprName/$sprName.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},
              },"Disabled":false,"id":"$kg","IsCreationKey":false,"Key":$($i).0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},
"@
}

$framesStr = $framesJson -join "`n"
$keyframesStr = $keyframesJson -join "`n"
$firstLayerGuid = $layerGuids[0]

$yyContent = @"
{
  "`$GMSprite":"v2",
  "%Name":"$sprName",
  "bboxMode":0,
  "bbox_bottom":$($canvasH - 1),
  "bbox_left":0,
  "bbox_right":$($canvasW - 1),
  "bbox_top":0,
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
$framesStr
  ],
  "gridX":0,
  "gridY":0,
  "height":$canvasH,
  "HTile":false,
  "layers":[
    {"`$GMImageLayer":"","%Name":"$firstLayerGuid","blendMode":0,"displayName":"default","isLocked":false,"name":"$firstLayerGuid","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,},
  ],
  "name":"$sprName",
  "nineSlice":null,
  "origin":7,
  "parent":{
    "name":"Sprites",
    "path":"folders/Sprites.yy",
  },
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{
    "`$GMSequence":"v1",
    "%Name":"$sprName",
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
    "length":16.0,
    "lockOrigin":false,
    "moments":{
      "`$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "name":"$sprName",
    "playback":1,
    "playbackSpeed":16.0,
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {"`$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"`$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
$keyframesStr
          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":$originX,
    "yorigin":$originY,
  },
  "swatchColours":null,
  "swfPrecision":0.5,
  "textureGroupId":{
    "name":"Default",
    "path":"texturegroups/Default",
  },
  "type":0,
  "VTile":false,
  "width":$canvasW,
}
"@

Set-Content -Path (Join-Path $outDir "$sprName.yy") -Value $yyContent -Encoding UTF8
Write-Host "Successfully generated $sprName with 16 frames and valid yy manifest!"
