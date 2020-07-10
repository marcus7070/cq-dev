let
  pkgs = import <nixpkgs> {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };

# in pkgs.python3Packages.ocp
in pkgs.cq-editor
# in [ pkgs.cq-editor pkgs.python37Packages.cadquery.doc ]
# in pkgs.python3Packages.cadquery
