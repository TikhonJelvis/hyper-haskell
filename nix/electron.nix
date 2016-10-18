{ stdenv, lib, makeWrapper, fetchurl, unzip, atomEnv }:

stdenv.mkDerivation rec {
  name = "electron-${version}";
  version = "1.4.0";

  linux = fetchurl {
    url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
    sha256 = "10anqm2nplvgrqs3mh4pwfysyi42plf5m1awjqkp7vvn8v5dw87d";
    name = "${name}.zip";
  };

  darwin = fetchurl {
    url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-darwin-x64.zip";
    sha256 = "0g2sgnq7svbrlcp0mddh99yw5m3afsz9s4m9cjy1hzcd8b9n5iim";
    name = "${name}.zip";
  };

  src = if stdenv.isDarwin then darwin else linux;

  buildInputs = [ unzip makeWrapper ];
}
