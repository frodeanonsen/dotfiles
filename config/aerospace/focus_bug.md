# AeroSpace: new windows lose focus and land behind (2026-09-06)

## Symptom

Launching an app makes its window appear, flicker, then drop behind the previously
focused window. Seen with alt-enter (`open -n -a ghostty`) and alt-p
(`open -a "System Preferences"`). Started after the 2026-09-03 updates.

## Environment

- macOS 26.6.2 (installed 2026-09-03 16:53)
- AeroSpace 0.21.3-Beta (cask, installed 2026-08-23)
- Ghostty 1.3.1 from nixpkgs (1.2.3 before the 2026-09-03 flake refresh)
- sketchybar 2.23.0, JankyBorders 1.8.4, Sol 2.1.356

## Measurements

Focus polled every 250 ms via `lsappinfo front`, AeroSpace state via
`aerospace list-windows`.

| Scenario | Result |
|---|---|
| Fresh Calculator / TextEdit | new window keeps focus, 3/3 |
| `open -n -a ghostty`, repo config | focus snaps back after ~1.3 s, 9/9 |
| `open -n -a ghostty`, stripped config (no callbacks, rules, unhide) | reverts, 3/3 |
| `open -n -a ghostty`, `aerospace enable off` | keeps focus, 2/2 |
| `automatically-unhide-macos-hidden-apps = false` only | 3 keep, 5 revert |
| Ghostty 1.2.3 instead of 1.3.1 | reverts the same |
| System Settings, fresh launch | reverts, 2/2; window absent from `list-windows` 3.5 s later |
| System Settings, already running | keeps focus, window already listed |
| `aerospace focus --window-id` on the new window at 0.6 s | reverted anyway |
| `aerospace focus --window-id` on the new window at 2.5 s | stuck |

Window detection latency for the same app varied from 0.6 s to over 3.5 s.

## Conclusion

Not a config problem. About 1.3 s after a launch AeroSpace runs a focus sync; if it has
not detected the new window by then it re-asserts focus on an older window. Apps whose
windows it detects slowly (Ghostty second instances, System Settings) lose the race most
of the time; fast ones win. Disabling AeroSpace removes the revert entirely.

Ghostty is exonerated by the 1.2.3 test. The regression is between AeroSpace 0.21.3 and
macOS 26.6.2. Related upstream: nikitabobko/AeroSpace#1615 (slow window detection,
main thread waits on all app threads). No upstream report yet mentions the focus revert
on 26.6.

## Config notes (not causes)

- `automatically-unhide-macos-hidden-apps = true` makes it worse (0/9 vs 3/8), now set to `false`. Tahoe
  misbehaviour with this option also reported in AeroSpace discussion #1969.
- `aerospace.toml` on-window-detected regex `'\\.dotfiles'` was a TOML literal string,
  so it never matched. Fixed to `'\.dotfiles'`.
- Ghostty 1.3.1 `+new-window` reports "not supported on this platform" on macOS, so
  `open -n` or AppleScript (File > New Window) are the only ways to get a new window
  from a keybind.

## Workarounds

1. Wrapper for launch bindings: run `open`, poll `aerospace list-windows --all` until the
   new pid's window appears, wait past ~2 s, then `aerospace focus --window-id`.
   Worked in test.
2. For Ghostty, avoid instances: `exec-and-forget osascript` clicking File > New Window
   (needs Accessibility, untested).
3. Report upstream with the table above; optionally try AeroSpace 0.21.2 / 0.20.3 to
   pin which side regressed.
