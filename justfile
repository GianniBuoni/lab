# requires that flux kustomization-file has the same name
# as the system kustomization
build KUSTOMIZATION KUSTOMIZE_FILE:
    flux build kustomization {{KUSTOMIZATION}} --dry-run --kustomization-file "./clusters/$CLUSTER_BRANCH/{{KUSTOMIZATION}}.yaml" --path {{KUSTOMIZE_FILE}}

rec KUSTOMIZATION:
    flux reconcile kustomization {{KUSTOMIZATION}} --with-source
