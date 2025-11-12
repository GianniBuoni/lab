{
  inputs,
  lib,
  config,
  ...
}: {
  flake-file.inputs.devenv.url = "github:cachix/devenv";
  imports = lib.optionals (inputs ? devenv) [inputs.devenv.flakeModule];
  perSystem.devenv.shells = with config.flake.aspects.devshells; {
    default.imports = [base testing];
    staging.imports = [base staging];
  };
}
