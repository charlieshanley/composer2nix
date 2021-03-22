{


  description = "Generate Nix expressions to build PHP composer packages";



  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
  };



  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = import nixpkgs { inherit system; };
        noDev = false;

        composerEnv = import ./src/Composer2Nix/composer-env.nix {
          inherit (pkgs) stdenv lib writeTextFile fetchurl php unzip phpPackages;
        };

        composer2nix = import ./php-packages.nix {
            inherit composerEnv noDev;
            inherit (pkgs) fetchurl fetchgit fetchhg fetchsvn;
        };
      in
      rec {
        packages.composer2nix = composer2nix;
        defaultPackage = packages.composer2nix;
      });


}
