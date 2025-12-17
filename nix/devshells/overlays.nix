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
        k3d
      ];
      env = [
        (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
        (mkSopAgeEnv "${clusterContext}")
      ];
    });
}
