{ stdenv, cabal2nix, name, dir }:

  stdenv.mkDerivation ({
    name = "${name}-default.nix";

    buildCommand = ''
    ${cabal2nix}/bin/cabal2nix file://${dir} > $out
    '';
  })

