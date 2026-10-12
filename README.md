# Frodes Dotfiles and system configuration

Dotfiles and system configuration shared across all of my machines, macOS and
Linux. It is tailored to my needs and preferences, but feel free to use it as a
reference or inspiration for your own configuration.

**Not every part of this repo is in use on every machine.** The repo is the
union of what all the machines need, and each machine picks the subset that
applies to it. A directory existing under `config/` does not mean it is active
anywhere in particular — see [What each machine uses](#what-each-machine-uses).

## Machines

| Host | OS | Provisioned by | Notes |
| --- | --- | --- | --- |
| `MacBookApple` | macOS (aarch64) | `darwinConfigurations` | Work laptop, aka zygbook. Prefer `scripts/update_zygbook.sh` over calling `darwin-rebuild` directly |
| `ZygizoOne` | Linux (x86_64) | `homeConfigurations` | home-manager only, not NixOS |
| `Ros` | Linux (aarch64) | `homeConfigurations` | Raspberry-Pi-class box |
| `homebook` | Omarchy (Arch) | `scripts/bootstrap_omarchy.sh` | **No nix.** 2018 MacBook Pro (T2, Radeon Pro 560X). See [Machines without nix](#machines-without-nix) |
| `bodbook` | Omarchy (Arch) | `scripts/bootstrap_omarchy.sh` | **No nix.** 2015 MacBookPro12,1 (Intel Iris 6100, no T2) |

## Two ways configs get linked

Both mechanisms symlink the same `config/` directory into place. Which one a
machine uses depends on whether nix is available on it.

### 1. Nix (the three flake hosts)

`flake.nix` wires together platform modules in `darwin/` and `linux/`. Each host
config declares its links itself, so they differ per host:

- `linux/*-configuration.nix` use home-manager `home.file` entries.
- `darwin/zygbook-configuration.nix` uses `ln -sfn` in a
  `system.activationScripts.postActivation` block, because it also needs to
  place macOS-only configs (sketchybar, aerospace, skhd).

Shared home-manager modules live in `common/` — see `common/README.md`.

### 2. Machines without nix

Omarchy machines run `scripts/link_config.sh`, which does the same job in plain
bash:

```sh
scripts/link_config.sh --dry-run   # report what would change
scripts/link_config.sh             # link, refusing to clobber anything
scripts/link_config.sh --force     # replace conflicts, backing them up first
```

It is idempotent, so it is safe to re-run after pulling. Without `--force` it
leaves any existing config that differs from the repo alone and exits non-zero
with a `diff` command to inspect it. With `--force` it moves the existing file
to `~/.config/.dotfiles-backup/<timestamp>/` before linking.

The list of links is the `links` table at the top of the script. Entries are
`<name in ~/.config>:<dir under config/>`, which is how `nvim` maps to
`config/lazyvim`. A second `home_links` table holds single files linked
relative to `$HOME` instead, as `<path under ~>:<path under config/>`; that is
how `config/claude/` ends up as `~/.claude/settings.json` and
`~/.claude/statusline.sh` without dragging the rest of `~/.claude` (history,
sessions, credentials) into the repo.

Both tables are what every omarchy machine gets. What only one machine should
get is in `config/omarchy/hosts/<hostname>/`, see
[Per-host omarchy config](#per-host-omarchy-config).

## Repo layout

```
flake.nix        Nix entrypoint, defines the three nix-managed hosts
darwin/          macOS (nix-darwin) host configurations
linux/           Linux (home-manager) host configurations
common/          Home Manager modules shared by both platforms
config/          The actual tool configs (see below)
scripts/         Per-machine rebuild and linking scripts
backup/          Copies of system files replaced by this config
secret.yaml      Machine-local, gitignored
```

## The `config/` directory

`config/` holds three different kinds of directory, which look alike but are
used in completely different ways. This matters when adding something new.

**XDG app configs** — symlinked into `~/.config/<name>`. These are the ones the
nix host configs and `link_config.sh` place: `alacritty`, `atuin`, `fish`,
`ghostty`, `kitty`, `lazygit`, `lazyvim` (linked as `nvim`), `nix`, `ohmyposh`,
`starship`, `tmux`, `toolkit`, `wezterm`, `zed`, `zellij`.

**Shell topic dirs** — *never* symlinked. `config/*/*.zsh`, `config/*/*.fish`
and `config/*/*.bash` are sourced directly out of `$DOTFILES` by
`config/zsh/zshrc`, `config/fish/conf.d/config.fish` and
`config/bash/omarchy.bash`, which glob them at shell startup. This is what
`homebrew/`, `java/`, `kubernetes/`, `python/`, `rust/`, `system/` and friends
are. Adding a `foo/aliases.zsh` is all it takes to get it loaded; adding a
symlink for it would be wrong. The `.bash` files are the omarchy port of the
fish setup: same aliases, atuin, direnv, difftastic and the yazi `y` function,
each guarded so a missing tool leaves the stock command alone.

**Home-relative files** — single files linked straight into `$HOME` rather than
a whole `~/.config` dir. `claude/` puts `settings.json` and `statusline.sh` in
`~/.claude/`; Claude Code writes `settings.json` back when you change a
setting, so the home-manager hosts link these with `mkOutOfStoreSymlink` to the
checkout instead of a read-only store copy, and zygbook uses `ln -sfn` like its
other links. `omarchy/themed/starship.toml.tpl` is the two-line starship prompt
with every colour replaced by an omarchy theme variable; linked into
`~/.config/omarchy/themed/`, `omarchy theme set` renders it alongside the other
themed configs, and `bash/omarchy.bash` points `STARSHIP_CONFIG` at the result.
Omarchy-only, so only `link_config.sh` places it. `omarchy/shell.json` is the
omarchy shell's user config (bar layout, idle lock and screensaver timeouts),
linked to `~/.config/omarchy/shell.json`; the shell writes to it too, from
`omarchy bar` and its settings panel, and saves through the symlink.
`omarchy/plugins/` holds user plugins for the omarchy shell, each dir linked
into `~/.config/omarchy/plugins/`. `frode.battery-suspend` suspends after 15
minutes of idle, but only on battery; omarchy itself never suspends on idle.
`frode.display-off` turns the displays off after 5 minutes of idle in place of
omarchy's screensaver, which runs a terminal animation on every monitor and
spins up the fans; the bootstrap script switches that screensaver off. Each
plugin is switched on by its entry in `shell.json`'s `plugins` list.
`frode.workspaces` is a clone of the bar's `omarchy.workspaces` widget that
always shows all ten workspaces, where the stock one shows 1-5 and adds 6-10
only while they hold a window; it is switched on by its id standing in for
`omarchy.workspaces` in `shell.json`'s bar layout. `omarchy plugin validate`
refuses symlinked folders, so run it on the dir in the repo.
`hypr/` holds five of the six Hyprland override files (`hyprland.lua`,
`input.lua`, `bindings.lua`, `looknfeel.lua`, `autostart.lua`), linked one by
one into `~/.config/hypr/` because omarchy owns that dir and keeps its own
files and upgrade backups there. The sixth, `monitors.lua`, names a machine's
panel and outputs, so it is per host. `omarchy/bin/` holds the user scripts those bindings
call, `theme-mode-toggle` (Catppuccin dark/light switch, `auto` picks by time
of day) and `clamshell-follow` (keeps the laptop's workspace visible on the
external monitor when the lid closes), linked into `~/.local/bin/`.
`bt-autoreconnect` is there too (keeps asking bonded Bluetooth LE keyboards
and mice to reconnect, because the T2 MacBook's Broadcom controller does not
pick them up on its own), but only homebook links it, and no host enables
it: every connect attempt makes the controller scan, and on this single-radio
chip that starves A2DP audio, so it stays off until it can run on demand.
`omarchy/systemd/user/` holds the user units, linked into
`~/.config/systemd/user/`: the `theme-mode-auto` service and timer that run
`theme-mode-toggle auto` at 06:00 and 20:00, and the `bt-autoreconnect`
service (linked on homebook, enabled nowhere). `omarchy/units` lists the units
every machine enables; the bootstrap script does the enabling.
`omarchy/applications/` holds web app launchers that `omarchy webapp install`
would otherwise write into `~/.local/share/applications/`, with their icons in
`omarchy/icons/` linked into `~/.local/share/icons/hicolor/256x256/apps/`.
`icloud-mail.desktop` is the mailto handler; the bootstrap script makes it the
default.
`vivaldi/vivaldi-stable.conf` is the flags file Vivaldi's launcher reads,
linked to `~/.config/vivaldi-stable.conf`; it turns on VA-API video decode,
which Chromium leaves off on Linux.
`omarchy/XCompose` is linked to `~/.XCompose`; it includes keyd's compose
table, which turns the Cancel-key sequences keyd emits for Alt+a and friends
into å, ø and æ. Without it those chords type digits and letters instead.
All Omarchy-only.

### Per-host omarchy config

The omarchy machines are different hardware, so what depends on the hardware
is kept apart in `config/omarchy/hosts/<hostname>/`:

```
home_links        extra links, same format as the table in link_config.sh
units             extra systemd user units to enable, one per line
hypr/monitors.lua that machine's panel and external outputs
foot/foot.ini     the terminal font sized for that panel's scale (homebook)
system/           root-owned files, copied to the same path under /
```

All of it is optional. `link_config.sh`, `install_omarchy_system.sh` and
`bootstrap_omarchy.sh` look up the dir by `hostname`; a machine without one
gets the shared setup and keeps omarchy's stock `monitors.lua`. Set
`DOTFILES_HOST=<name>` to dry-run another machine's setup.

`homebook` has the bulk of it: its monitor layout, `bt-autoreconnect`, and a
`system/` tree of T2 and Radeon fixes (listed under
[Omarchy machines](#omarchy-machines)). `bodbook` only has its `monitors.lua`,
still omarchy's stock file. None of homebook's system files apply to it: it
has no T2 chip, no dGPU and Thunderbolt 2.

**Bash on omarchy** — `~/.bashrc` stays omarchy's own file with one added line
that sources `config/bash/omarchy.bash` after the omarchy rc chain. That file
is only the loader for the `.bash` topic files above; put new things in a
topic dir, not in it. The older `config/bash/bashrc` is the Debian-style rc
the nix hosts link as `~/.bashrc` and is not used on omarchy.

**Platform-specific configs** — only linked on the machines that can use them.
`aerospace`, `sketchybar`, `skhd`, `yabai`, `iterm`, `macos` and `nix-darwin`
are macOS-only and have no target on Linux.

A few dirs are mixed, e.g. `config/atuin/` holds both `config.toml` (linked) and
`env.fish` (sourced). Linking the whole dir is harmless there.

Runtime state written back into linked dirs (atuin's `history.db`, lazyvim's
`lazy-lock.json`) shows up as working-tree changes. Purely local state is
gitignored; lockfiles are meant to be committed.

## What each machine uses

The rule of thumb: a machine uses what its own host config lists, and nothing
else. Some concrete consequences —

- **`homebook` deliberately skips `alacritty`, `ghostty` and `kitty`.** Omarchy
  manages those itself, and its versions are the ones that work on that
  hardware; the repo's copies are macOS-shaped (`macos-titlebar-style`, a
  `command` pointing into the nix store). They are excluded from the `links`
  table in `link_config.sh`, with a comment saying why.
- **macOS-only tools stay unlinked on Linux**, even though their configs are in
  the repo.
- **Configs can depend on tooling a given machine lacks.** `config/tmux` expects
  `tpm` and `sesh`; `config/lazygit` and `config/git/gitconfig` expect `difft`.
  Where nix installs those as part of the host config, they are present; on a
  non-nix machine they have to be installed separately, or the config silently
  degrades.

When adding a config that only some machines should get, add it to those hosts'
configs only, and note why in a comment.

## Installation

Clone to the home directory:

```sh
git clone https://github.com/frodeanonsen/dotfiles ~/.dotfiles
```

### Nix machines

Install nix, then build and switch:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

macOS:

```sh
nix build .#darwinConfigurations.MacBookApple.system
./result/sw/bin/darwin-rebuild switch --flake .#MacBookApple
```

Linux (home-manager):

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

home-manager switch --flake .#Ros
```

### Omarchy machines

```sh
scripts/bootstrap_omarchy.sh --dry-run
scripts/bootstrap_omarchy.sh --force
```

Run it from a terminal, it asks for the sudo password. It is idempotent and
runs these steps in order, each of which can also be run alone:

1. `link_config.sh` links the shared configs and this host's `home_links`. On
   a fresh install omarchy's stock files are in the way (`nvim`, `tmux`,
   `lazygit`, `shell.json`, the `hypr/` overrides), which is what `--force` is
   for: it backs them up and links. Leave it off when re-running later.
2. Appends the line to `~/.bashrc` that sources `config/bash/omarchy.bash`.
3. `install_omarchy_packages.sh` installs the package list.
4. `install_omarchy_system.sh` installs this host's `system/` files, if any.
5. Enables the user units in `config/omarchy/units` and the host's `units`.
6. Makes `icloud-mail.desktop` the mailto handler.
7. `omarchy theme refresh`, so the themed starship config gets rendered.

`--skip-root` leaves out steps 3 and 4, for running it from somewhere without
a way to ask for a password, such as over SSH without a tty.

For a machine with its own hardware quirks, add a
`config/omarchy/hosts/<hostname>/` dir first, see
[Per-host omarchy config](#per-host-omarchy-config). Not done by the script:
an SSH key for pushing (the clone above is HTTPS), and logging in to atuin,
`gh` and Claude Code.

The package script installs whatever is listed in `config/omarchy/packages`
and missing, through `omarchy pkg add`. That list is the omarchy counterpart
of the `home.packages` block in the nix host configs, minus what the omarchy
base already ships.

`scripts/install_omarchy_system.sh` copies the root-owned files under
`config/omarchy/hosts/<hostname>/system/` to the same paths under `/`. Only
homebook has any; today that is:

- A udev rule and the `dgpu-power` helper it runs: on the 2018 MacBook Pro the
  Radeon drives the panel under Linux and idles at ~13 W in auto, so the rule
  pins it to its lowest clocks whenever the adapter is unplugged and frees it
  again on AC. `dgpu-power status` shows what it is doing, `dgpu-power battery`
  forces the low state by hand.
- A Limine drop-in adding `pcie_port_pm=off`. With Omarchy's T2 defaults
  (`pm_async=off mem_sleep_default=deep`) the two Thunderbolt controllers were
  polled for ~6 s each after every resume; keeping PCIe ports out of D3 skips
  that and cut wake from ~20 s to ~2 s. The script rebuilds the boot image when
  this file changes.
- A NetworkManager drop-in that leaves the T2 chip's fake USB network
  interface unmanaged, so NetworkManager stops trying DHCP on it after resume.
- `keyd/default.conf`, the Mac Option letters: Alt+a is å, Alt+o is ø and
  Alt+' is æ, with Shift for the capitals. keyd sits below the compositor and
  only takes those six chords, so every other Alt combination still reaches
  Hyprland and the terminal. The script enables keyd and reloads it when this
  file changes; `keyd check` validates a config before installing it.
- `t2fand.conf`, the fan curve for `t2fanrd`. The packaged curve ramps from
  55°C to full speed at 75°C, which had both fans at ~4400 RPM with the CPU at
  60-65°C during video playback; this one ramps from 65°C to 90°C. The script
  restarts `t2fanrd` when this file changes.
- `systemd/sleep.conf.d/homebook-no-s2idle.conf`, `SuspendState=mem` and
  `MemorySleepMode=deep`. systemd tries its default `mem standby freeze` in
  turn, so a deep suspend that fails (the Wi-Fi chip sometimes times out
  entering D3) silently falls through to `freeze`, which is s2idle. s2idle has
  never resumed cleanly on this machine: the Thunderbolt controllers die and it
  hard-crashes soon after, which is how the Oct 4 2026 crash happened. With
  only `mem` listed a failed suspend just returns to the desktop.
- `systemd/system/suspend-t2.service`, the t2linux sleep hook, cut down to
  unloading `brcmfmac` before suspend and loading it again on resume, so the
  D3 timeout above has nothing to time out. The copy Omarchy ships has every
  line commented out except a `systemctl stop tiny-dfr` that fails on each
  suspend because tiny-dfr is not installed. The script reloads systemd when
  this file changes.
- `systemd/journald.conf.d/homebook-sync.conf`, `SyncIntervalSec=30s` instead
  of the 5 min default, so a hard crash loses at most half a minute of log.
  The script restarts journald when this file changes.

Two suspend-related files on homebook stay Omarchy's own: `/etc/default/limine`
must only use `KERNEL_CMDLINE[default]+=` (a plain `=` there silently
overrides every Omarchy drop-in, including the T2 suspend parameters), and
`/etc/systemd/sleep.conf` itself stays stock; the sleep drop-in above only
narrows it to S3. Old T2 workarounds that force `s2idle`/`freeze`, or unload
the `apple-bce`/`t2bce` and Touch Bar modules around sleep, break the current
`t2bce` driver and must not come back; unloading `brcmfmac` alone is fine, it
is a separate PCIe device.

Both scripts need root. From a terminal that is a sudo prompt; from something
without one, like the `!` runner in Claude Code, they fall back to a `pkexec`
dialog.

## Rebuilding

| Machine | Command |
| --- | --- |
| `MacBookApple` | `scripts/update_zygbook.sh` (add `--flake` to refresh inputs first) |
| `ZygizoOne` | `scripts/update_linux.sh` |
| `Ros` | `scripts/update_ros.sh` |
| `homebook`, `bodbook` | `scripts/bootstrap_omarchy.sh` |

Run `nix flake check` before pushing changes that touch the nix side. It does
not cover `config/` or `scripts/`, so changes that only affect a non-nix machine
need testing on that machine.

## References

The configuration is based on [NixOS](https://nixos.org/), a declarative system
configuration tool. Inspiration taken from:

- [Home Manager](https://nix-community.github.io/home-manager/options.xhtml)
- [Nix Darwin](https://github.com/LnL7/nix-darwin)
- [MatthiasBenaets/nix-config](https://github.com/MatthiasBenaets/nix-config)
- [omerxx/dotfiles](https://github.com/omerxx/dotfiles)
