# Extract the six tired idle poses without changing their original pixels.
# Run from any directory; writes only sX_LowHealth (never removes a directory).
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$project = Join-Path $PSScriptRoot '../MegamanZ'
$destination = Join-Path $project 'sprites/sX_LowHealth'
$source = Join-Path $project 'sprites/sSheet_Goc/d39637a4-0e02-4a7e-961d-6aa3225312b5.png'
$template = Get-Content (Join-Path $project 'sprites/sX_Idle/sX_Idle.yy') -Raw
$sprite = ($template -replace ',\s*([}\]])', '$1') | ConvertFrom-Json
$name = 'sX_LowHealth'
$sprite.'%Name' = $name
$sprite.name = $name
$sprite.sequence.'%Name' = $name
$sprite.sequence.name = $name
$sprite.sequence.length = 6.0
$sprite.sequence.playbackSpeed = 6.0
$sprite.bbox_left = 12
$sprite.bbox_right = 44
$sprite.bbox_top = 5
$sprite.bbox_bottom = 50
$layer = $sprite.layers[0].name
# Preserve IDs on regeneration so GameMaker references remain stable.
$ids = 0..5 | ForEach-Object { "10d69c1e-4374-4e52-a1b1-ec93a357000$_" }
$columns = @(@(262,294), @(302,334), @(343,375), @(383,415), @(422,454), @(460,492))
$frameTemplate = $sprite.frames[0] | ConvertTo-Json -Depth 30 -Compress
$keyTemplate = $sprite.sequence.tracks[0].keyframes.Keyframes[0] | ConvertTo-Json -Depth 30 -Compress
$frames = @()
$keys = @()
$sheet = [System.Drawing.Bitmap]::FromFile($source)
New-Item -ItemType Directory -Force -Path $destination | Out-Null
try {
    for ($i = 0; $i -lt 6; $i++) {
        $frame = $frameTemplate | ConvertFrom-Json
        $frame.'%Name' = $ids[$i]
        $frame.name = $ids[$i]
        $frames += $frame
        $key = $keyTemplate | ConvertFrom-Json
        $key.id = "15ca11d2-9548-49b0-b5a2-46c23cba000$i"
        $key.Key = [double]$i
        $key.Channels.'0'.Id.name = $ids[$i]
        $key.Channels.'0'.Id.path = "sprites/$name/$name.yy"
        $keys += $key
        $canvas = New-Object System.Drawing.Bitmap 56,52
        try {
            # All poses share source baseline 1302; align it to Idle's y=50.
            # Copy one pixel at a time to avoid interpolation or alpha blending.
            for ($sx = $columns[$i][0]; $sx -le $columns[$i][1]; $sx++) {
                for ($sy = 1257; $sy -le 1302; $sy++) {
                    $canvas.SetPixel(12 + $sx - $columns[$i][0], 5 + $sy - 1257, $sheet.GetPixel($sx,$sy))
                }
            }
            $canvas.Save((Join-Path $destination "$($ids[$i]).png"))
            $layerDir = Join-Path $destination "layers/$($ids[$i])"
            New-Item -ItemType Directory -Force -Path $layerDir | Out-Null
            $canvas.Save((Join-Path $layerDir "$layer.png"))
        } finally { $canvas.Dispose() }
    }
} finally { $sheet.Dispose() }
$sprite.frames = $frames
$sprite.sequence.tracks[0].keyframes.Keyframes = $keys
$json = $sprite | ConvertTo-Json -Depth 50
[System.IO.File]::WriteAllText((Join-Path $destination "$name.yy"), $json + "`n", [System.Text.UTF8Encoding]::new($false))
Write-Output 'Extracted sX_LowHealth: 6 frames, 56x52, origin (28,50), 6 fps.'
