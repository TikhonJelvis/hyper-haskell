{ stdenv, version, src, electron, ghc, cabal-install, pkgs }:

stdenv.mkDerivation rec {
  name = "Hyper-Haskell-${version}";

  # hyper
  hyperProject = import ./haskell.nix {
    inherit stdenv pkgs;
    name = "hyper";
    dir = ../haskell/hyper;
  };
  hyper = pkgs.haskellPackages.callPackage hyperProject {};

  # hyper-extra
  extraProject = import ./haskell.nix {
    inherit stdenv pkgs;
    name = "hyper-extra";
    dir = ../haskell/hyper-extra;
  };
  extra = pkgs.haskellPackages.callPackage extraProject { inherit hyper; };

  # hyper-haskell-server
  serverProject = import ./haskell.nix {
    inherit stdenv pkgs;
    name = "hyper-haskell-server";
    dir = ../haskell/hyper-haskell-server;
  };
  server = pkgs.haskellPackages.callPackage serverProject { inherit hyper; };

  electronCommand = if stdenv.isDarwin
    then "${electron.out}/Applications/Electron.app/Contents/MacOs/Electron"
    else "${electron.out}/bin/electron";

  inherit src;

  hyperApp = stdenv.mkDerivation ({
    name = "hyperApp";
    inherit src;

    buildCommand = ''
    cp -r $src/app $out;
    '';
  });

  buildInputs = [electron ghc cabal-install];
  buildCommand = ''
  echo $electronCommand $hyperApp > $out
  '';
}
