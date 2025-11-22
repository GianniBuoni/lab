let
  giannibuoni = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbNe1fwEsVI9zMFX+0tPB+mHbc4VzrnGE/t9MrwDsoq";
in {
  "sops-secret.age".publicKeys = [
    giannibuoni
  ];
}
