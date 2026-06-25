# Kaiju Blitz — auto-push setup

This makes every saved change to the game commit and push itself to
`origin/main`, which redeploys the GitHub Pages site automatically.

**The live page serves `index.html`.** Edit `index.html` for changes to go
live. (`kaiju-blitz.html` is an identical spare copy — editing it alone won't
change the live site.)

## One-time setup (do this once, on your machine)

Open a terminal **in this folder** (`C:\Users\achettiath\Documents\code\kaiju-blitz`)
and run:

```
git add -A
git commit -m "Set up auto-push + normalize line endings"
git push -u origin main
```

The first `git push` opens a GitHub sign-in window (Git Credential Manager).
Sign in once — Windows remembers it, so every future push is silent.

> If `git push` is rejected because the remote is ahead (you've edited via the
> GitHub website), run `git pull --rebase origin main` first, then push.

## Turn on auto-push (manual)

When you sit down to edit the game, double-click **`start-autopush.cmd`**.
A small window opens and watches the folder; every change you save is committed
and pushed automatically. Leave it open while you work, and close it (or press
Ctrl+C) when you're done.

> **Why manual?** This is a managed work machine. Its security software blocks
> background auto-start methods (Task Scheduler returned "Access is denied", and
> a Startup-folder launcher was removed automatically). Starting the watcher
> yourself when you need it is the reliable, IT-friendly approach.

## How it works

`autopush.ps1` checks the repo every 5 seconds. When anything changed it runs
`git add -A`, commits with a timestamped message, and pushes to `main`. GitHub
Pages rebuilds within about a minute. Activity is logged to `autopush.log`
(ignored by git).

## Notes

- `.gitattributes` forces LF line endings on the web files so commits stay clean
  (no more phantom "whole file changed" diffs from CRLF/LF).
- To stop auto-push: close the `start-autopush.cmd` window, or
  `schtasks /Delete /TN "KaijuBlitz AutoPush" /F` if you installed the task.
- `autopush.log` and any `*.junk` files are git-ignored and never pushed.
