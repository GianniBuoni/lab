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
      env = [
        (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
        (mkSopAgeEnv "${clusterContext}")
      ];
    });

  flake.aspects.devshells.testing = let
    clusterContext = "testing";
  in
    moduleWithSystem ({pkgs, ...}: {
      env = [
        (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
        (mkSopAgeEnv "${clusterContext}")
      ];
    });
}
