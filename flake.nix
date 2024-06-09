{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    replugged.url = "github:replugged-org/replugged";
    replugged.flake = false;
    flake-utils.url = "github:numtide/flake-utils";
    pnpm2nix = {
      url = "github:wrvsrx/pnpm2nix-nzbr/adapt-to-v9"; # until https://github.com/nzbr/pnpm2nix-nzbr/pull/40 is merged
      #url = "github:nzbr/pnpm2nix-nzbr";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pnpm2nix,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        replugged-src = inputs.replugged;
        builder = import ./builder.nix;
        mkPnpmPackage = pnpm2nix.packages."${system}".mkPnpmPackage;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        lib = let
          self = {
            makeDiscordPluggedPackageSet = builder-args: builder ({inherit replugged-src mkPnpmPackage;} // builder-args);
            makeDiscordPlugged = args: (self.makeDiscordPluggedPackageSet args).discord-plugged;
          };
        in
          self;

        packages =
          builder {inherit pkgs replugged-src mkPnpmPackage;};
      }
    );
}
