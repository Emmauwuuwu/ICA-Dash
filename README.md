# ICA Dash

A one-button wave game that runs in your browser. Hold to climb at 45°, let go to dive, and thread your way through fifteen levels without touching a wall or a saw.

**▶ Play it: https://emmauwuuwu.github.io/ICA-Dash/**

## Controls

| Action | Default |
|---|---|
| Climb (hold) | Space, ↑, W, mouse button or touch |
| Dive | Let go |
| Pause / resume | Esc (also the II button) |
| Restart | R |

Keybinds can be changed in Settings.

## What's in it

- **15 levels** from Easy to Extreme, each unlocked by beating the one before
- **Portals** for speed (0.5x–4x), mini, upside down and dual
- **Ship mode** using Geometry Dash's ship physics (hold to rise, let go to fall, sliding on floors and ceilings)
- **UFO mode** using Geometry Dash's UFO physics (each click jumps, in the air too), with its own orb strengths and an orange UFO portal
- **Cube mode** with Geometry Dash's jump and gravity (2.17-block jumps, hold to keep jumping), **spikes**, **jump pads** (yellow, pink, red, blue, spider) and **jump orbs** (yellow, pink, red, blue, green, black), (the ship uses them too; the wave uses blue and green orbs to flip gravity), and cube / wave portals to switch between them
- **Letter blocks** like Geometry Dash's, invisible in play: **D** (the wave can touch blocks), **J** (no held jumps), **S** (ends a dash), **H** (the cube can hit its head) and **F** (hitting your head flips gravity), and **dash orbs** (green, and pink that flips gravity) that send you straight at their angle while you hold
- **Achievements** that unlock 14 icon shapes and 12 colours, plus custom image icons (wave, cube and ship, with mirror and recolour for the ship)
- **Triggers** (move, rotate, fade, colour) acting on numbered groups of objects, plus **coins** to collect, **checkpoints** for practice mode, **teleport** and **gravity swap** portals and **small spikes**
- **Level editor** laid out like Geometry Dash's: build, edit and delete modes, object tabs and pages, GD's edit buttons and shortcuts (W A S D to move, Q / E to turn, Alt+Q / Alt+E to flip, Ctrl+C / V / D, F1 / F2 for tabs, Enter to playtest), copy and paste, box select, swipe, free rotate (15° steps, Shift+Q / Shift+E) for every object, blocks and slopes included, and size for spikes, saws, orbs, pads, coins and portals (Size − / + in Edit, or type an exact size in Edit Group), with hitboxes that turn and size with them, start positions (speed, gamemode, mini, gravity, dual) to playtest from, and a start position switcher (← / →) in normal play (those runs don't count), and a playtest that leaves your route drawn in the editor. Slopes, saws, spikes, pads, orbs, portals (including cube, ship and wave), letter blocks, text and dash orbs, a fine grid and undo/redo
- **Community icons**: share your custom wave, cube or ship image; a moderator approves it before anyone else sees it, then anyone can use it (public version, needs `supabase/icons.sql`). New players start white, with a random approved community wave icon
- **Share codes**: copy a level's code from the editor and paste someone else's to play it
- **Music and sound**: 20 original built-in tracks (made in the browser), sound effects, volume sliders, and Newgrounds songs by ID for your own levels. Newgrounds doesn't allow other sites to stream its songs, so, like GD, you download a song from Newgrounds once and load the file; it stays in your browser. When you open someone's level that uses a Newgrounds song you don't have, the game asks first: open it on Newgrounds, load the file, or play without it, and the online list shows each level's song. Levels can also use a **SoundCloud** track: paste its link in the editor's Song menu and it plays for everyone through SoundCloud's own player, with nothing to download (GitHub Pages version)
- **Practice mode** from the pause menu, like Geometry Dash's: place checkpoints (Z / X or the on-screen buttons, plus optional auto checkpoints), respawn at the newest one and keep going, with its own practice best
- **Tutorial**: a first visit offers a short tour (playing, keybinds, making an account, making a level) that ends by offering an editor tour; until you take it, opening the editor offers it again. Settings → Tutorial replays both
- **Looks** (Settings → Look): ICA red on dark, ICA red on white, or the original yellow. The home screen shows your icon flying the hardest levels
- **Replays**: after beating a level, *Watch your run* plays your run back exactly (Esc ends it, the restart key starts it over). A practice win plays back as one run from the start, with the deaths cut out
- **Hacks** in a hidden menu, including **macros** (record a level's winning run, then let the bot play it back): show path, start position, hitboxes, speedhack, wave pulse and trail size and more

Progress, icons and your levels are saved in your browser.

## Online levels and accounts

Anyone can browse and play online levels, no account needed. Make an account (username + password, under Settings → Account) to upload and like levels and to keep your progress in a cloud save, which you can also encrypt with a passphrase.

The online part runs on [Supabase](https://supabase.com). `supabase/schema.sql` creates the tables (`supabase/icons.sql` adds the community icons table to a database set up earlier), and Row Level Security there decides who may change what, so the public key in `index.html` can't be used to edit other players' data.

## Files

Everything is in `index.html`: no build step. It loads Google Fonts and, for the online part, `supabase-js` (pinned, with an integrity hash).

`assets/portals.png` is a fan-made portal texture sheet shared on Reddit as free to use, upscaled 4x with [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN) (its illustration model) and with its grey background cut out. The game falls back to drawn portals if it can't load it.

Made with [Claude Code](https://claude.com/claude-code).
