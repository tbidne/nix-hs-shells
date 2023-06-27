# Provides common utilities

let
  ghcMap = import ./ghc_map.nix;
  showKeys = attrs:
    let attrKeys = builtins.attrNames attrs;
    in builtins.concatStringsSep ", " attrKeys;
  member = y: xs:
    builtins.foldl'
      (acc: x: if x == y then true else acc)
      false
      xs;

  lookupOrDie = mp: key: keyName:
    if mp ? ${key}
    then mp.${key}
    else throw "Invalid ${keyName}: '${key}'; valid keys are ${showKeys mp}.";

  # Returns a list of dev tools, depending on the arguments.
  mkDev = devTools: ghcSet:
    let
      dontCheck = ghcSet.pkgs.haskell.lib.dontCheck;
      compiler = ghcSet.compiler;
      toolIfSet = flagName: tool:
        if devTools."${flagName}"
        then
          if member flagName ghcSet.unsupported
          then throw "${flagName} is unsupported for ${ghcSet.versName}."
          else [ (dontCheck tool) ]
        else [ ];
    in
    (toolIfSet "applyRefact" compiler.apply-refact)
    ++ (toolIfSet "fourmolu" compiler.fourmolu)
    ++ (toolIfSet "hls" compiler.haskell-language-server)
    ++ (toolIfSet "hlint" compiler.hlint)
    ++ (toolIfSet "ormolu" compiler.ormolu);
in
{
  inherit mkDev;

  getGhcSet = ghcVers: lookupOrDie ghcMap ghcVers "ghcVers";

  emptyDevTools = {
    applyRefact = false;
    fourmolu = false;
    hlint = false;
    hls = false;
    ormolu = false;
  };
}
