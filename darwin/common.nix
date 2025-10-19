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
      unstable.kitty # terminal emulator
      unstable.ghostty-bin # Terminal emulator with multiplexer
      unstable.zed-editor # Editor for the modern age
      gh-dash # Github dashboard CLI
      sesh # Session manager for terminal applications
      gum # Command-line tool for interactive prompts
      helix # High-performance text editor
      tree-sitter # Incremental parsing system
      plantuml # uml drawing using text
      tmux # Terminal multiplexer
      zellij # Terminal multiplexer
      git # Version control system
      gh # GitHub CLI
      difftastic # Diff tool that understands syntax
      direnv # Environment switcher
      bat # Cat clone with syntax highlighting
      ripgrep # Line-oriented search tool
      age # Simple, modern encryption tool
      sshs # SSH server manager
      portal # Secure file transfer tool
      glow # Markdown renderer
      bottom # Resource monitor
      fd # Simple, fast and user-friendly alternative to find
      fzf # Command-line fuzzy finder
      eza # Modern replacement for ls
      gawk # GNU version of AWK
      raycast # Productivity tool
      jq # Command-line JSON processor
      yq # Command-line YAML processor
      lazygit # Simple terminal UI for git commands
      zsh # Z shell
      fish # Friendly interactive shell
      tldr # Simplified and community-driven man pages
      xh # Friendly and fast tool for sending HTTP requests
      wget # Network downloader
      xquartz # X Window System for macOS
      wezterm # GPU-accelerated terminal emulator
      devbox # Instant, easy, and predictable development environments
      devenv # Declarative development environments
      oh-my-posh # Prompt theme engine for any shell
      starship # Prompt for any shell
      zoxide # Smarter cd command
      dust # Disk Usage Summary
      duf # Disk Usage/Free Utility
      neofetch # System info script
      rustup # Rust toolchain installer
      toot # Mastodon tui client
      fedistar # Mastodon client
      colima # Docker container runtimes with minimal setup
      # opencode # AI code tool for developers; Install manually as it updates very frequently
      # usbimager # Write disk images to USB drives
    ];
  };

  fonts.packages = with pkgs; [
    # (nerdfonts.override { fonts = [ "Monaspace" ]; })
    nerd-fonts.monaspace
    nerd-fonts.blex-mono
    nerd-fonts.jetbrains-mono
  ];

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    casks = [
      "obsidian" # Note-taking and knowledge management app
    ];
  };

}
