self: super: {
  python3 = super.python3.override {
    packageOverrides = python-self: python-super: {
      cadquery = python-super.callPackage ./cadquery.nix { documentation = true; };
      ocp = python-super.callPackage ./ocp.nix { };
      clang = python-super.callPackage ./clang { };
    };
  };
  cq-editor = super.libsForQt5.callPackage ./cq-editor.nix { };
}
