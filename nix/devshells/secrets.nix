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
    SOPS_AGE_KEY.file = ../_agenix/sops-secret.age;
  };

  flake.aspects.devshells.secrets = moduleWithSystem (
    {
      inputs',
      config,
      ...
    }: {
      packages = with inputs'.agenix.packages; [agenix];

      devshell.startup.secrets.text = ''
        source ${lib.getExe config.agenix-shell.installationScript}
      '';
    }
  );
}
