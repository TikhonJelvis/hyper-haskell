{ stdenv, haskellPackages, cabal2nix, electron }:

let
  version = "0.1.0.0";
  src = builtins.filterSource (path: type:
    (toString path) != (toString ../.git)
  ) ../.;

  haskellBuild = { stdenv, cabal2nix, name, dir }:
    stdenv.mkDerivation ({
      name = "${name}-default.nix";

      buildCommand = ''
      ${cabal2nix}/bin/cabal2nix file://${dir} > $out
      '';
    });

in
  stdenv.mkDerivation rec {
    name = "Hyper-Haskell-${version}";

    # hyper
    hyperProject = haskellBuild {
      inherit stdenv cabal2nix;
      name = "hyper";
      dir = ./haskell/hyper;
    };
    hyper = haskellPackages.callPackage hyperProject {};

    # hyper-extra
    extraProject = haskellBuild {
      inherit stdenv cabal2nix;
      name = "hyper-extra";
      dir = ./haskell/hyper-extra;
    };
    extra = haskellPackages.callPackage extraProject { inherit hyper; };

    # hyper-haskell-server
    serverProject = haskellBuild {
      inherit stdenv cabal2nix;
      name = "hyper-haskell-server";
      dir = ./haskell/hyper-haskell-server;
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

