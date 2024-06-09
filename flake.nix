{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    replugged.url = "github:replugged-org/replugged/d1e4b4da2c8432cc35c195b5418ce038db824526";
    replugged.flake = false;
    flake-utils.url = "github:numtide/flake-utils";
    pnpm2nix = {
      url = "github:nzbr/pnpm2nix-nzbr";
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
