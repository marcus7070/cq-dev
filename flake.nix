{
  description = "CQ-editor and CadQuery from submodules";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux; in {
        python37 = pkgs.python37.override {
          packageOverrides = python-self : python-super: {
            cadquery = python-super.callPackage ./cadquery.nix { documentation = true; };
            ocp = python-super.callPackage ./OCP { opencascade-occt = self.packages.x86_64-linux.opencascade-occt; };
            clang = python-super.callPackage ./clang { };
            cymbal = python-super.callPackage ./cymbal { };
            geomdl = python-super.callPackage ./geomdl { };
            ezdxf = python-super.callPackage ./ezdxf { };
            sphinx = python-super.callPackage ./sphinx { };
          };
        };
      cq-editor = pkgs.libsForQt5.callPackage ./cq-editor.nix { python3Packages = self.packages.x86_64-linux.python37.pkgs; };
      # looks like the current release of OCP uses 7.4.0, not the most recent 7.4.0p1 release
      opencascade-occt = pkgs.callPackage ./opencascade-occt/7_4_0.nix { };
      cadquery-docs = self.packages.x86_64-linux.python37.cadquery.doc;
    };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.cq-editor;

  };
}
