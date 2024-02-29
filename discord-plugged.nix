{
  lib,
  symlinkJoin,
  discord,
  replugged,
  makeBinaryWrapper,
  writeShellScript,
  extraElectronArgs ? "",
  discordPathSuffix ? "",
  withOpenAsar ? false,
}: let
  extractCmd =
    makeBinaryWrapper.extractCmd
    or (writeShellScript "extract-binary-wrapper-cmd" ''
      strings -dw "$1" | sed -n '/^makeCWrapper/,/^$/ p'
    '');
  openAsar = builtins.fetchUrl {
    name = "app.asar";
    url = "https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar";
    sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
  };
in
  symlinkJoin {
    name = "discord-plugged";
    paths = [discord.out];

    nativeBuildInputs = [makeBinaryWrapper];

    postBuild =
      ''
        mv $out/opt/Discord${discordPathSuffix}/resources/app.asar $out/opt/Discord${discordPathSuffix}/resources/app.orig.asar

        mkdir $out/opt/Discord${discordPathSuffix}/resources/app.asar
        echo "require(\"${replugged.out}/replugged.asar\")" > $out/opt/Discord${discordPathSuffix}/resources/app.asar/index.js
        echo '{"main": "index.js", "name": "discord"}' > $out/opt/Discord${discordPathSuffix}/resources/app.asar/package.json

        cp -a --remove-destination $(readlink "$out/opt/Discord${discordPathSuffix}/.Discord${discordPathSuffix}-wrapped") "$out/opt/Discord${discordPathSuffix}/.Discord${discordPathSuffix}-wrapped"
        cp -a --remove-destination $(readlink "$out/opt/Discord${discordPathSuffix}/Discord${discordPathSuffix}") "$out/opt/Discord${discordPathSuffix}/Discord${discordPathSuffix}"

        if grep '\0' $out/opt/Discord${discordPathSuffix}/Discord${discordPathSuffix} && wrapperCmd=$(${extractCmd} $out/opt/Discord${discordPathSuffix}/Discord${discordPathSuffix}) && [[ $wrapperCmd ]]; then
          # Binary wrapper
          parseMakeCWrapperCall() {
            shift # makeCWrapper
            oldExe=$1; shift
            oldWrapperArgs=("$@")
          }
          eval "parseMakeCWrapperCall ''${wrapperCmd//"${discord.out}"/"$out"}"
          # Binary wrapper
          makeWrapper $oldExe $out/opt/Discord${discordPathSuffix}/Discord${discordPathSuffix} "''${oldWrapperArgs[@]}" --add-flags "${extraElectronArgs}"
        else
          # Normal wrapper
          substituteInPlace $out/opt/Discord${discordPathSuffix}/Discord${discordPathSuffix} \
            --replace '${discord.out}' "$out" \
            --replace '"$@"' '${extraElectronArgs} "$@"'
        fi

        substituteInPlace $out/opt/Discord${discordPathSuffix}/Discord${discordPathSuffix} --replace '${discord.out}' "$out"
      ''
      + (lib.optionalString withOpenAsar ''
        rm $out/opt/Discord${discordPathSuffix}/resources/app.asar
        cp ${openAsar} $out/opt/Discord${discordPathSuffix}/resources/app.asar
      '');

    meta.mainProgram =
      if (discord.meta ? mainProgram)
      then discord.meta.mainProgram
      else null;
  }
