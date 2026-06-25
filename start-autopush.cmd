@echo off
REM Starts the Kaiju Blitz auto-push watcher in this window.
REM Leave this window open while you work. Close it (or Ctrl+C) to stop.
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0autopush.ps1"
pause
