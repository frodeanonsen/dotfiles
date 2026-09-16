# Repository Guidelines

## Project Structure & Module Organization

Configurations are defined through `flake.nix`, which wires together platform-specific modules in `darwin/` (macOS) and `linux/` (Home Manager) and exports the relevant flake outputs. Tool-specific overrides live under `config/<tool>/`. Helper scripts reside in `scripts/`. Keep machine-local data isolated (for example, `secret.yaml`).

This repo is shared across several machines and is the union of what all of them need; each machine links only the subset that applies to it. A directory under `config/` being present does not mean it is active on the machine you are working on. Not every machine uses nix: the Omarchy host `homebook` has no nix and is provisioned by `scripts/link_config.sh` instead of a flake output. See `README.md` for the machine inventory and for the distinction between `config/` dirs that get symlinked into `~/.config` and the shell topic dirs (`config/*/*.zsh`, `config/*/*.fish`) that are sourced straight out of `$DOTFILES` and must never be symlinked.

## Build, Test, and Development Commands

`scripts/` contains helper scripts to build and apply environments; invoke them by path (`scripts/update_linux.sh`), they are not on `$PATH`.
Refresh inputs via `nix flake update` before large changes. Build target systems with `darwin-rebuild build --flake .#<host>` (MacOS) or `home-manager build --flake .#<host>` (Linux). Apply macOS changes locally via `sudo darwin-rebuild switch --flake .#<host>`; Linux environments should run `sudo home-manager switch --flake .#<host>`. `nix flake check` lints the flake and should stay clean prior to pushing.
For the local macOS host backed by `.#MacBookApple`, prefer `scripts/update_zygbook.sh` for rebuilds and updates instead of invoking `darwin-rebuild switch` directly. Use `scripts/update_zygbook.sh --flake` when you also want to refresh flake inputs before rebuilding.

## Coding Style & Naming Conventions

Nix expressions use two-space indentation, compact attribute sets, and camelCase attribute names (`darwinConfigurations`, `homeConfigurations`). Reuse shared options by extracting them into helper modules instead of duplicating blocks. Shell utilities use tab indentation and open with a `--help` block when they take options (see `scripts/update_zygbook.sh`); the `update_*` scripts target `/usr/bin/env sh`, the rest bash. Prefer lowercase command names and guard scripts with retries when touching system state.

## Testing Guidelines

After modifying configurations, run `nix flake check` and the relevant `nix build` target to surface evaluation errors early. `nix flake check` does not cover `config/` or `scripts/`, so a change that only affects a non-nix machine needs testing on that machine; for linking changes use `scripts/link_config.sh --dry-run`, which reports what would change without touching anything. For Darwin hosts, execute `darwin-rebuild switch --flake .#<host> --dry-run` first to review service diffs before applying. For Home Manager profiles, run `home-manager switch --flake .#<host> --dry-run` to validate activation plans. Aim to keep rebuilds warning-free and note any manual post-activation steps in module comments.

## Commit & Pull Request Guidelines

Commit messages in this repository are short, present-tense summaries (for example, `adds app audacity`). Group related configuration tweaks into a single commit so reviewers can reason about activation effects. Pull requests should describe the impacted hosts, list commands executed (`nix flake check`, rebuilds), and mention any follow-up manual steps or required secrets. Include screenshots only when UI-facing tweaks (e.g., SketchyBar, Aerospace) are changed.

## Security & Secrets

Never commit raw credentials; keep sensitive material in `secret.yaml` or host-level keychains managed outside the repo. When adding new secrets, document the retrieval path in private notes and gate usage with conditional logic so other hosts continue to evaluate cleanly.
