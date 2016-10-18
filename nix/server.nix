{ mkDerivation, base, stdenv, nixpkgs }:

let
  inherit (nixpkgs) pkgs;

  cabal2nix = pkgs.haskellPackages.cabal2nix;

  here = ../haskell/hyper-haskell-server;
in
  pkgs.stdenv.mkDerivation ({
    name = "server-default.nix";

    buildCommand = ''
    ${cabal2nix}/bin/cabal2nix file://${here} > $out
    '';
  })
