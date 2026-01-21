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

  perSystem = {self', ...}: {
    devshells = with config.flake.aspects.devshells; {
      staging.imports = [base staging];
      testing.imports = [base testing];
      prod.imports = [base prod];
    };
    devShells.default = self'.devShells.staging;
  };
}
