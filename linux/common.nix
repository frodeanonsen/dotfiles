{
  pkgs,
  vars,
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
      neovim # Hyperextensible Vim-based text editor
    ];
  };

}
