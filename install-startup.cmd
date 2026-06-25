@echo off
REM Installs the auto-push watcher to the per-user Startup folder (no admin needed).
REM It will start hidden at every login, and we also start it right now.
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
copy /Y "%~dp0autopush-hidden.vbs" "%STARTUP%\KaijuBlitz-AutoPush.vbs"
echo.
echo Installed to: %STARTUP%\KaijuBlitz-AutoPush.vbs
echo Starting the watcher now (runs hidden)...
wscript "%STARTUP%\KaijuBlitz-AutoPush.vbs"
echo.
echo Done. Auto-push is running now and will start automatically at every login.
echo To stop permanently: delete the file above, then end "powershell" in Task Manager.
pause
