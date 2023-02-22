# Includes common utilities

let
  ghcToNixpkgs = {
    ghc8107 = "aa1d74709f5dac623adb4d48fdfb27cc2c92a4d4";
    ghc902 = "b7d8c687782c8f9a1d425a7e486eb989654f6468";
    ghc925 = "545c7a31e5dedea4a6d372712a18e00ce097d462";
    ghc944 = "545c7a31e5dedea4a6d372712a18e00ce097d462";
  };

  showKeys = attrs:
    let attrKeys = builtins.attrNames attrs;
    in builtins.concatStringsSep ", " attrKeys;

  mkDev = compiler: pkgs: ghcid: hls:
    let
      hlsMap = {
        "none" = [ ];
        "full" = mkHls compiler pkgs;
        "ormolu" = mkHlsOrmolu compiler pkgs;
      };
      hlsTools =
        if hlsMap ? ${hls}
        then hlsMap.${hls}
        else throw "Invalid hls: '${hls}; valid keys are ${showKeys hlsMap}.";
      ghcidTools = if ghcid then mkGhcid compiler pkgs else [ ];
    in
    hlsTools ++ ghcidTools;

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
      hash =
        if ghcToNixpkgs ? ${ghcVers}
        then ghcToNixpkgs.${ghcVers}
        else
          throw
            ''Invalid ghcVers: '${ghcVers}'; valid keys are: ${showKeys ghcToNixpkgs}.
              '';
    in
    import
      (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz";
      })
      { };
}
