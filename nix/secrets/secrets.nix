{
  inputs,
  lib,
  moduleWithSystem,
  ...
}: {
  flake-file.inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix-shell.url = "github:aciceri/agenix-shell";
  };
  imports = lib.optionals (inputs ? agenix-shell) [
    inputs.agenix-shell.flakeModules.default
  ];

  agenix-shell.secrets = {
    cluster_age_secret = {
      file = _agenix/secrets.age;
    };
  };

  flake.aspects.devshells.secrets = moduleWithSystem (
    {inputs', ...}: {
      packages = with inputs'.agenix.packages; [agenix];
    }
  );
}
