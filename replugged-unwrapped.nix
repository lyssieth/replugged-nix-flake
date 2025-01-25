{
  lib,
  mkPnpmPackage,
  replugged-src,
  pkgs,
}:
(mkPnpmPackage {
  name = "replugged-unwrapped";
  src = replugged-src;
  script = "bundle --production --entryPoint=$build";
  distDir = "dist-bundle";
  installInPlace = true;

  nativeBuildInputs = [
    pkgs.cacert
    pkgs.pnpm
    pkgs.nodejs_22
  ];

  pnpm = pkgs.pnpm;
  installEnv = {
    "COREPACK_ENABLE_STRICT" = "0";
  };

  postInstall = ''
    cp replugged.asar $out/ || exit 1
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
