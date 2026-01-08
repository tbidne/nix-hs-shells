let
  getPkgs =
    hash:
    import (fetchTarball { url = "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz"; }) { };

  mkSet =
    {
      hash,
      versName,
      overrides ?
        _: _: _:
        { },
      poorGhcCache ? false,
      poorToolCache ? [ ],
      unstableHash ? false,
      unsupported ? [ ],
      warnings ? [ ],
    }:
    let
      hlib = pkgs.haskell.lib;
      pkgs = getPkgs hash;

      # Combines fixed warnings with general custom warning into a bulleted
      # list of warnings.
      allWarnings =
        let
          poorGhcCacheMsg = if poorGhcCache then "This GHC has poor caching." else null;

          poorToolCacheWarnMsg =
            if poorToolCache == [ ] then
              null
            else
              "Tool(s) have poor caching: " + builtins.concatStringsSep ", " poorToolCache;

          unstableHashWarnMsg =
            if unstableHash then "The hash is unstable i.e. this may change in the future." else null;

          unsupportedWarnings =
            if unsupported == [ ] then
              null
            else
              "Unsupported tool(s): " + builtins.concatStringsSep ", " unsupported;

          composeWarnings =
            msgs:
            let
              go = acc: m: if m != null then acc + "\n - " + m else acc;
            in
            builtins.foldl' go "" msgs;
        in
        composeWarnings (
          [
            poorGhcCacheMsg
            poorToolCacheWarnMsg
            unstableHashWarnMsg
            unsupportedWarnings
          ]
          ++ warnings
        );
      wrapper = if allWarnings == "" then x: x else x: pkgs.lib.warn allWarnings x;
    in
    {
      inherit pkgs unsupported versName;
      compiler = wrapper (
        pkgs.haskell.packages."${versName}".override {
          # compose inherited overrides w/ custom set below
          overrides =
            final: prev:
            (overrides hlib final prev)
            // {
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
        }
      );
    };

  # In general, the hash for ghc vers N should be a commit C where N has
  # good caching for every tool. The best candidates are commits where N is
  # the default ghc.
  #
  # However, some versions will not have any such C as they were never a
  # default e.g. ghc928 was released after 9.4.X was already the default.
  # For those, just take the earliest hash when they were added.
  #
  # When we have a choice, in theory it makes sense to take the latest commit
  # possible, since it is more likely that later hashes will be compatible
  # with more packages (because maintainers will have had more time to make
  # their packages compatible).
  #
  # In practice, simply taking the first hash that gives us good caching and
  # tool compatibility is good enough and means we don't have to keep updating
  # hashes just in case a later one is "better". Thus we generally only
  # update an existing hash when the newer hash offers better caching / fixes
  # some tool.
  #
  # These hashes should come from nixos-unstable for caching purposes.
  #
  # Regarding hash stability, a hash should only be unstable when it has some
  # deficiency (e.g. caching, some tool doesn't work), and we have a good
  # reason to expect that will be improved in the future. Therefore there may
  # be shells that doesn't work as well as we like, but they might still be
  # considered stable if they are unlikely to improve (e.g. they are old
  # and nixpkgs is unlikely to ever offer a better one).

  # NOTE: We do not always need to override tools even though the default is
  # not what we want.
  #
  # For example, the current ghc 9.4 nixpkgs hash we use has the default
  # hlint-3.4 (ghc 9.2) whereas we want hlint-3.5. We could explicitly
  # override this, but in fact this is already done in nixpkgs in
  # configuration-ghc-9.4.x.nix.

  # ######################################################################### #
  #                                   GHC 8                                   #
  # ######################################################################### #

  # NOTE: [GHC Aliases]
  #
  # Aliases should refer to the latest "good" compiler, where good means it has
  # fast caching with all tools, if possible. In general, aliases are only
  # considered stable when no further GHC releases are planned in that series.
  #
  # https://gitlab.haskell.org/ghc/ghc/-/wikis/GHC%20Status
  #
  # When an alias is updated, we need to update ci.sh.
  ghc8Attrs = ghc810Attrs;

  # ######################################################################### #
  #                                  GHC 8.10                                 #
  # ######################################################################### #

  ghc810Attrs = ghc8107Attrs;

  ghc8107Attrs = {
    hash = "6d28139e80dd2976650c6356269db942202e7c90";
    versName = "ghc8107";
  };

  # ######################################################################### #
  #                                   GHC 9                                   #
  # ######################################################################### #

  # TODO: Switch when ghc912 / ghc914 improves.
  #
  # See NOTE: [GHC Aliases]
  ghc9Attrs = ghc912Attrs // {
    unstableHash = true;
  };

  # ######################################################################### #
  #                                  GHC 9.0                                  #
  # ######################################################################### #

  ghc90Attrs = ghc902Attrs;

  ghc902Attrs = {
    hash = "a7855f2235a1876f97473a76151fec2afa02b287";
    versName = "ghc902";
  };

  # ######################################################################### #
  #                                  GHC 9.2                                  #
  # ######################################################################### #

  ghc92Attrs = ghc928Attrs;

  ghc925Attrs = {
    hash = "d0d55259081f0b97c828f38559cad899d351cad1";
    versName = "ghc925";
  };

  ghc926Attrs = {
    hash = "d0d55259081f0b97c828f38559cad899d351cad1";
    versName = "ghc926";
  };

  ghc927Attrs = {
    hash = "3c5319ad3aa51551182ac82ea17ab1c6b0f0df89";
    versName = "ghc927";
  };

  ghc928Attrs = {
    hash = "75a5ebf473cd60148ba9aec0d219f72e5cf52519";
    versName = "ghc928";
  };

  # ######################################################################### #
  #                                  GHC 9.4                                  #
  # ######################################################################### #

  ghc94Attrs = ghc948Attrs;

  ghc944Attrs = {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc944";
    poorGhcCache = true;
  };

  ghc945Attrs = {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc945";
  };

  ghc946Attrs = {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc946";
  };

  ghc947Attrs = {
    hash = "85f1ba3e51676fa8cc604a3d863d729026a6b8eb";
    versName = "ghc947";
  };

  ghc948Attrs = {
    hash = "5a09cb4b393d58f9ed0d9ca1555016a8543c2ac8";
    versName = "ghc948";
  };

  # ######################################################################### #
  #                                  GHC 9.6                                  #
  # ######################################################################### #

  ghc96Attrs = ghc967Attrs;

  ghc961Attrs = {
    # Older hash as newer hash does not contain ghc961. Sadly this means we
    # cannot use hlint as this nixpkgs does not have hlint_3_6. We need to
    # overrride it manually e.g. with callHackage.
    hash = "1c9db9710cb23d60570ad4d7ab829c2d34403de3";
    versName = "ghc961";
    overrides = _: final: prev: {
      apply-refact = prev.apply-refact_0_13_0_0;
      fourmolu = prev.fourmolu_0_12_0_0;
      ormolu = prev.ormolu_0_7_1_0;

      hlint = (
        final.callHackageDirect {
          pkg = "hlint";
          ver = "3.6.1";
          sha256 = "sha256-fH4RYnWeuBqJI5d3Ba+Xs0BxYr0IYFH1OWO3k2iHGlU=";
        } { }
      );
    };
    poorGhcCache = true;
  };

  ghc962Attrs = {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc962";
    overrides = _: _: prev: {
      fourmolu = prev.fourmolu_0_13_1_0;
      hlint = prev.hlint_3_6_1;
      ormolu = prev.ormolu_0_7_2_0;
    };
  };

  ghc963Attrs = {
    hash = "5e4c2ada4fcd54b99d56d7bd62f384511a7e2593";
    versName = "ghc963";
    overrides = _: _: prev: {
      fourmolu = prev.fourmolu_0_13_1_0;
      hlint = prev.hlint_3_6_1;
      ormolu = prev.ormolu_0_7_2_0;
    };
  };

  ghc964Attrs = {
    hash = "2726f127c15a4cc9810843b96cad73c7eb39e443";
    versName = "ghc964";
  };

  ghc965Attrs = {
    hash = "25865a40d14b3f9cf19f19b924e2ab4069b09588";
    versName = "ghc965";
  };

  ghc966Attrs = {
    hash = "d04953086551086b44b6f3c6b7eeb26294f207da";
    versName = "ghc966";
  };

  ghc967Attrs = {
    hash = "b599843bad24621dcaa5ab60dac98f9b0eb1cabe";
    versName = "ghc967";
  };

  # ######################################################################### #
  #                                  GHC 9.8                                  #
  # ######################################################################### #

  ghc98Attrs = ghc984Attrs;

  # NOTE: We could upgrade this hash to 25865a40d14b3f9cf19f19b924e2ab4069b09588
  # -- what ghc982 currently uses -- and then we'd get apply-refact.
  # However ghc981's caching is terrible with that hash, so we judge that the
  # better caching is worth giving up apply-refact.
  ghc981Attrs = {
    hash = "2726f127c15a4cc9810843b96cad73c7eb39e443";
    versName = "ghc981";
    overrides = _: _: prev: {
      fourmolu = prev.fourmolu_0_14_1_0;
      hlint = prev.hlint_3_8;
      ormolu = prev.ormolu_0_7_3_0;
    };

    unsupported = [ "apply-refact" ];

    poorToolCache = [
      "fourmolu"
      "hlint"
      "hls"
      "ormolu"
    ];
  };

  ghc982Attrs = {
    hash = "25865a40d14b3f9cf19f19b924e2ab4069b09588";
    versName = "ghc982";
    overrides = _: _: prev: {
      apply-refact = prev.apply-refact_0_14_0_0;
      fourmolu = prev.fourmolu_0_15_0_0;
      hlint = prev.hlint_3_8;
      ormolu = prev.ormolu_0_7_4_0;
    };
  };

  ghc983Attrs = {
    hash = "5e4fbfb6b3de1aa2872b76d49fafc942626e2add";
    versName = "ghc983";
    overrides = _: _: prev: {
      apply-refact = prev.apply-refact_0_14_0_0;
      fourmolu = prev.fourmolu_0_15_0_0;
      hlint = prev.hlint_3_8;
      ormolu = prev.ormolu_0_7_4_0;
    };

    poorToolCache = [
      "apply-refact"
      "fourmolu"
      "hlint"
      "hls"
      "ormolu"
    ];
  };

  ghc984Attrs = {
    hash = "9e4d5190a9482a1fb9d18adf0bdb83c6e506eaab";
    versName = "ghc984";
  };

  # ######################################################################### #
  #                                  GHC 9.10                                 #
  # ######################################################################### #

  # TODO: GHC 9.10.4 is planned.
  #
  # See NOTE: [GHC Aliases]
  ghc910Attrs = ghc9103Attrs // {
    unstableHash = true;
  };

  ghc9101Attrs = {
    hash = "5633bcff0c6162b9e4b5f1264264611e950c8ec7";
    versName = "ghc9101";

    unsupported = [
      "apply-refact"
      "hlint"
    ];
  };

  ghc9102Attrs = {
    hash = "50a96edd8d0db6cc8db57dab6bb6d6ee1f3dc49a";
    versName = "ghc9102";

    poorToolCache = [
      "fourmolu"
      "hls"
      "ormolu"
    ];

    unsupported = [
      "apply-refact"
      "hlint"
    ];
  };

  ghc9103Attrs = {
    hash = "50a96edd8d0db6cc8db57dab6bb6d6ee1f3dc49a";
    versName = "ghc9103";

    unsupported = [
      "apply-refact"
      "hlint"
    ];
  };

  # ######################################################################### #
  #                                  GHC 9.12                                 #
  # ######################################################################### #

  # TODO: Switch if ghc9123 tools are fixed.
  #
  # See NOTE: [GHC Aliases]
  ghc912Attrs = ghc9122Attrs // {
    unstableHash = true;
  };

  ghc9121Attrs = {
    hash = "ed4a395ea001367c1f13d34b1e01aa10290f67d6";
    versName = "ghc9121";

    unsupported = [
      "apply-refact"
      "fourmolu"
      "hlint"
      "hls"
      "ormolu"
    ];
  };

  ghc9122Attrs = {
    hash = "3730d8a308f94996a9ba7c7138ede69c1b9ac4ae";
    versName = "ghc9122";
  };

  ghc9123Attrs = {
    hash = "5912c1772a44e31bf1c63c0390b90501e5026886";
    versName = "ghc9123";

    # These fail because ghc-lib-parser is not updated to 9.12.3 yet.
    # Apply-refact actually works, but for now disable it since there is little
    # point when hlint fails.
    unsupported = [
      "apply-refact"
      "fourmolu"
      "hlint"
      "hls"
      "ormolu"
    ];

    unstableHash = true;
  };

  # ######################################################################### #
  #                                  GHC 9.14                                 #
  # ######################################################################### #

  # TODO: Switch if better ghc comes out.
  #
  # See NOTE: [GHC Aliases]
  ghc914Attrs = ghc9141Attrs // {
    unstableHash = true;
  };

  ghc9141Attrs = {
    hash = "5912c1772a44e31bf1c63c0390b90501e5026886";
    versName = "ghc9141";

    unsupported = [
      "apply-refact"
      "fourmolu"
      "hlint"
      "hls"
      "ormolu"
    ];

    unstableHash = true;
  };
