{
  lib,
  mkPnpmPackage,
  replugged-src,
}:
(mkPnpmPackage {
  name = "replugged-unwrapped";
  src = replugged-src;
  script = "bundle --production --entryPoint=$src";
  distDir = "dist-bundle";
  installInPlace = false;

  buildPhase = ''
    runHook preBuild
    pnpm run bundle --production --entryPoint=$src
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
