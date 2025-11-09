# Common Configuration

This directory contains Home Manager configurations that are shared across all systems (both Darwin/macOS and Linux).

## Structure

```
common/
├── common.nix          # Main module that imports all app configurations
├── apps/               # Application-specific configurations
│   ├── firefox.nix     # Firefox browser configuration
│   └── ...             # More app configs to be added
└── README.md           # This file
```

## Usage

### In Darwin (macOS) configurations

Import the common module in your darwin configuration:

```nix
home-manager.users.${vars.user} = {
  imports = [
    ../common/common.nix
  ];
};
```

### In Linux configurations

Import the common module in your home-manager configuration:

```nix
imports = [
  ../common/common.nix
];
```

## Adding New Applications

To add a new application configuration:

1. Create a new file in `apps/` directory (e.g., `apps/vscode.nix`)
2. Add your Home Manager configuration for that app
3. Import it in `common.nix`:

```nix
imports = [
  ./apps/firefox.nix
  ./apps/vscode.nix  # Your new app
  # ...
];
```

## Requirements

Applications configured here must:
- Be Home Manager modules (not nix-darwin or NixOS modules)
- Work cross-platform (both Darwin and Linux) or handle platform differences internally
- Accept the following parameters: `pkgs`, `inputs`, `system`

## Current Applications

- **Firefox**: Web browser with custom search engines, bookmarks, security settings, and extensions