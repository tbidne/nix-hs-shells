let
  getPkgs = hash: import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz";
    })
    { };

  mkSet =
    { hash
    , versName
    , overrides ? _: _: { }
    , unsupported ? [ ]
    }:
    let pkgs = getPkgs hash;
    in
    {
      inherit pkgs unsupported versName;
      compiler = pkgs.haskell.packages."${versName}".override { inherit overrides; };
    };

  applyRefact_0_11 = _: prev: { apply-refact = prev.apply-refact_0_11_0_0; };

  fourmolu_0_12-ormolu_0_7 = _: prev: {
    fourmolu = prev.fourmolu_0_12_0_0;
    ormolu = prev.ormolu_0_7_0_0;
  };
in
{
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
  # These hashes should come from nixos-unstable for caching purposes.

  ghc8107 = mkSet { hash = "6d28139e80dd2976650c6356269db942202e7c90"; versName = "ghc8107"; };
  ghc902 = mkSet { hash = "a7855f2235a1876f97473a76151fec2afa02b287"; versName = "ghc902"; };
  ghc925 = mkSet { hash = "d0d55259081f0b97c828f38559cad899d351cad1"; versName = "ghc925"; };
  ghc926 = mkSet { hash = "d0d55259081f0b97c828f38559cad899d351cad1"; versName = "ghc926"; };
  ghc927 = mkSet { hash = "3c5319ad3aa51551182ac82ea17ab1c6b0f0df89"; versName = "ghc927"; };
  ghc928 = mkSet { hash = "75a5ebf473cd60148ba9aec0d219f72e5cf52519"; versName = "ghc928"; };

  # NOTE: GHCs below here non-defaults so hashes are subject to change.

  # NOTE: ghc944 builds 338 packages vs. fetching 584. This is obviously
  # not great, so it would be nice if we could find a better hash.
  #
  # Also, why does it require so many more packages (900!) compared to
  # everything else (around 600-700)?
  #
  # Both ghc961 and ghc962 build 55 vs. 627 fetched, which is reasonable.

  ghc944 = mkSet {
    hash = "2c330a5d05a476b3340247c2e7c25cd00b669b81";
    versName = "ghc944";
    overrides = applyRefact_0_11;
  };
  ghc945 = mkSet {
    hash = "75a5ebf473cd60148ba9aec0d219f72e5cf52519";
    versName = "ghc945";
    overrides = applyRefact_0_11;
  };
  ghc961 = mkSet {
    hash = "75a5ebf473cd60148ba9aec0d219f72e5cf52519";
    versName = "ghc961";
    overrides = fourmolu_0_12-ormolu_0_7;
    unsupported = [ "applyRefact" "hlint" ];
  };
  ghc962 = mkSet {
    hash = "75a5ebf473cd60148ba9aec0d219f72e5cf52519";
    versName = "ghc962";
    overrides = fourmolu_0_12-ormolu_0_7;
    unsupported = [ "applyRefact" "hlint" ];
  };
}