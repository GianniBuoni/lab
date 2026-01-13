{moduleWithSystem, ...}: let
  mkEnv = name: value: {inherit name value;};
in {
  flake.aspects.devshells.staging = let
    clusterContext = "staging";
  in
    moduleWithSystem ({pkgs, ...}: {
      env = [
        (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
      ];
    });

  flake.aspects.devshells.testing = let
    clusterContext = "testing";
  in
    moduleWithSystem ({pkgs, ...}: {
      env = [
        (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
      ];
    });
}
