(
  import (
    builtins.fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
      sha256 = "sha256:0m9grvfsbwmvgwaxvdzv6cmyvjnlww004gfxjvcl806ndqaxzy4j";
    }
  ) {
    src = ./.;
  }
)
.defaultNix
