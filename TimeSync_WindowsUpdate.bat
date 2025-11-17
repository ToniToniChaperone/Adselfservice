@echo off
::----------------------------------------
:: Self-Elevate Script to Run as Admin and Keep Console Open
::----------------------------------------
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    powershell -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/k ""%~f0""' -Verb RunAs"
    exit /b
)

::----------------------------------------
:: GUI Message: Starting
::----------------------------------------
powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Starting Time Sync and Windows Update process.','Sync & Update','OK','Information')"

::----------------------------------------
:: Set Timezone to Philippines (UTC+08:00)
::----------------------------------------
tzutil /s "Singapore Standard Time"

::----------------------------------------
:: Force Time Sync (allow large correction)
::----------------------------------------
w32tm /config /update /maxposphasecorrection:3600 /maxnegphasecorrection:3600
w32tm /resync /force

::----------------------------------------
:: Run Windows Update PowerShell script (Tiny11-safe)
::----------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\sfadmin\Downloads\Test\Update-Tiny11.ps1"

::----------------------------------------
:: Completion GUI
::----------------------------------------
powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Time sync complete and Windows Update finished (or skipped if unavailable).','Completed','OK','Information')"

::----------------------------------------
:: Pause to keep console open
::----------------------------------------
pause
