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
    , warnMsg ? null
    }:
    let
      pkgs = getPkgs hash;
      wrapper =
        if warnMsg == null
        then x: x
        else x: pkgs.lib.warn warnMsg x;
    in
    {
      inherit pkgs unsupported versName;
      compiler =
        wrapper (pkgs.haskell.packages."${versName}".override { inherit overrides; });
    };

  # Var for the latest hash as there are several shells that will want it
  # (e.g. most that are > the current default).
  latest = "85f1ba3e51676fa8cc604a3d863d729026a6b8eb";

  # NOTE: We do not always need to override tools even though the default is
  # not what we want.
  #
  # For example, the current ghc 9.4 nixpkgs hash we use has the default
  # hlint-3.4 (ghc 9.2) whereas we want hlint-3.5. We could explicitly
  # override this, but in fact this is already done in nixpkgs in
  # configuration-ghc-9.4.x.nix.
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
    hash = latest;
    versName = "ghc944";
    warnMsg = "GHC 9.4.4 has poor caching with tools. Switch to a later version if possible.";
  };
  ghc945 = mkSet {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc945";
  };
  ghc946 = mkSet {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc946";
  };
  ghc947 = mkSet {
    hash = latest;
    versName = "ghc947";
  };
  ghc961 = mkSet {
    # Older hash as newer hash does not contain ghc961. Sadly this means we
    # cannot use hlint as this nixpkgs does not have hlint_3_6. We need to
    # overrride it manually e.g. with callHackage.
    hash = "1c9db9710cb23d60570ad4d7ab829c2d34403de3";
    versName = "ghc961";
    overrides = final: prev: {
      apply-refact = prev.apply-refact_0_13_0_0;
      fourmolu = prev.fourmolu_0_12_0_0;
      ormolu = prev.ormolu_0_7_1_0;

      hlint =
        (final.callHackageDirect
          {
            pkg = "hlint";
            ver = "3.6.1";
            sha256 = "sha256-fH4RYnWeuBqJI5d3Ba+Xs0BxYr0IYFH1OWO3k2iHGlU=";
          }
          { });
    };
    warnMsg = "GHC 9.6.1 shell has poor caching with hlint. Switch to a later version if possible.";
  };
  ghc962 = mkSet {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc962";
    overrides = _: prev: {
      fourmolu = prev.fourmolu_0_14_0_0;
      hlint = prev.hlint_3_6_1;
      ormolu = prev.ormolu_0_7_2_0;
    };
  };
  ghc963 = mkSet {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc963";
    overrides = _: prev: {
      fourmolu = prev.fourmolu_0_14_0_0;
      hlint = prev.hlint_3_6_1;
      ormolu = prev.ormolu_0_7_2_0;
    };
  };

  ghc981 = mkSet {
    hash = latest;
    versName = "ghc981";
    unsupported = [
      "applyRefact"
      "fourmolu"
      "hlint"
      "hls"
      "ormolu"
    ];
    warnMsg = "GHC 9.8.1 does not currently support any extra tools.";
  };
}
