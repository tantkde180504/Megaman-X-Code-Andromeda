[CmdletBinding()]
param(
    [string]$RuntimePath = 'C:\ProgramData\GameMakerStudio2-LTS2026\Cache\runtimes\runtime-2026.0.0.23',
    [string]$UserPath,
    [string]$ProjectToolPath,
    [switch]$CheckOnly
)

$ErrorActionPreference = 'Stop'
$repoPath = Split-Path -Parent $PSScriptRoot
$igorPath = Join-Path $RuntimePath 'bin\igor\windows\x64\Igor.exe'
if (-not (Test-Path -LiteralPath $igorPath)) {
    throw 'Khong tim thay Igor. Truyen -RuntimePath tro den runtime GameMaker da cai.'
}

if (-not $UserPath) {
    $profileRoot = Join-Path $env:APPDATA 'GameMakerStudio2-LTS2026'
    $profiles = @(Get-ChildItem -LiteralPath $profileRoot -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'licence.plist') })
    if ($profiles.Count -eq 1) { $UserPath = $profiles[0].FullName }
}

if (-not $ProjectToolPath) {
    $ide = Get-Process -Name 'GameMaker*' -ErrorAction SilentlyContinue | Select-Object -First 1
    $ideRoot = if ($ide -and $ide.Path) { Split-Path -Parent $ide.Path }
        else { Join-Path $env:ProgramFiles 'GameMaker-LTS2026' }
    $ProjectToolPath = Join-Path $ideRoot 'packages\gm-tools\project-tool-win-x64\ProjectTool.exe'
}

$problems = @()
if (-not (Test-Path -LiteralPath $ProjectToolPath)) {
    $problems += 'Thieu Project Tool. Truyen -ProjectToolPath tro den packages/gm-tools/project-tool-win-x64/ProjectTool.exe trong thu muc IDE.'
}
if (-not $UserPath -or -not (Test-Path -LiteralPath (Join-Path $UserPath 'licence.plist'))) {
    $problems += 'Chua co profile licence. Dang nhap IDE GameMaker, sau do truyen -UserPath neu can.'
}
if (-not (Test-Path -LiteralPath (Join-Path $RuntimePath 'html5\scripts.html5.zip'))) {
    $problems += 'Thieu module HTML5 cua runtime nay. Cai HTML5 trong Runtime Manager cua IDE.'
}
if ($problems.Count -gt 0) { throw ($problems -join [Environment]::NewLine) }
Write-Host 'OK: Igor, profile licence va module HTML5 da co. Compiler se xac minh quyen khi build.'
if ($CheckOnly) { return }

# Each build has its own directory, so an older build cannot mask a failed one.
$buildId = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
$buildPath = Join-Path $repoPath "output\web\$buildId"
$gamePath = Join-Path $buildPath 'game'
$compiledPath = Join-Path $buildPath 'compiled'
$cachePath = Join-Path $repoPath 'cache\html5'
$tempPath = Join-Path $repoPath 'cache\html5-temp'
New-Item -ItemType Directory -Path $gamePath, $compiledPath -Force | Out-Null
# The 2026.0 HTML5 obfuscator fails on compile_if_weak_ref in the bundled runner.
$igorArgs = @(
    "--rp=$RuntimePath", "--uf=$UserPath",
    "--pt=$ProjectToolPath",
    '--ac=--obfuscateCombine',
    "--project=$(Join-Path $repoPath 'MegamanZ\MegamanZ.yyp')",
    "--cache=$cachePath", "--temp=$tempPath",
    "--of=$(Join-Path $compiledPath 'MegamanZ')", "--tf=$gamePath",
    '--', 'HTML5', 'folder'
)
$ErrorActionPreference = 'Continue' # Igor emits informational blank lines on stderr.
& $igorPath @igorArgs 2>&1 | Tee-Object -FilePath (Join-Path $buildPath 'build.log')
$buildExitCode = $LASTEXITCODE
$ErrorActionPreference = 'Stop'
if ($buildExitCode -ne 0) { throw "GameMaker build that bai. Xem $buildPath\build.log" }
if (-not (Test-Path -LiteralPath (Join-Path $gamePath 'index.html'))) {
    throw 'Compiler khong tao game/index.html. Chua dong goi ban web.'
}
Copy-Item -LiteralPath (Join-Path $repoPath 'web\index.html') -Destination (Join-Path $buildPath 'index.html')
# Avoid a first-run HTTP 404 when GameMaker probes the keyboard configuration.
Set-Content -LiteralPath (Join-Path $gamePath 'html5game\controls.ini') -Value '' -Encoding ASCII
$zipPath = Join-Path $repoPath "output\web\MegamanZ-web-$buildId.zip"
# Only publish the page and game assets; keep the compiler log out of the ZIP.
Compress-Archive -Path (Join-Path $buildPath 'index.html'), $gamePath -DestinationPath $zipPath
Write-Host "Web folder: $buildPath"
Write-Host "Upload ZIP: $zipPath"
Write-Host "Local preview: node tools/serve_web.cjs `"$buildPath`""
