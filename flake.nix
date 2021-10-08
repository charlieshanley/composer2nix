{


  description = "Generate Nix expressions to build PHP composer packages";



  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
  };



  outputs = { self, nixpkgs, flake-utils }: {

    overlay = final: prev: {
      composer2nix = (final.callPackage ./php-packages.nix {
        composerEnv = final.callPackage ./src/Composer2Nix/composer-env.nix {};
        noDev = false;
        packageOverrides = {};
      }).overrideAttrs (_: { meta.mainProgram = "composer2nix"; });
    };

  } // (flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
    in rec {
      packages = { inherit (pkgs) composer2nix; };
      defaultPackage = packages.composer2nix;
    }));

}
