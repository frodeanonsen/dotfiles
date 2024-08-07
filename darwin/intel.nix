#
#  Specific system configuration settings for MacBook 8,1
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       └─ ./intel.nix *
#

{ pkgs, ... }:

{
  networking = {
    computerName = "Gammal-MacBook";
    hostName = "GammalMacBook";
  };

  skhd.enable = true;
  yabai.enable = true;

  homebrew = {
    brews = [
      # "wireguard-tools"
    ];
    casks = [
      "podman"
      "virtualbox" # sudo codesign --force --deep --sign - /Applications/VirtualBox.app/Contents/Resources/VirtualBoxVM.app
    ];
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.keyboard.fnState" = true;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.trackpad.enableSecondaryClick" = true;
      };
      dock = {
        autohide = true;
        largesize = 36;
        tilesize = 24;
        magnification = true;
        mineffect = "genie";
        orientation = "left";
        showhidden = false;
        show-recents = false;
        minimize-to-application = true;
      };
      finder = {
        AppleShowAllFiles = false;
        ShowPathbar = true;
        QuitMenuItem = false;
      };
      keyboard = {
        remapCapsLockToEscape = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
      # magicmouse = {
      #   MouseButtonMode = "TwoButton";
      # };
      # CustomUserPreferences = {
      # # ~/Library/Preferences/
      # }
      # CustomSystemPreferences = {
      # # ~/Library/Preferences/
      # }
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh'';
    # # Reload all settings without relog/reboot
    # activationScripts.postUserActivation.text = ''
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';
  };
}
