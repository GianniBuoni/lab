{pkgs, ...}: {
  packages = with pkgs; [
    kubectl
    kubernetes-helm
    minikube
    rpi-imager
    fluxcd
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
