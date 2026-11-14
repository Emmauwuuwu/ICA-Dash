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
- **Cube mode** with Geometry Dash's jump and gravity (2.17-block jumps, hold to keep jumping), **spikes**, **jump pads** (yellow, pink, red, blue, spider) and **jump orbs** (yellow, pink, red, blue, green, black), and cube / wave portals to switch between them
- **D blocks** you slide along instead of crashing, and **dash orbs** (green, and pink that flips gravity) that send you straight at their angle while you hold
- **Achievements** that unlock 14 icon shapes and 12 colours, plus custom image icons
- **Level editor** with build, edit and delete tools, slopes, saws, spikes, pads, orbs, portals (including cube and wave), D blocks and dash orbs, a fine grid, undo/redo and playtesting from any point
- **Share codes**: copy a level's code from the editor and paste someone else's to play it
- **Practice tools** in a hidden menu: practice mode with checkpoints, show path, start position, hitboxes and more

Progress, icons and your levels are saved in your browser.

## Online levels and accounts

Anyone can browse and play online levels, no account needed. Make an account (username + password, under Settings → Account) to upload and like levels and to keep your progress in a cloud save, which you can also encrypt with a passphrase.

The online part runs on [Supabase](https://supabase.com). `supabase/schema.sql` creates the tables, and Row Level Security there decides who may change what, so the public key in `index.html` can't be used to edit other players' data.

## Files

Everything is in `index.html`: no build step. It loads Google Fonts and, for the online part, `supabase-js` (pinned, with an integrity hash).

Made with [Claude Code](https://claude.com/claude-code).
