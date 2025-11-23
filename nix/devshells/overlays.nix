{moduleWithSystem, ...}: let
  mkEnv = name: value: {inherit name value;};
  mkSopAgeEnv = cluster: {
    name = "SOPS_AGE_KEY_FILE";
    value = "/run/secrets/cluster-secrets/${cluster}";
  };
in {
  flake.aspects.devshells.testing = moduleWithSystem ({pkgs, ...}: {
    packages = with pkgs; [
      # local testing
      k3d
    ];
    env = [
      (mkEnv "CLUSTER_BRANCH" "testing")
      (mkSopAgeEnv "testing")
    ];
  });

  flake.aspects.devshells.staging = {
    env = [
      (mkEnv "CLUSTER_BRANCH" "staging")
      (mkSopAgeEnv "staging")
    ];
  };
}