in
{
  # GHC 8
  ghc8 = mkSet ghc8Attrs;

  ## GHC 8.10
  ghc810 = mkSet ghc810Attrs;
  ghc8107 = mkSet ghc8107Attrs;

  # GHC 9
  ghc9 = mkSet ghc9Attrs;

  ## GHC 9.0
  ghc90 = mkSet ghc90Attrs;
  ghc902 = mkSet ghc902Attrs;

  ## GHC 9.2
  ghc92 = mkSet ghc92Attrs;
  ghc925 = mkSet ghc925Attrs;
  ghc926 = mkSet ghc926Attrs;
  ghc927 = mkSet ghc927Attrs;
  ghc928 = mkSet ghc928Attrs;

  ## GHC 9.4
  ghc94 = mkSet ghc94Attrs;
  ghc944 = mkSet ghc944Attrs;
  ghc945 = mkSet ghc945Attrs;
  ghc946 = mkSet ghc946Attrs;
  ghc947 = mkSet ghc947Attrs;
  ghc948 = mkSet ghc948Attrs;

  ## GHC 9.6
  ghc96 = mkSet ghc96Attrs;
  ghc961 = mkSet ghc961Attrs;
  ghc962 = mkSet ghc962Attrs;
  ghc963 = mkSet ghc963Attrs;
  ghc964 = mkSet ghc964Attrs;
  ghc965 = mkSet ghc965Attrs;
  ghc966 = mkSet ghc966Attrs;
  ghc967 = mkSet ghc967Attrs;

  ## GHC 9.8
  ghc98 = mkSet ghc98Attrs;
  ghc981 = mkSet ghc981Attrs;
  ghc982 = mkSet ghc982Attrs;
  ghc983 = mkSet ghc983Attrs;
  ghc984 = mkSet ghc984Attrs;

  ## GHC 9.10
  ghc910 = mkSet ghc910Attrs;
  ghc9101 = mkSet ghc9101Attrs;
  ghc9102 = mkSet ghc9102Attrs;
  ghc9103 = mkSet ghc9103Attrs;

  ## GHC 9.12
  ghc912 = mkSet ghc912Attrs;
  ghc9121 = mkSet ghc9121Attrs;
  ghc9122 = mkSet ghc9122Attrs;
  ghc9123 = mkSet ghc9123Attrs;

  ## GHC 9.14
  ghc914 = mkSet ghc914Attrs;
  ghc9141 = mkSet ghc9141Attrs;
}
