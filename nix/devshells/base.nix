{
  inputs,
  lib,
  config,
  ...
}: {
  flake-file.inputs = {
    devenv.url = "github:cachix/devenv";
    agenix-shell.url = "github:aciceri/agenix-shell";
  };
  imports = with inputs;
    lib.optionals (inputs ? devenv) [
      devenv.flakeModule
    ]
    ++ lib.optionals (inputs ? agenix-shell) [
      agenix-shell.flakeModules.default
    ];
  perSystem.devenv.shells = with config.flake.aspects.devshells; {
    default.imports = [base testing];
    staging.imports = [base staging];
  };
}
