{pkgs, ...}: {
  packages = with pkgs; [
    # cluster tools
    k9s
    kubectl
    kubernetes-helm
    fluxcd

    # local testing
    k3d

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

  enterShell = "minikube status";

  scripts."k".exec = "kubectl $@";
}
