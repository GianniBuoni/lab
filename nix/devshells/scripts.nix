{
  flake.aspects.devshells.base = {
    devshell.motd = ''
      {135} ☸  Welcome to the $CLUSTER_BRANCH cluster!{reset}
      $(menu)
    '';
    commands = [
      {
        name = "fgg";
        category = "aliases";
        help = "Alias for `flux get kustomizations`";
        command = "flux get kustomizations";
      }
      {
        name = "k";
        category = "aliases";
        help = "Alias for `kubectl <ARGS>`";
        command = "kubectl $@";
      }
      {
        name = "enterTest";
        category = "tests";
        help = "Tests developement environement for necessary packages";
        command = ''
          kubectl version --client=true
          k version --client=true
          helm version
          flux version --client
          minikube version
          # must be installed on the host system
          libvirtd -V
        '';
      }
    ];
  };
}
