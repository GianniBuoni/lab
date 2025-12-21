# base devshell packages
{moduleWithSystem, ...}: {
  flake.aspects.devshells.base = moduleWithSystem ({pkgs, ...}: {
    packages = with pkgs; [
      # cluster tools
      fluxcd
      k9s
      kconf
      kubeconform
      kubectl
      kubernetes-helm

      # extra utilities
      sops
      just
    ];
  });
}
