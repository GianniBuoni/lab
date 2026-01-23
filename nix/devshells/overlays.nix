let
  mkEnv = name: value: {inherit name value;};

  baseTlsPath = "/run/secrets";

  mkTls = name: extension: cluster: {
    inherit name;
    value = "${baseTlsPath}/${cluster}/tls.${extension}";
  };
in {
  flake.aspects.devshells.dev = let
    clusterContext = "dev";
  in {
    env = [
      (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
      (mkTls "TLS_CRT_FILE" "crt" "${clusterContext}")
      (mkTls "TLS_KEY_FILE" "key" "${clusterContext}")
    ];
  };
  flake.aspects.devshells.prod = let
    clusterContext = "prod";
  in {
    env = [
      (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
    ];
  };
}
