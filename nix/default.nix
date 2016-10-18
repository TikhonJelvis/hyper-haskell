{ pkgs ? import <nixpkgs> {} }:

rec {
  version = "0.1.0.0";
  src = builtins.filterSource (path: type:
    (toString path) != (toString ../.git)
  ) ../.;
  
  build = pkgs.callPackage ./build.nix { inherit pkgs src version; };
}
