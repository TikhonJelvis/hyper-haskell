{ pkgs ? import <nixpkgs> {} }:

let
  hyper = pkgs.callPackage (import ./default.nix) { inherit pkgs; };
in

  [ hyper ]
