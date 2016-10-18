{ stdenv, version, src, electron, ghc, cabal-install, pkgs }:

stdenv.mkDerivation rec {
  name = "Hyper-Haskell-${version}";

  hyperProject = import ./haskell.nix {
    inherit stdenv pkgs;
    name = "hyper";
    dir = ../haskell/hyper;
  };
  hyper = pkgs.haskellPackages.callPackage hyperProject {};
  
  serverProject = import ./haskell.nix {
    inherit stdenv pkgs;
    name = "hyper-haskell-server";
    dir = ../haskell/hyper-haskell-server;
  };
  server = pkgs.haskellPackages.callPackage serverProject { inherit hyper; };

  # inherit src;
  # buildInputs = [electron ghc cabal-install];

  
}
