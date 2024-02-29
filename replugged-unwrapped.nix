{
  lib,
  mkPnpmPackage,
  replugged-src,
}:
(mkPnpmPackage {
  name = "replugged-unwrapped";
  src = replugged-src;
  script = "bundle --production";
  distDir = "dist-bundle";
  installInPlace = true;

  patches = [
    ./patches/replugged-injector.patch
  ];

  buildPhase = ''
    export NIX_EXPECTED_ASAR=$src
    runHook preBuild
    pnpm run bundle --production
    runHook postBuild
  '';

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
