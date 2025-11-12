{
  flake.aspects.devshells.base = {pkgs, ...}: {
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

    enterTest = ''
      kubectl version --client=true
      k version --client=true
      helm version
      flux version --client
    '';

    scripts."k".exec = "kubectl $@";
    scripts."fgg".exec = "flux get kustomizations";
  };

  flake.aspects.devshells.testing = {pkgs, ...}: {
    packages = with pkgs; [
      # local testing
      k3d
    ];
    env.CLUSTER_BRANCH = "testing";
  };

  flake.aspects.devshells.staging = {
    env.CLUSTER_BRANCH = "staging";
  };
}
