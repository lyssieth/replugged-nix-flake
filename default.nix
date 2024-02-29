(
  import (
    builtins.fetchTree {
      type = "github";
      owner = "edolstra";
      repo = "flake-compat";
      rev = "0f9255e01c2351cc7d116c072cb317785dd33b33";
    }
  ) {
    src = ./.;
  }
)
.defaultNix
