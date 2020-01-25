let
  pkgs = import <nixpkgs> {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };

in [ pkgs.cq-editor pkgs.python3Packages.cadquery.doc ]
