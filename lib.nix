# Provides common utilities

let
  showKeys = attrs:
    let attrKeys = builtins.attrNames attrs;
    in builtins.concatStringsSep ", " attrKeys;

  lookupOrDie = mp: key: keyName:
    if mp ? ${key}
    then mp.${key}
    else throw "Invalid ${keyName}: '${key}'; valid keys are ${showKeys mp}.";

  # Returns a list of dev tools, depending on the arguments.
  mkDev = compiler: devTools: pkgs:
    let
      hlsTools =
        if devTools.hls
        then [ (pkgs.haskell.lib.dontCheck compiler.haskell-language-server) ]
        else [ ];
    in
    hlsTools;
in
{
  inherit mkDev;

  # Retrieves nixpkgs corresponding to the given ghc version.
  getPkgs = ghcVers:
    let
      # In general, the hash for ghc vers N should be the latest commit C where
      # N was still the default ghc, since this is the point where the most
      # packages in nixpkgs will be compatible with N by default.
      #
      # However, some versions will not have any such C as they were never a
      # default e.g. ghc928 was released after 9.4.X was already the default.
      # For those, just take the earliest hash when they were added.
      #
      # Notice this means we sometimes _update_ an existing hash e.g.
      #
      #   1. The default ghc N has not changed. In this case, we can update
      #      N and any newer GHCs to the latest hash.
      #   2. The default ghc N _has_ changed. In this case we will not change
      #      N, but any newer GHC hashes should be updated.
      #
      # NOTE: These hashes should come from nixos-unstable for caching purposes.
      ghcToNixpkgs = {
        ghc8107 = "d0d55259081f0b97c828f38559cad899d351cad1";
        ghc902 = "d0d55259081f0b97c828f38559cad899d351cad1";
        ghc925 = "d0d55259081f0b97c828f38559cad899d351cad1";
        ghc926 = "d0d55259081f0b97c828f38559cad899d351cad1";
        ghc927 = "3c5319ad3aa51551182ac82ea17ab1c6b0f0df89";
        ghc928 = "75a5ebf473cd60148ba9aec0d219f72e5cf52519";
        ghc944 = "7c656856e9eb863c4d21c83e2601dd77f95f6941";
        ghc945 = "75a5ebf473cd60148ba9aec0d219f72e5cf52519";
        ghc961 = "75a5ebf473cd60148ba9aec0d219f72e5cf52519";
        ghc962 = "75a5ebf473cd60148ba9aec0d219f72e5cf52519";
      };
      hash = lookupOrDie ghcToNixpkgs ghcVers "ghcVers";
    in
    import
      (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz";
      })
      { };
}
