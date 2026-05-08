
$ErrorActionPreference = "Stop"  # Exit immediately on most errors

param (
    [string]$buildDir = "build"
)

$exitCode = 0
$exeFiles = Get-ChildItem "$buildDir/*.exe"

# Verifies signatures for previously signed EXE files in the build/ directory

foreach ($executable in $exeFiles) {
    Write-Host "******************************************"
    Write-Host $executable.Name
    Write-Host "******************************************"
    $sig = Get-AuthenticodeSignature -FilePath $executable.FullName
    $sig | Format-List * | Out-String | Write-Host
    if ($sig.Status -ne 'Valid') {
        Write-Error "CRITICAL: Signature verification failed for $($executable.Name)!"
        $exitCode = 1
    }
}

# Regenerate the SHA256 files, since the checksum changes with the signature

foreach ($executable in $exeFiles) {
    $hashObject = Get-FileHash $executable.FullName
    "$($hashObject.Hash.ToLower())  $($executable.Name)" | Out-File -FilePath "$($executable.FullName).sha256"
    Write-Host "SHA256($($executable.Name)): $($hashObject.Hash.ToLower())"
}

exit $exitCode
