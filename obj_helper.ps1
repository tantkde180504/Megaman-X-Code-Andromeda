$projDir = "d:\MZ4\MegamanZ"

function Create-GMObject {
    param (
        [string]$Name,
        [string]$Folder,
        [string]$ParentName = $null,
        [string]$SpriteName = $null,
        [bool]$Persistent = $false,
        [bool]$Solid = $false,
        [hashtable]$Events # key: "eventType_eventNum" -> content
    )

    $objDir = Join-Path $projDir "objects\$Name"
    New-Item -ItemType Directory -Path $objDir -Force | Out-Null

    $eventList = @()
    foreach ($k in $Events.Keys) {
        $parts = $k.Split('_')
        $evType = [int]$parts[0]
        $evNum = [int]$parts[1]

        $eventList += @"
    {"`$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":$evNum,"eventType":$evType,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
"@

        $fileName = switch ($evType) {
            0 { "Create_$evNum.gml" }
            1 { "Destroy_$evNum.gml" }
            3 { "Step_$evNum.gml" }
            7 { "Other_$evNum.gml" }
            8 { if ($evNum -eq 64) { "Draw_64.gml" } else { "Draw_$evNum.gml" } }
            12 { "CleanUp_$evNum.gml" }
            Default { "Event_${evType}_${evNum}.gml" }
        }

        Set-Content -Path (Join-Path $objDir $fileName) -Value $Events[$k] -Encoding UTF8
    }

    $eventListStr = $eventList -join "`n"

    $parentObjStr = "null"
    if ($ParentName) {
        $parentObjStr = @"
{
    "name": "$ParentName",
    "path": "objects/$ParentName/$ParentName.yy",
  }
"@
    }

    $spriteObjStr = "null"
    if ($SpriteName) {
        $spriteObjStr = @"
{
    "name": "$SpriteName",
    "path": "sprites/$SpriteName/$SpriteName.yy",
  }
"@
    }

    $yy = @"
{
  "`$GMObject":"",
  "%Name":"$Name",
  "eventList":[
$eventListStr
  ],
  "managed":true,
  "name":"$Name",
  "overriddenProperties":[],
  "parent":{
    "name":"$Folder",
    "path":"folders/Objects/$Folder.yy",
  },
  "parentObjectId":$parentObjStr,
  "persistent":$($Persistent.ToString().ToLower()),
  "physicsAngularDamping":0.1,
  "physicsDensity":0.5,
  "physicsFriction":0.2,
  "physicsGroup":1,
  "physicsKinematic":false,
  "physicsLinearDamping":0.1,
  "physicsObject":false,
  "physicsRestitution":0.1,
  "physicsSensor":false,
  "physicsShape":1,
  "physicsShapePoints":[],
  "physicsStartAwake":true,
  "properties":[],
  "resourceType":"GMObject",
  "resourceVersion":"2.0",
  "solid":$($Solid.ToString().ToLower()),
  "spriteId":$spriteObjStr,
  "spriteMaskId":$spriteObjStr,
  "visible":true,
}
"@
    Set-Content -Path (Join-Path $objDir "$Name.yy") -Value $yy -Encoding UTF8
}

Write-Host "Helper function defined."
