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

## Turn on auto-push

Pick one:

- **Simple:** double-click **`start-autopush.cmd`**. A window opens and watches
  the folder. Leave it open while you work; close it (or Ctrl+C) to stop.
- **Always-on:** double-click **`install-autopush-task.cmd`** once. It registers
  a Scheduled Task that runs the watcher hidden at every logon. Start it
  immediately with `schtasks /Run /TN "KaijuBlitz AutoPush"`, or just log out and
  back in.

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
