# base devshell packages
{moduleWithSystem, ...}: {
  flake.aspects.devshells.base = moduleWithSystem ({pkgs, ...}: {
    packages = with pkgs; [
      # cluster tools
      k9s
      kubectl
      kubernetes-helm
      fluxcd

      # extra utilities
      sops
      age
      just
    ];
  });
}
