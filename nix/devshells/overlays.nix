let
  mkEnv = name: value: {inherit name value;};
  mkTls = name: extension: cluster: {
    inherit name;
    value = "${baseSecretsPath}/${cluster}/tls.${extension}";
  };
  mkAge = cluster: {
    name = "SOPS_AGE_KEY_FILE";
    value = "${baseSecretsPath}/${cluster}/age.agekey";
  };
  baseSecretsPath = "/run/secrets";
in {
  flake.aspects.devshells.dev = let
    clusterContext = "dev";
    baseIP = "10.0.0";
    nodeIP = ["179" "153" "193"];
    nodes =
      builtins.concatStringsSep " "
      (builtins.map (ip: "${baseIP}.${ip}") nodeIP);
  in {
    env = [
      (mkAge "${clusterContext}")
      (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
      (mkEnv "TALOS_CLUSTER" "staging-gary")
      (mkEnv "TALOS_IPS" "${nodes}")
      (mkEnv "TALOS_NODE" "staging")
      (mkTls "TLS_CRT_FILE" "crt" "${clusterContext}")
      (mkTls "TLS_KEY_FILE" "key" "${clusterContext}")
    ];
  };
  flake.aspects.devshells.prod = let
    clusterContext = "prod";
  in {
    env = [
      (mkAge "${clusterContext}")
      (mkEnv "CLUSTER_BRANCH" "${clusterContext}")
      (mkTls "TLS_CRT_FILE" "crt" "${clusterContext}")
      (mkTls "TLS_KEY_FILE" "key" "${clusterContext}")
    ];
  };
}
