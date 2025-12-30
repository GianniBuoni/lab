# base devshell packages
{moduleWithSystem, ...}: {
  flake.aspects.devshells.base = moduleWithSystem ({pkgs, ...}: {
    packages = with pkgs; [
      # cluster tools
      fluxcd
      minikube
      k3d
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
