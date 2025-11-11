{pkgs, ...}: {
  packages = with pkgs; [
    # cluster tools
    k9s
    kubectl
    kubernetes-helm
    fluxcd

    # minikube testing
    minikube

    # extra utilities
    cloudflared
    sops
    age
  ];

  enterTest = ''
    kubectl version --client=true
    k version --client=true
    minikube version
    helm version
    flux version --client
  '';

  enterShell = "minikube status";

  scripts."k".exec = "kubectl $@";

  dotenv.enable = true;
}
