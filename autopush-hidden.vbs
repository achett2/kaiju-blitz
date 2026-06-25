' Launches the Kaiju Blitz auto-push watcher with no visible window.
Set sh = CreateObject("WScript.Shell")
repo = "C:\Users\achettiath\Documents\code\kaiju-blitz"
sh.CurrentDirectory = repo
sh.Run "powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & repo & "\autopush.ps1""", 0, False
