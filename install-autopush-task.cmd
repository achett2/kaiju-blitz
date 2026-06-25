@echo off
REM Optional: registers the watcher as a Scheduled Task that starts at logon,
REM so auto-push runs in the background without keeping a window open.
schtasks /Create /TN "KaijuBlitz AutoPush" /TR "powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%~dp0autopush.ps1\"" /SC ONLOGON /RL LIMITED /F
echo.
echo Task "KaijuBlitz AutoPush" installed - it starts automatically at next logon.
echo To start it right now:    schtasks /Run /TN "KaijuBlitz AutoPush"
echo To remove it later:       schtasks /Delete /TN "KaijuBlitz AutoPush" /F
pause
