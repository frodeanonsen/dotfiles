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
| `BodBook` | macOS | `darwinConfigurations` | |
| `ZygizoOne` | Linux (x86_64) | `homeConfigurations` | home-manager only, not NixOS |
| `Ros` | Linux (aarch64) | `homeConfigurations` | Raspberry-Pi-class box |
| `homebook` | Omarchy (Arch) | `scripts/link_config.sh` | **No nix.** See [Machines without nix](#machines-without-nix) |

## Two ways configs get linked

Both mechanisms symlink the same `config/` directory into place. Which one a
machine uses depends on whether nix is available on it.

### 1. Nix (the four flake hosts)

`flake.nix` wires together platform modules in `darwin/` and `linux/`. Each host
config declares its links itself, so they differ per host:

- `linux/*-configuration.nix` and `darwin/bodbook-configuration.nix` use
  home-manager `home.file` entries.
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
`config/lazyvim`.

## Repo layout

```
flake.nix        Nix entrypoint, defines the four nix-managed hosts
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
`sol`, `starship`, `tmux`, `toolkit`, `wezterm`, `zed`, `zellij`.

**Shell topic dirs** — *never* symlinked. `config/*/*.zsh` and `config/*/*.fish`
are sourced directly out of `$DOTFILES` by `config/zsh/zshrc` and
`config/fish/conf.d/config.fish`, which glob them at shell startup. This is what
`homebrew/`, `java/`, `kubernetes/`, `python/`, `rust/`, `system/` and friends
are. Adding a `foo/aliases.zsh` is all it takes to get it loaded; adding a
symlink for it would be wrong.

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
scripts/link_config.sh --dry-run
scripts/link_config.sh
```

## Rebuilding

| Machine | Command |
| --- | --- |
| `MacBookApple` | `scripts/update_zygbook.sh` (add `--flake` to refresh inputs first) |
| `ZygizoOne` | `scripts/update_linux.sh` |
| `Ros` | `scripts/update_ros.sh` |
| `BodBook` | `scripts/update_bodbook.sh` |
| `homebook` | `scripts/link_config.sh` |

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
