(
  import (
    builtins.fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
      sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    }
  ) {
    src = ./.;
  }
)
.defaultNix
