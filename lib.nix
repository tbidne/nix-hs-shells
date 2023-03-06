# Provides common utilities

let
  showKeys = attrs:
    let attrKeys = builtins.attrNames attrs;
    in builtins.concatStringsSep ", " attrKeys;

  lookupOrDie = mp: key: keyName:
    if mp ? ${key}
    then mp.${key}
    else throw "Invalid ${keyName}: '${key}'; valid keys are ${showKeys mp}.";

  # Returns a list of dev tools, depending on the ghcid and hls arguments.
  mkDev = compiler: pkgs: cabalPlan: ghcid: hls:
    let
      cabalPlanTools = if cabalPlan then mkCabalPlan compiler pkgs else [ ];
      ghcidTools = if ghcid then mkGhcid compiler pkgs else [ ];
      hlsMap = {
        "none" = [ ];
        "full" = mkHls compiler pkgs;
        "ormolu" = mkHlsOrmolu compiler pkgs;
      };
      hlsTools = lookupOrDie hlsMap hls "hls";
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
  mkHlsOrmolu = compiler: pkgs:
    [
      (pkgs.haskell.lib.dontCheck
        (pkgs.haskell.lib.overrideCabal compiler.haskell-language-server (old: {
          configureFlags = (old.configureFlags or [ ]) ++
            [
              "-f -brittany"
              "-f -floskell"
              "-f -fourmolu"
              "-f -stylishhaskell"
            ];
        })))
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
