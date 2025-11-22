{moduleWithSystem, ...}: let
  mkEnv = name: value: {inherit name value;};
in {
  flake.aspects.devshells.testing = moduleWithSystem ({pkgs, ...}: {
    packages = with pkgs; [
      # local testing
      k3d
    ];
    env = [
      (mkEnv "CLUSTER_BRANCH" "testing")
    ];
  });

  flake.aspects.devshells.staging = {
    env = [
      (mkEnv "CLUSTER_BRANCH" "staging")
    ];
  };
}
