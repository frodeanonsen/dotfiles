{
  pkgs,
  vars,
  unstable,
  ...
}:

{
  environment = {
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
      nixfmt-rfc-style # Nix code formatter
      vim # Text editor
      unstable.neovim # Hyperextensible Vim-based text editor
      unstable.alacritty-graphics # terminal emulator
      unstable.ghostty-bin # Terminal emulator with multiplexer
      unstable.zed-editor # Editor for the modern age
      onedrive # Microsoft OneDrive
    ];
  };

}
