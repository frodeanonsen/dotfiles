#
#  MacOS Modules
#
#  flake.nix
#   └─ ./darwin
#       ├─ <host>.nix
#       └─ ./modules
#           ├─ default.nix *
#           └─ ...
#

[
  ./wezterm.nix
  # ./skhd.nix
  # ./yabai.nix
  # ./zsh.nix
  ../../modules/editors/nvim.nix
]
