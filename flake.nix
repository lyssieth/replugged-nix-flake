{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    replugged.url = "github:replugged-org/replugged";
    replugged.flake = false;
    flake-utils.url = "github:numtide/flake-utils";
    pnpm2nix.url = "github:nzbr/pnpm2nix-nzbr";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pnpm2nix,
    ...
  } @ inputs: let
    replugged-src = inputs.replugged;
    builder = import ./builder.nix;
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    mkPnpmPackage = pnpm2nix.packages.x86_64-linux.mkPnpmPackage;
  in {
    lib = let
      self = {
        makeDiscordPluggedPackageSet = builder-args: builder ({inherit replugged-src mkPnpmPackage;} // builder-args);
        makeDiscordPlugged = args: (self.makeDiscordPluggedPackageSet args).discord-plugged;
      };
    in
      self;
    overlays.default = final: prev: (builder {
      inherit replugged-src;
      pkgs = final;
      overlayFinal = final;
    });
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
        builder {inherit pkgs replugged-src mkPnpmPackage;}
    );
  };
}
