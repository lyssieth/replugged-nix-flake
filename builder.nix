{
  pkgs,
  replugged-src,
  discord ? null,
  themes ? {},
  plugins ? {},
  extraElectronArgs ? "",
  discordPathSuffix ? "",
  overlayFinal ? null,
  withOpenAsar ? false,
  mkPnpmPackage,
}: let
  overlayFinalorSelf =
    if (overlayFinal == null)
    then self
    else overlayFinal;
  self = {
    replugged-unwrapped = pkgs.callPackage ./replugged-unwrapped.nix {
      inherit replugged-src mkPnpmPackage;
    };

    replugged = pkgs.callPackage ./replugged.nix {
      inherit (overlayFinalorSelf) replugged-unwrapped;
      withPlugins = plugins;
      withThemes = themes;
    };

    discord-plugged = pkgs.callPackage ./discord-plugged.nix {
      inherit extraElectronArgs discordPathSuffix withOpenAsar;
      inherit (overlayFinalorSelf) replugged;
      discord =
        if discord != null
        then discord
        else pkgs.discord;
    };
  };
in
  self
