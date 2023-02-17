{ ghcVers ? "ghc925"
, dev ? true
}:

import ../cabal_template.nix { inherit dev ghcVers; }
