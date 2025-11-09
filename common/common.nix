# common/common.nix
#
# Common Home Manager configuration shared across all systems (Darwin and Linux)
# This module imports all application configurations from the apps directory

{
  pkgs,
  inputs,
  system,
  ...
}:

{
  imports = [
    ./apps/firefox.nix
    # Add more app configurations here as they are created
    # ./apps/vscode.nix
    # ./apps/alacritty.nix
    # etc...
  ];
}
