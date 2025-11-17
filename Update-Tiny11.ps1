# Ensure Windows Update services exist and are running
$services = @('wuauserv','bits','dosvc')
foreach ($s in $services) {
    $svc = Get-Service -Name $s -ErrorAction SilentlyContinue
    if ($svc) {
        if ($svc.Status -ne 'Running') { Start-Service $s -ErrorAction SilentlyContinue }
    } else {
        Write-Host "Service $s not found, skipping updates."
        exit
    }
}

# Install NuGet if missing
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}

# Install PSWindowsUpdate module if missing
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-Module -Name PSWindowsUpdate -Force -AllowClobber -Scope CurrentUser
}

Import-Module PSWindowsUpdate

# Run updates safely, accept all, ignore reboot
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot
