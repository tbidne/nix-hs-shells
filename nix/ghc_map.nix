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
      hlib = pkgs.haskell.lib;
      pkgs = getPkgs hash;
      wrapper =
        if warnMsg == null
        then x: x
        else x: pkgs.lib.warn warnMsg x;
    in
    {
      inherit pkgs unsupported versName;
      compiler =
        wrapper (pkgs.haskell.packages."${versName}".override {
          # compose inherited overrides w/ custom set below
          overrides = final: prev: (overrides final prev) // {
            # Conundrum: This package had failing tests on CI for GHC 9.4.4.
            # On the one hand, GHC 9.4.4 is not a priority as its caching is
            # poor and there are better, more recent versions.
            #
            # On the other hand, this could happen to a version we care about,
            # so we should probably do something about it.
            #
            # We could override hls to disable floskell as it is not a package
            # I personally care about. But that feels like a sticky situation,
            # providing hls w/ some plugins randomly disabled.
            #
            # Probably the best compromise is to simply disable tests suites as
            # needed.
            hls-floskell-plugin = hlib.dontCheck prev.hls-floskell-plugin;
          };
        });
    };

  warnPoorToolCache = vers:
    "GHC "
    + vers
    + " shell has poor caching with tools. Switch to a later version if possible.";

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

  ghc944 = mkSet {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc944";
    warnMsg = warnPoorToolCache "9.4.4";
  };

  ghc945 = mkSet { hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593"; versName = "ghc945"; };
  ghc946 = mkSet { hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593"; versName = "ghc946"; };
  ghc947 = mkSet { hash = "85f1ba3e51676fa8cc604a3d863d729026a6b8eb"; versName = "ghc947"; };
  ghc948 = mkSet { hash = "5a09cb4b393d58f9ed0d9ca1555016a8543c2ac8"; versName = "ghc948"; };

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
    warnMsg = warnPoorToolCache "9.6.1";
  };

  ghc962 = mkSet {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc962";
    overrides = _: prev: {
      fourmolu = prev.fourmolu_0_13_1_0;
      hlint = prev.hlint_3_6_1;
      ormolu = prev.ormolu_0_7_2_0;
    };
  };

  ghc963 = mkSet {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc963";
    overrides = _: prev: {
      fourmolu = prev.fourmolu_0_13_1_0;
      hlint = prev.hlint_3_6_1;
      ormolu = prev.ormolu_0_7_2_0;
    };
  };

  ghc964 = mkSet {
    hash = "2726f127c15a4cc9810843b96cad73c7eb39e443";
    versName = "ghc964";
  };

  ghc965 = mkSet {
    hash = "25865a40d14b3f9cf19f19b924e2ab4069b09588";
    versName = "ghc965";
  };

  # NOTE: We could upgrade this hash to 25865a40d14b3f9cf19f19b924e2ab4069b09588
  # -- what ghc982 currently uses -- and then we'd get apply-refact.
  # However ghc981's caching is terrible with that hash, so we judge that the
  # better caching is worth giving up apply-refact.
  ghc981 = mkSet {
    hash = "2726f127c15a4cc9810843b96cad73c7eb39e443";
    versName = "ghc981";
    overrides = _: prev: {
      fourmolu = prev.fourmolu_0_14_1_0;
      hlint = prev.hlint_3_8;
      ormolu = prev.ormolu_0_7_3_0;
    };

    unsupported = [
      "applyRefact"
    ];
    warnMsg = "GHC 9.8.1 shell has poor tool caching and does not support applyRefact.";
  };

  ghc982 = mkSet {
    hash = "25865a40d14b3f9cf19f19b924e2ab4069b09588";
    versName = "ghc982";
    overrides = _: prev: {
      apply-refact = prev.apply-refact_0_14_0_0;
      fourmolu = prev.fourmolu_0_15_0_0;
      hlint = prev.hlint_3_8;
      ormolu = prev.ormolu_0_7_4_0;
    };
  };
}
