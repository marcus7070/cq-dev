let
  pkgs = import <nixpkgs> {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };
in
  pkgs.mkShell {
    buildInputs = [ 
      pkgs.python3Packages.cadquery
    ];
  }
