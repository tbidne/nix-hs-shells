# Includes common utilities

let
  ghc-to-nixpkgs = {
    ghc8107 = "aa1d74709f5dac623adb4d48fdfb27cc2c92a4d4";
    ghc902 = "b7d8c687782c8f9a1d425a7e486eb989654f6468";
    ghc925 = "545c7a31e5dedea4a6d372712a18e00ce097d462";
    ghc944 = "545c7a31e5dedea4a6d372712a18e00ce097d462";
  };

  showKeys = attrs:
    let attrKeys = builtins.attrNames attrs;
    in builtins.concatStringsSep ", " attrKeys;

  hls = dev: compiler: pkgs:
    if dev then [
      compiler.haskell-language-server
      # hls needs ncurses
      pkgs.ncurses
    ] else [ ];
in
{
  inherit hls;

  # Adds the compiler's haskell dev tools if dev is true.
  devTools = dev: compiler: pkgs:
    if dev then [
      # ghcid's tests fail if stack is not present, so we need to disable
      # them as we are using cabal
      (pkgs.haskell.lib.dontCheck compiler.ghcid)
    ] ++ (hls dev compiler pkgs) else [ ];

  # Retrieves nixpkgs corresponding to the given ghc version.
  getPkgs = ghcVers:
    let
      hash =
        if ghc-to-nixpkgs ? ${ghcVers}
        then ghc-to-nixpkgs.${ghcVers}
        else
          throw
            ''Invalid ghcVers: '${ghcVers}'; valid keys are: ${showKeys ghc-to-nixpkgs}.
              '';
    in
    import
      (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz";
      })
      { };
}
