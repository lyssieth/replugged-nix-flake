{
  lib,
  replugged-unwrapped,
  stdenvNoCC,
}: let
  unwrapped = replugged-unwrapped;
in
  stdenvNoCC.mkDerivation {
    name = "replugged";
    src = unwrapped.out;

    installPhase = ''
      cp -a $src $out
      chmod 755 $out
    '';

    passthru.unwrapped = unwrapped;
    meta =
      unwrapped.meta
      // {
        priority = (unwrapped.meta.priority or 0) - 1;
      };
  }
