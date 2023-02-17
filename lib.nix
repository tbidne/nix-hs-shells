# Includes common utilities

let
  ghc-to-nixpkgs = {
    ghc902 = "b7d8c687782c8f9a1d425a7e486eb989654f6468";
    ghc925 = "545c7a31e5dedea4a6d372712a18e00ce097d462";
    ghc944 = "545c7a31e5dedea4a6d372712a18e00ce097d462";
  };

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
      hash = ghc-to-nixpkgs.${ghcVers};
    in
    import
      (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz";
      })
      { };
}
