# Repository Guidelines

## Project Structure & Module Organization

Configurations are defined through `flake.nix`, which wires together platform-specific modules in `darwin/` (macOS) and `linux/` (Home Manager) and exports the relevant flake outputs. Tool-specific overrides live under `config/<tool>/`. Helper scripts reside in `scripts/`. Keep machine-local data isolated (for example, `secret.yaml`).

## Build, Test, and Development Commands

./scripts is added to the path in `.envrc` and contains helper scripts to build and apply nix environments.
Refresh inputs via `nix flake update` before large changes. Build target systems with `darwin-rebuild build --flake .#<host>` (MacOS) or `home-manager build --flake .#<host>` (Linux). Apply macOS changes locally via `sudo darwin-rebuild switch --flake .#<host>`; Linux environments should run `sudo home-manager switch --flake .#<host>`. `nix flake check` lints the flake and should stay clean prior to pushing.

## Coding Style & Naming Conventions

Nix expressions use two-space indentation, compact attribute sets, and camelCase attribute names (`darwinConfigurations`, `homeConfigurations`). Reuse shared options by extracting them into helper modules instead of duplicating blocks. Shell utilities (see `update.sh`) stay POSIX-compliant; prefer lowercase command names and guard scripts with retries when touching system state.

## Testing Guidelines

After modifying configurations, run `nix flake check` and the relevant `nix build` target to surface evaluation errors early. For Darwin hosts, execute `darwin-rebuild switch --flake .#<host> --dry-run` first to review service diffs before applying. For Home Manager profiles, run `home-manager switch --flake .#<host> --dry-run` to validate activation plans. Aim to keep rebuilds warning-free and note any manual post-activation steps in module comments.

## Commit & Pull Request Guidelines

Commit messages in this repository are short, present-tense summaries (for example, `adds app audacity`). Group related configuration tweaks into a single commit so reviewers can reason about activation effects. Pull requests should describe the impacted hosts, list commands executed (`nix flake check`, rebuilds), and mention any follow-up manual steps or required secrets. Include screenshots only when UI-facing tweaks (e.g., SketchyBar, Aerospace) are changed.

## Security & Secrets

Never commit raw credentials; keep sensitive material in `secret.yaml` or host-level keychains managed outside the repo. When adding new secrets, document the retrieval path in private notes and gate usage with conditional logic so other hosts continue to evaluate cleanly.
