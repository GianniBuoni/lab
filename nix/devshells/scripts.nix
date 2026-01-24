{
  flake.aspects.devshells.base = {
    devshell.motd = ''
      {135} ☸  Welcome to the $CLUSTER_BRANCH cluster!{reset}
      $(menu)
    '';
    commands = [
      {
        name = "k";
        category = "aliases";
        help = "Alias for `kubectl [args]`";
        command = "kubectl $@";
      }
      {
        name = "t";
        category = "aliases";
        help = "Alias for `talosctl [args]`";
        command = "talosctl $@";
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
          talosctl version --client
        '';
      }
    ];
  };
}
