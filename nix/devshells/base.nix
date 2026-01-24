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
      dev.imports = [base dev];
      prod.imports = [base prod];
    };
    devShells.default = self'.devShells.dev;
  };
}
