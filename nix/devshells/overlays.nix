{moduleWithSystem, ...}: let
  mkEnv = name: value: {inherit name value;};

  baseTlsPath = "/run/secrets/cluster-secrets";

  mkTls = name: extension: cluster: {
    inherit name;
    value = "${baseTlsPath}/${cluster}/tls.${extension}";
  };
in {
  flake.aspects.devshells.staging = let
    clusterContext = "staging";
  in
    moduleWithSystem ({pkgs, ...}: {
      env = [
        (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
        (mkTls "TLS_CRT_FILE" "crt" "${clusterContext}")
        (mkTls "TLS_KEY_FILE" "key" "${clusterContext}")
      ];
    });

  flake.aspects.devshells.testing = let
    clusterContext = "testing";
  in
    moduleWithSystem ({pkgs, ...}: {
      env = [
        (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
        (mkTls "TLS_CRT_FILE" "crt" "${clusterContext}")
        (mkTls "TLS_KEY_FILE" "key" "${clusterContext}")
      ];
    });
}
