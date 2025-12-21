{moduleWithSystem, ...}: let
  mkEnv = name: value: {inherit name value;};
  mkSopAgeEnv = cluster: {
    name = "SOPS_AGE_KEY_FILE";
    value = "/run/secrets/cluster-secrets/${cluster}/age.agekey";
  };
in {
  flake.aspects.devshells.staging = let
    clusterContext = "staging";
  in
    moduleWithSystem ({pkgs, ...}: {
      packages = with pkgs; [
        # local testing
        minikube
      ];
      env = [
        (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
        (mkSopAgeEnv "${clusterContext}")
      ];
      commands = [
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
    });
}
