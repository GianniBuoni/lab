{
  inputs,
  lib,
  config,
  ...
}: {
  flake-file.inputs.devshell.url = "github:numtide/devshell";
  imports = lib.optionals (inputs ? devshell) [
    inputs.devshell.flakeModule
  ];

  perSystem.devshells = with config.flake.aspects.devshells; {
    default.imports = [base testing];
    staging.imports = [base staging];
  };
}
