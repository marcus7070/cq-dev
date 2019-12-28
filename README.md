# Develop CadQuery and CQ-editor using Nix

## Steps

1. ~~Install Nix package manager. I suggest using a clean Virtual Machine (VM) with Ubuntu on it. You can install Nix using the instructions from here, which is pretty much just the command `curl https://nixos.org/nix/install | sh`. You might have to log out and in again to set some environment variables.~~ You need NixOS. Nix package manager on non-NixOS can't connect graphical apps to the correct graphics libraries.
2. Clone this repo and submodules, `git clone --recurse-submodules https://github.com/marcus7070/cq-dev`
3. `cd cq-dev`
4. Run the command `nix-build`, this should build both CadQuery and CQ-editor, and place a symlink to the result in this directory. The first time you run this command it will build many things and take a long time, but Nix's caching and optimisation are excellent, subsequent builds will be very fast.
5. Run `./result/bin/cq-editor`
6. To create docs, run `nix-build -E 'let pkgs = import <nixpkgs> { config = {}; overlays = [ (import ./overlay.nix) ];}; in pkgs.python3Packages.cadquery.doc' --keep-failed`

## Further dev

Feel free to change the CadQuery or CQ-editor source code. Just rerun `nix-build` when you are done. Nix should take a hash of the source code, and if it's changed it will rebuild it.

## Tests

Unfortunately PyQt5 isn't currently working in Nix, so CQ-editor's tests have been disabled.
