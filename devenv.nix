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

  scripts."k".exec = "kubectl $@";
}
