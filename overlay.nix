self: super: {
  python37 = super.python37.override {
    packageOverrides = python-self: python-super: {
      cadquery = python-super.callPackage ./cadquery.nix { documentation = false; };
      ocp = python-super.callPackage ./OCP { };
      clang = python-super.callPackage ./clang { };
      cymbal = python-super.callPackage ./cymbal { };
      ezdxf = python-super.callPackage ./ezdxf { };
    };
  };
  cq-editor = super.libsForQt5.callPackage ./cq-editor.nix { python3Packages = self.python37Packages; };
  # looks like the current release of OCP uses 7.4.0, not the most recent 7.4.0p1 release
  opencascade-occt = super.callPackage ./opencascade-occt/7_4_0.nix { };
}
