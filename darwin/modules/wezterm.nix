{
  config,
  lib,
  system,
  pkgs,
  unstable,
  vars,
  ...
}:

{
  homebrew = {
    casks = [
      "wezterm"
    ];
  };

}
