param(
    [Parameter(Mandatory)][ValidateSet('arm64', 'x86_64')][string]$Architecture,
    [switch]$Offline
)
$ErrorActionPreference = 'Stop'
$machine = if ($Architecture -eq 'arm64') { 'arm64' } else { 'amd64' }
$peMachine = if ($Architecture -eq 'arm64') { 0xAA64 } else { 0x8664 }
$subdir = if ($Architecture -eq 'arm64') { 'win-arm64' } else { 'win-64' }
$mode = if ($Offline) { 'offline' } else { 'online' }
if (-not $env:RUNNER_TEMP) { throw 'RUNNER_TEMP must point to a disposable test directory' }
$results = "build/windows-tests-$Architecture-$mode"
New-Item -ItemType Directory -Force $results | Out-Null
Start-Transcript -Path "$results/acceptance.log"
function Require-Success([string]$what) {
    if ($LASTEXITCODE -ne 0) { throw "$what exited $LASTEXITCODE" }
}
function Assert-PE([string]$path) {
    $stream = [System.IO.File]::OpenRead($path)
    $reader = [System.IO.BinaryReader]::new($stream)
    try {
        $stream.Position = 0x3c
        $offset = $reader.ReadInt32()
        $stream.Position = $offset
        if ($reader.ReadUInt32() -ne 0x00004550) { throw "Invalid PE header: $path" }
        $actual = $reader.ReadUInt16()
        if ($actual -ne $peMachine) { throw "Unexpected PE architecture: $path ($actual)" }
        "Verified $Architecture PE: $path"
    } finally { $reader.Dispose() }
}
function Install-Miniforge([string]$prefix) {
    $p = Start-Process $script:installer -NoNewWindow -ArgumentList "/InstallationType=JustMe /RegisterPython=0 /AddToPath=0 /S /D=$prefix" -PassThru
    if (-not $p.WaitForExit(300000)) { $p.Kill(); throw 'Installer timeout' }
    if ($p.ExitCode -ne 0) { throw "Installer exited $($p.ExitCode)" }
    & "$prefix/python.exe" -c "import platform,struct; assert platform.machine().lower()=='$machine'; assert struct.calcsize('P')==8; print('Expected Python architecture verified')"
    Require-Success 'Python architecture'
    Assert-PE "$prefix/python.exe"
    Assert-PE "$prefix/Library/bin/mamba.exe"
}
function Uninstall-Miniforge([string]$prefix) {
    $u = @(Get-ChildItem -LiteralPath $prefix -Filter 'Uninstall-*.exe')
    if ($u.Count -ne 1) { throw 'Expected one generated uninstaller' }
    # NSIS _?= keeps the uninstaller process synchronous, avoiding the copied temp process.
    $p = Start-Process $u[0].FullName -ArgumentList "/S _?=$prefix" -PassThru
    if (-not $p.WaitForExit(180000)) { $p.Kill(); throw 'Uninstaller timeout' }
    if ($p.ExitCode -ne 0) { throw "Uninstaller exited $($p.ExitCode)" }
    if (Test-Path "$prefix/python.exe") { throw 'Uninstaller left Python installed' }
    if (Test-Path "$prefix/conda-meta") { throw 'Uninstaller left environment metadata' }
    if (-not (Test-Path $script:sentinel)) { throw 'Uninstaller affected unrelated sentinel' }
    'Uninstall removed Python and metadata; unrelated sentinel preserved.'
}
function Save-Shortcuts([string]$prefix, [string]$outName) {
    $shell = New-Object -ComObject WScript.Shell
    $links = @(Get-ChildItem "$env:APPDATA/Microsoft/Windows/Start Menu/Programs" -Filter '*.lnk' -Recurse | ForEach-Object {
        $s = $shell.CreateShortcut($_.FullName)
        if ($s.Arguments -like "*$prefix*" -or $s.TargetPath -like "$prefix*") {
            [pscustomobject]@{ path=$_.FullName; target=$s.TargetPath; arguments=$s.Arguments }
        }
    })
    $links | ConvertTo-Json -Depth 5 | Set-Content "$results/$outName.json"
    return $links
}
try {
    $files = @(Get-ChildItem "build/*Windows-$Architecture.exe")
    if ($files.Count -ne 1) { throw 'Expected one Windows installer' }
    $script:installer = $files[0].FullName
    $hash = (Get-FileHash $script:installer -Algorithm SHA256).Hash
    Write-Output "Installer SHA256: $hash"
    $rejected = Join-Path $env:RUNNER_TEMP "Miniforge $Architecture Rejected"
    $reject = Start-Process $script:installer -NoNewWindow -ArgumentList "/InstallationType=JustMe /RegisterPython=0 /AddToPath=0 /S /D=$rejected" -Wait -PassThru
    if ($reject.ExitCode -ne 2 -or (Test-Path "$rejected/python.exe")) { throw 'Expected existing Miniforge rejection of paths containing spaces' }
    $script:sentinel = Join-Path $env:RUNNER_TEMP "unrelated-miniforge-$Architecture-$mode.txt"
    'preserve me' | Set-Content $script:sentinel
    $prefix = Join-Path $env:RUNNER_TEMP "Miniforge-$Architecture-$mode"
    if ($Offline) {
        if ($env:GITHUB_ACTIONS -ne 'true' -or $env:RUNNER_ENVIRONMENT -ne 'github-hosted') {
            throw 'Network blocking requires a disposable GitHub-hosted runner'
        }
        $probeUrl = 'https://conda.anaconda.org/conda-forge/noarch/'
        Invoke-WebRequest $probeUrl -Method Head -TimeoutSec 20 | Out-Null
        $rule = 'MiniforgeOffline-' + [guid]::NewGuid().ToString()
        try {
            New-NetFirewallRule -Name $rule -DisplayName $rule -Direction Outbound -Action Block -Profile Any | Out-Null
            $blocked = $false
            try { Invoke-WebRequest $probeUrl -Method Head -TimeoutSec 10 | Out-Null } catch { $blocked = $true }
            if (-not $blocked) { throw 'Offline isolation failed: package channel still reachable' }
            Install-Miniforge $prefix
            $packages = & "$prefix/Scripts/conda.exe" list --json | ConvertFrom-Json
            Require-Success 'Offline inventory'
            foreach ($name in @('python','conda','mamba','pip','miniforge_console_shortcut')) {
                if ($name -notin $packages.name) { throw "Offline base missing $name" }
            }
            & "$prefix/Library/bin/mamba.exe" --version
            Require-Success 'Offline Mamba'
        } finally {
            Remove-NetFirewallRule -Name $rule -ErrorAction SilentlyContinue
            # The blocked probe can leave a negative DNS entry cached by Windows.
            Clear-DnsClientCache
        }
        Invoke-WebRequest $probeUrl -Method Head -TimeoutSec 20 | Out-Null
        Uninstall-Miniforge $prefix
        "PASS: $Architecture offline installer acceptance."
        return
    }
    Install-Miniforge $prefix
    $conda = "$prefix/Scripts/conda.exe"
    $mamba = "$prefix/Library/bin/mamba.exe"
    $info = & $conda info --json | ConvertFrom-Json
    Require-Success 'Conda info'
    if ($info.platform -ne $subdir) { throw 'Incorrect Conda platform' }
    foreach ($record in Get-ChildItem "$prefix/conda-meta/*.json") {
        $package = Get-Content $record -Raw | ConvertFrom-Json
        if ($package.subdir -notin @($subdir, 'noarch')) { throw "Foreign package: $($package.name) $($package.subdir)" }
    }
    & $conda list --explicit | Set-Content "$results/acceptance-explicit.txt"
    Require-Success 'Conda inventory'
    $links = @(Save-Shortcuts $prefix 'shortcuts-installed')
    if ($links.Count -lt 1) { throw 'No installed shortcut targets this prefix' }
    if (-not ($links | Where-Object { $_.arguments -like '*activate.bat*' })) { throw 'Prompt shortcut does not invoke activation' }
    $prompt = @($links | Where-Object { $_.arguments -like '*activate.bat*' })[0]
    $probePath = Join-Path $env:RUNNER_TEMP 'shortcut-probe.json'
    # Run the shortcut's stored activation command, changing /K to /C only so the probe exits.
    $probeArgs = ($prompt.arguments -replace '(?i)^/K\s+', '/D /C call ') + ' && python -c "import json,os,platform; print(json.dumps(dict(prefix=os.environ.get(''CONDA_PREFIX''),machine=platform.machine())))" > "' + $probePath + '"'
    $probeProcess = Start-Process $prompt.target -ArgumentList $probeArgs -NoNewWindow -Wait -PassThru
    if ($probeProcess.ExitCode -ne 0 -or -not (Test-Path $probePath)) { throw 'Shortcut activation command failed' }
    $probe = Get-Content $probePath -Raw | ConvertFrom-Json
    if ($probe.prefix -ne $prefix -or $probe.machine.ToLower() -ne $machine) { throw 'Shortcut activated incorrect environment' }
    Copy-Item $probePath "$results/shortcut-runtime.json"

    $child = Join-Path $env:RUNNER_TEMP "Miniforge-$Architecture-child"
    & $conda create -y -p $child --override-channels -c conda-forge python=3.14 zlib
    Require-Success 'Conda create'
    & $mamba install -y -p $child --override-channels -c conda-forge six numpy
    Require-Success 'Mamba install'
    & "$child/python.exe" -c "import platform,six,zlib; assert platform.machine().lower()=='$machine'; s=b'installer acceptance'*100; assert zlib.decompress(zlib.compress(s))==s; print(six.__version__)"
    Require-Success 'Native child execution'
    & "$child/python.exe" -c "import numpy as np; from numpy._core import _multiarray_umath; a=np.array([[3.,1.],[1.,2.]]); b=np.array([9.,8.]); np.testing.assert_allclose(a @ np.linalg.solve(a,b),b); print(np.__version__); print(_multiarray_umath.__file__)"
    Require-Success 'NumPy import and linear algebra'
    $numpyExtension = & "$child/python.exe" -c "from numpy._core import _multiarray_umath; print(_multiarray_umath.__file__)"
    Require-Success 'NumPy extension path'
    Assert-PE $numpyExtension
    foreach ($record in Get-ChildItem "$child/conda-meta/*.json") {
        $package = Get-Content $record -Raw | ConvertFrom-Json
        if ($package.subdir -notin @($subdir, 'noarch')) { throw "Foreign child package: $($package.name) $($package.subdir)" }
    }
    & $conda list -p $child --explicit | Set-Content "$results/child-explicit.txt"
    Require-Success 'Child inventory'
    $cmdTest = Join-Path $env:RUNNER_TEMP 'miniforge-activation.cmd'
    @"
@echo off
call "$prefix\condabin\conda_hook.bat"
if errorlevel 1 exit /b 1
call conda activate "$child"
if errorlevel 1 exit /b 1
if /I not "%CONDA_PREFIX%"=="$child" exit /b 2
python -c "import platform; assert platform.machine().lower()=='$machine'"
if errorlevel 1 exit /b 1
call conda deactivate
if errorlevel 1 exit /b 1
"@ | Set-Content $cmdTest
    & cmd.exe /d /c $cmdTest
    Require-Success 'CMD activation'
    $psTest = Join-Path $env:RUNNER_TEMP 'miniforge-activation.ps1'
    @"
`$ErrorActionPreference = 'Stop'
(& '$conda' shell.powershell hook) | Out-String | Invoke-Expression
conda activate '$child'
if (`$env:CONDA_PREFIX -ne '$child') { throw 'Incorrect PowerShell prefix' }
python -c "import platform; assert platform.machine().lower()=='$machine'"
if (`$LASTEXITCODE) { exit `$LASTEXITCODE }
conda deactivate
"@ | Set-Content $psTest
    & pwsh -NoProfile -File $psTest
    Require-Success 'PowerShell activation'
    & $mamba update -y -p $child --override-channels -c conda-forge zlib
    Require-Success 'Mamba update'
    & $mamba remove -y -p $child six numpy
    Require-Success 'Mamba remove'
    & "$child/python.exe" -c "import importlib.util; assert importlib.util.find_spec('six') is None; assert importlib.util.find_spec('numpy') is None"
    Require-Success 'Removal verification'
    & $conda env remove -y -p $child
    Require-Success 'Conda environment removal'
    Uninstall-Miniforge $prefix
    $remaining = @(Save-Shortcuts $prefix 'shortcuts-after-uninstall')
    if ($remaining.Count) { throw 'Uninstaller left a shortcut targeting the removed prefix' }
    "PASS: $Architecture $mode installer acceptance."
} finally { Stop-Transcript }
