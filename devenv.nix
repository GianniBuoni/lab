{pkgs, ...}: {
  packages = with pkgs; [
    just
    kubectl
    minikube
  ];

  enterTest = ''
    just --version
    kubectl version --client=true
    k version --client=true
    minikube version
  '';

  enterShell = "minikube status";

  scripts."k".exec = "kubectl $@";
}
