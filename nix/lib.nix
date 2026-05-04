# Provides common utilities

let
  ghcMap = import ./ghc_map.nix;
  ghcKeys = ''

    - latest

    - ghc9
    - ghc914, ghc9141
    - ghc912, ghc9121, ghc9122, ghc9123, ghc9124
    - ghc910, ghc9101, ghc9102, ghc9103

    - ghc98, ghc981, ghc982, ghc983, ghc984
    - ghc96, ghc961, ghc962, ghc963, ghc964, ghc965, ghc966, ghc967
    - ghc94, ghc944, ghc945, ghc946, ghc947, ghc948
    - ghc92, ghc925, ghc926, ghc927, ghc928
    - ghc90, ghc902

    - ghc8
    - ghc810, ghc8107
  '';

  showKeys =
    attrs:
    let
      attrKeys = builtins.attrNames attrs;
    in
    builtins.concatStringsSep ", " attrKeys;
  member = y: xs: builtins.foldl' (acc: x: if x == y then true else acc) false xs;

  lookupOrDie =
    mp: key: keyName: allKeys:
    if mp ? ${key} then mp.${key} else throw "Invalid ${keyName}: '${key}'; valid keys are ${allKeys}";

  # Returns a list of dev tools, depending on the arguments.
  mkDev =
    devTools: ghcSet:
    let
      dontCheck = ghcSet.pkgs.haskell.lib.dontCheck;
      compiler = ghcSet.compiler;
      addTool =
        acc: tool:
        let
          flagName = tool.flagName;
        in
        if devTools."${flagName}" then
          if member flagName ghcSet.unsupported then
            throw "${flagName} is unsupported for ${ghcSet.versName}."
          else
            acc ++ [ (dontCheck tool.pkg) ]
        else
          acc;
      allTools = [
        {
          flagName = "apply-refact";
          pkg = compiler.apply-refact;
        }
        {
          flagName = "fourmolu";
          pkg = compiler.fourmolu;
        }
        {
          flagName = "hls";
          pkg = compiler.haskell-language-server;
        }
        {
          flagName = "hlint";
          pkg = compiler.hlint;
        }
        {
          flagName = "ormolu";
          pkg = compiler.ormolu;
        }
      ];
    in
    builtins.foldl' addTool [ ] allTools;
in
{
  inherit mkDev;

  getGhcSet = ghc-vers: lookupOrDie ghcMap ghc-vers "ghc-vers" ghcKeys;

  emptyDevTools = {
    apply-refact = false;
    fourmolu = false;
    hlint = false;
    hls = false;
    ormolu = false;
  };
}
