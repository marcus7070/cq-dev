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
      pkgs.python37Packages.cadquery
      pkgs.python37Packages.ezdxf
      pkgs.python37Packages.matplotlib
    ];
  }
