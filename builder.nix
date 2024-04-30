{
  pkgs,
  replugged-src,
  discord ? null,
  extraElectronArgs ? "",
  discordPathSuffix ? "",
  mkPnpmPackage,
}: let
  selfOverlay = self;
  self = {
    replugged-unwrapped = pkgs.callPackage ./replugged-unwrapped.nix {
      inherit replugged-src mkPnpmPackage;
    };

    replugged = pkgs.callPackage ./replugged.nix {
      inherit (selfOverlay) replugged-unwrapped;
    };

    discord-plugged = pkgs.callPackage ./discord-plugged.nix {
      inherit extraElectronArgs discordPathSuffix;
      inherit (selfOverlay) replugged;
      discord =
        if discord != null
        then discord
        else pkgs.discord;
    };
  };
in
  self
