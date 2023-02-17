let
  ghc-to-nixpkgs = {
    ghc902 = "b7d8c687782c8f9a1d425a7e486eb989654f6468";
    ghc925 = "545c7a31e5dedea4a6d372712a18e00ce097d462";
    ghc944 = "545c7a31e5dedea4a6d372712a18e00ce097d462";
  };
in
{
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
