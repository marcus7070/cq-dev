# Develop CadQuery and CQ-editor using Nix

## Steps

1. Install Nix package manager. I suggest using a clean Virtual Machine (VM) with Ubuntu on it. You can install Nix using the instructions from here, which is pretty much just the command `curl https://nixos.org/nix/install | sh`. You might have to log out and in again to set some environment variables.
2. Clone this repo and submodules, `git clone --recurse-submodules https://github.com/marcus7070/cq-dev`
3. `cd cq-dev`
4. Run the command `nix-build`, this should build both CadQuery and CQ-editor, and place a symlink to the result in this directory.
5. Run `./result/bin/cq-editor`

## Further dev

Feel free to change the CadQuery or CQ-editor source code. Just rerun `nix-build` when you are done. Nix should take a hash of the source code, and if it's changed it will rebuild it.

## Installing in a dirty environment

If you have reused a VM with lots of other programs installed on it, or used something with CadQuery or CQ-editor already installed, it might be worth passing the option `--pure` to `nix-build` which should enforce isolation.
