let
  giannibuoni = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbNe1fwEsVI9zMFX+0tPB+mHbc4VzrnGE/t9MrwDsoq";
in {
  # flake-file.inputs = {
  #   agenix-shell.url = "github:aciceri/agenix-shell";
  # };
  # imports = lib.optionals (inputs ? agenix-shell) [
  #   inputs.agenix-shell.flakeModules.default
  # ];

  "secrets.age".publicKeys = [
    giannibuoni
  ];
}
