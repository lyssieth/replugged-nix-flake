# Nix Flake for `Replugged`

This is a Nix flake that allows installing a [Replugged](https://github.com/replugged-org/replugged)-injected [Discord](https://discord.com).

It's based on the work of [LunNova/replugged-nix-flake](https://github.com/LunNova/replugged-nix-flake), but working with the current (as of 03-2024) iteration of Replugged.

## Updates

I'll keep this updated as I need it, but if you want an update either submit an Issue or a PR.

## Usage

Should be equivalent to LunNova's.

Or you can try my garbage setup.

### How I Use It, This Might Not Work For You

This is the minimum parts that I've yoinked from my own laptop's configuration. This probably isn't that great, but it Works On My Machine™.

```nix
# $HOME/.config/home-manager/flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    replugged-nix-flake = {
      url = "github:lyssieth/replugged-nix-flake";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    home-manager,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      extraSpecialArgs = {inherit inputs;};
    in {
      packages = {
        # Replace `username` and `hostname` with yours.
        homeConfigurations."username@hostname" = home-manager.lib.homeManagerConfiguration { 
          inherit pkgs extraSpecialArgs;

          modules = [
            (import ./hostname.nix) # replace hostname with yours, or do it your own way
          ];
        };
      };
    });
}
```

```nix
# $HOME/.config/home-manager/hostname.nix # replace hostname with yours :3
{
  inputs,
  pkgs,
  ...
}: let
  system = "x86_64-linux"; # or whatever system you use. theoretically should work elsewhere, but I only have x86_64.
  replugged-nix-flake = inputs.replugged-nix-flake;
in {
  home.packages = [
    (replugged-nix-flake.lib.makeDiscordPlugged {
      inherit pkgs;
      discord = pkgs.discord; # can be replaced with ptb or canary here, I think
    })
  ];
}

```
