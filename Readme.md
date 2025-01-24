# Frodes Dotfiles and system configuration

This is mainly a backup of my dotfiles and system configuration files. It is
tailored to my needs and preferences, but feel free to use it as a reference or
inspiration for your own configuration.

The configuration is based on NixOS, which is a declarative system
configuration tool. I have been inspired by many other dotfiles repositories,
but I have tried to make this configuration as minimal as possible. Here are
the main references that I have used:

- [NixOS](https://nixos.org/)
- [Home Manager](https://nix-community.github.io/home-manager/options.xhtml)
- [Nix Darwin](https://github.com/LnL7/nix-darwin)
- [MatthiasBenaets/nix-config](https://github.com/MatthiasBenaets/nix-config)
- [omerxx/dotfiles](https://github.com/omerxx/dotfiles)

## Installation

Install NixOS and clone this repository to your home directory.

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/frodeanonsen/dotfiles ~/.dotfiles
```

Build the system configuration and switch to it.

Example, Darwin:

```sh
nix build .#darwinConfigurations.MacBookApple.system
./result/sw/bin/darwin-rebuild switch --flake .#MacBookApple
```

Example, Linux:

```sh
nix build .#homeConfigurations.Ros.system
./result/sw/bin/darwin-rebuild switch --flake .#Ros
```

Example, in a home-manager shell:

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install

home-manager switch --flake .#Ros
```

## Rebuiling the system

```sh
cd ~/.dotfiles
./update.sh
```
