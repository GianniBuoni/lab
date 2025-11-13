{
  inputs,
  lib,
  config,
  ...
}: let
  # define input -> flakeModule pairs
  imports = with inputs; {
    devenv = devenv.flakeModule;
    agenix-shell = agenix-shell.flakeModules.default;
  };
  # check if input exists
  checkInput = name: value: lib.optionals (lib.hasAttr name inputs) value;
in {
  flake-file.inputs = {
    devenv.url = "github:cachix/devenv";
    agenix-shell.url = "github:aciceri/agenix-shell";
  };
  # attrset -> list verifying every input exists
  imports = lib.filter (v: v != []) (lib.attrValues (lib.mapAttrs checkInput imports));

  perSystem.devenv.shells = with config.flake.aspects.devshells; {
    default.imports = [base testing];
    staging.imports = [base staging];
  };
}
