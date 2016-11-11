{ stdenv, haskellPackages, cabal2nix, electron }:

let
  version = "0.1.0.0";
  src = builtins.filterSource (path: type:
    (toString path) != (toString ../.git)
  ) ../.;
in
  stdenv.mkDerivation rec {
    name = "Hyper-Haskell-${version}";

    # hyper
    hyperProject = import ./haskell.nix {
      inherit stdenv cabal2nix;
      name = "hyper";
      dir = ../haskell/hyper;
    };
    hyper = haskellPackages.callPackage hyperProject {};

    # hyper-extra
    extraProject = import ./haskell.nix {
      inherit stdenv cabal2nix;
      name = "hyper-extra";
      dir = ../haskell/hyper-extra;
    };
    extra = haskellPackages.callPackage extraProject { inherit hyper; };

    # hyper-haskell-server
    serverProject = import ./haskell.nix {
      inherit stdenv cabal2nix;
      name = "hyper-haskell-server";
      dir = ../haskell/hyper-haskell-server;
    };
    server = haskellPackages.callPackage serverProject { inherit hyper; };

    electronCommand = "${electron.out}/bin/electron";

    inherit src;

    hyperCommand = ./hyper-command.sh;

    buildCommand = ''
      mkdir -p $out/bin
      mkdir -p $out/hyper-app
      cp -r $src/app $out/hyper-app
      chmod +x ${hyperCommand}
      cp -p ${hyperCommand} $out/bin/hyper
      substituteInPlace $out/bin/hyper --replace "@electron@" '${electronCommand}' --replace "@out@" $out
    '';
  }

