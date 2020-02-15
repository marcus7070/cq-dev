self: super: {
  python3 = super.python3.override {
    packageOverrides = python-self: python-super: {
      cadquery = python-super.callPackage ./cadquery.nix { documentation = false; };
    };
  };
  cq-editor = super.libsForQt5.callPackage ./cq-editor.nix { };
}
