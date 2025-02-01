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
      nixfmt-rfc-style
      vim
      neovim
      tree-sitter
      tmux
      git
      gh
      direnv
      bat
      ripgrep
      age
      sshs
      portal
      glow
      btop
      fd
      fzf
      eza
      gawk
      raycast
      jq
      yq
      lazygit
      zsh
      tldr
      xh
      wget
      xquartz
      wezterm
      devbox
      oh-my-posh
      zoxide
      dust # Disk Usage Summary
      duf # Disk Usage/Free Utility
    ];
  };

  fonts.packages = with pkgs; [
    # (nerdfonts.override { fonts = [ "Monaspace" ]; })
    monaspace
  ];

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "nikitabobko/tap"
      "cfergeau/crc"
      "FelixKratz/formulae"
    ];

    casks = [
      "obsidian"
      "zen-browser"
    ];
  };

}
