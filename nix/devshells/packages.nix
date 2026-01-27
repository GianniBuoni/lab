# base devshell packages
{moduleWithSystem, ...}: {
  flake-file.inputs.talhelper.url = "github:budimanjojo/talhelper";
  flake.aspects.devshells.base = moduleWithSystem ({
    pkgs,
    inputs',
    ...
  }: {
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
      kubeseal
      talosctl
      inputs'.talhelper.packages.default

      # extra utilities
      sops
      just
    ];
  });
}
