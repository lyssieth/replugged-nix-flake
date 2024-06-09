{
  lib,
  mkPnpmPackage,
  replugged-src,
  pkgs,
}:
(mkPnpmPackage {
  name = "replugged-unwrapped";
  src = replugged-src;
  script = "bundle --production --entryPoint=$src";
  distDir = "dist-bundle";
  installInPlace = true;

  pnpm = pkgs.pnpm;
  installEnv = {
    "COREPACK_ENABLE_STRICT" = "0";
  };

  postInstall = ''
    cp /build/source/replugged.asar $out/
  '';

  meta = {
    homepage = "https://replugged.dev";
    license = lib.licenses.mit;
    description = "A lightweight Discord mod focused on simplicity and performance";
  };
})
.overrideAttrs (_: {
  doDist = false;
})
