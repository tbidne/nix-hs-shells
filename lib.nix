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
      cabalPlanTools = if devTools.cabalPlan then mkCabalPlan compiler pkgs else [ ];
      ghcidTools = if devTools.ghcid then mkGhcid compiler pkgs else [ ];
      hlsTools = if devTools.hls then mkHls compiler pkgs else [ ];
    in
    cabalPlanTools ++ ghcidTools ++ hlsTools;

  mkCabalPlan = compiler: pkgs:
    [
      (pkgs.haskell.lib.dontCheck compiler.cabal-plan)
    ];

  mkHls = compiler: pkgs:
    [
      (pkgs.haskell.lib.dontCheck compiler.haskell-language-server)
    ];
  mkGhcid = compiler: pkgs:
    [
      (pkgs.haskell.lib.dontCheck compiler.ghcid)
    ];
in
{
  inherit mkDev;

  # Retrieves nixpkgs corresponding to the given ghc version.
  getPkgs = ghcVers:
    let
      ghcToNixpkgs = {
        ghc8107 = "d0d55259081f0b97c828f38559cad899d351cad1";
        ghc902 = "d0d55259081f0b97c828f38559cad899d351cad1";
        ghc925 = "d0d55259081f0b97c828f38559cad899d351cad1";
        ghc926 = "d0d55259081f0b97c828f38559cad899d351cad1";
        ghc927 = "3c5319ad3aa51551182ac82ea17ab1c6b0f0df89";
        ghc944 = "d0d55259081f0b97c828f38559cad899d351cad1";
      };
      hash = lookupOrDie ghcToNixpkgs ghcVers "ghcVers";
    in
    import
      (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz";
      })
      { };
}
