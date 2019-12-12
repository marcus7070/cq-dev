self: super: {
  python3 = super.python3.override {
    packageOverrides = python-self: python-super: {
      cadquery = python-super.callPackage ./cadquery.nix {};
    };
  };
  cq-editor = self.libsForQt5.callPackage ./cq-editor.nix { };
}
