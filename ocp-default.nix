let
  pkgs = import <nixpkgs> {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };

in pkgs.python3Packages.ocp
# in pkgs.opencascade-occt
