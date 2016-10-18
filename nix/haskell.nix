{ stdenv, pkgs, name, dir }:

let
  cabal2nix = pkgs.haskellPackages.cabal2nix;
in
  pkgs.stdenv.mkDerivation ({
    name = "${name}-default.nix";

    buildCommand = ''
    ${cabal2nix}/bin/cabal2nix file://${dir} > $out
    '';
  })

