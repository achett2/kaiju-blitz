# Kaiju Blitz — project guide for Claude Code

A Godzilla-themed math-facts game for Jacob (3rd grade). Single static page, deployed
to GitHub Pages. Repo: `github.com/achett2/kaiju-blitz` · Live: `https://achett2.github.io/kaiju-blitz/`

## Architecture
- **Everything is in `index.html`** — HTML, CSS, and JS are all inline in one file. There is no build step and no framework. Edit `index.html` directly.
- `kaiju-blitz.html` is just a tiny redirect stub to `index.html` (keeps old links/bookmarks working). Not a second copy of the game — don't edit game code there, and don't delete it.
- The game is a state machine keyed on `op` (the mode): `add`, `sub`, `mix`, `round`, `skip`, `mul`, `div`.
- The intro is a real-time HTML `<canvas>` cutscene (`playIntro()` / `frame()`): backstory words stacked below the box, story flash images, glowing eyes, a face reveal, atomic breath, title slam, closing montage + looping flashes, and background music.
- `kaiju-blitz-logger.gs` lives at `C:\Users\achettiath\Documents\Claude\Projects\Jacob Plan\kaiju-blitz-logger.gs` (NOT in this repo). It is a Google Apps Script web app bound to the **"kaiju_blitz_db"** Google Sheet; it logs sessions and serves coins/mastery state to the game via JSONP. If you change the `.gs`, the user must redeploy it manually (Deploy ▸ Manage deployments ▸ edit ▸ New version).

## Deploy flow (important)
- A watcher script, `start-autopush.cmd` / `autopush.ps1`, auto-commits and pushes every change to `origin/main`, which redeploys GitHub Pages (~1 min). **It stops often** — if a change isn't going live, the user needs to re-run `start-autopush.cmd`.
- **Autopush vs. manual commits:** don't race the watcher. Check whether it's running first (a fresh `auto: update …` commit or new lines in `autopush.log` within the last minute or so). If it is, let it push and don't commit manually. If it isn't, commit and push yourself (`git add -A && git commit && git push`), and `git pull --rebase` first if the push is rejected.
- After editing, **validate the JS** before relying on a deploy: extract the `<script>` block and run `node --check` on it.
- **Cache-busting:** reload the live page with a fresh `?cb=vN`. iOS Safari caches hard.
  - **`BUILD` constant** (near the end of the script, renders as a dim `build vN` tag bottom-right): bump it **once per logical change you want the user to verify**, not on every autopush save, so the user can tell at a glance whether that change is loaded.
  - **Asset `?v=N`** (`monImg()` uses `?v=4`; the audio tag, `INTRO_FACE`, `INTRO_CLASSIC` and the flash images each have their own): these are separate from `BUILD`. Bump an asset's `?v` only when **that image/audio file's contents change**.

## Art pipeline
- Prompts live in `C:\Users\achettiath\Documents\Claude\Projects\Jacob Plan\kaiju-art\PROMPTS.md`. The user generates images on a flat **magenta `#FF00FF`** background and drops them in `C:\Users\achettiath\Documents\Claude\Projects\Jacob Plan\kaiju-art\`.
- Claude then **chroma-keys** them to transparent PNG and saves into this repo. Use a **corner-sampled color-distance** key (not a pure magenta test) for art containing purple/pink, so it doesn't eat those colors. Full-scene "flash" panels are left as opaque JPGs (no keying).
- **File naming** (lowercase, hyphenated, repo root): `kaiju-<name>.png` for hero kaiju art (playable skins, plus intro art like `kaiju-face.png` / `kaiju-classic.png`), `boss-<name>.png` for original mode bosses (each mode has 2–4 bosses in the `ROSTERS` table, fought in list order with HP rising each spawn — e.g. `add: ["Crimson Brute","Iron Maw","Stackjaw","Tallyhorn"]` — and each boss name is mapped to its image in `bossArt(name)`; adding a boss means updating both. **Round mode ignores `ROSTERS`** and uses the scripted `ROUND_PLAYLIST` loop instead, so Round bosses go there too. Not every boss uses a `boss-*` file: Anguirus, The Alpha & Omega and Captain Underpants reuse `kaiju-anguirus.png` / `champion.png` / `underpants-hero.png`, and skip mode's Megabolt / Primal Wraith use their own art. `monImg(src, fallback)` takes an optional fallback image used while new art is missing), `flash-<name>.jpg` for opaque intro story panels, and plain `<name>.png` for one-off characters (`megabolt.png`, `primal-wraith.png`, `gunner-godzilla.png`, `champion.png`, `underpants-hero.png`).

## State (localStorage, per device)
`kb_state` (coins/owned/hero/mastery), `kb_skip_plays` (gates Mult/Div at 20), `kb_wraith_wins` (Shotgun-Godzilla mystery box at 10), `kb_wraith_intro`, `kb_daily` (Add/Sub/Round/Skip 8× each → Superman box), `kb_box_skins` (box-won skins, merged back after Sheet sync), `kb_intro_seenN`, `kb_bests` (per-mode records: smashed / fact-time % / avg seconds → "New record!" bonus), `kb_sesstoday` (session count today; coin bonuses only for the first 4 real sessions/day), `kb_days` (last-played day + rolling week → daily-play and 4-day-week bonuses).

## Known open items (as of 2026-10-02 — re-verify before relying on these)
- The Apps Script "mastery" storage redeploy was never confirmed working; mastery counts are only reliably visible on the in-game Badges screen. **To check:** play a session, then look for updated mastery values in the "kaiju_blitz_db" Sheet. If they're there, delete this item.
- Megabolt / Primal Wraith duel balance (`SKIP_HIT` 12, `SKIP_STRIKE` 18) and the Shotgun skin's ×3 redirect may need tuning.

## Conventions
- Keep it a single self-contained `index.html`; no external JS deps beyond Google Fonts.
- Original, non-infringing characters only: our kaiju/villains are *inspired by* Godzilla/Transformers but original (e.g. Megabolt ≈ Megatron, Primal Wraith ≈ Optimus Primal). Don't add the real trademarked characters.
