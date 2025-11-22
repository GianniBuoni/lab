{inputs, ...}: {
  flake-file.inputs = {
    flake-aspects.url = "github:vic/flake-aspects";
    flake-file.url = "github:vic/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  flake-file.outputs = "inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./nix)";

  imports = with inputs; [
    flake-file.flakeModules.default
    flake-file.flakeModules.nix-auto-follow
    flake-aspects.flakeModule
  ];
}
