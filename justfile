# requires that flux kustomization-file has the same name
# as the system kustomization
build KUSTOMIZATION KUSTOMIZE_FILE:
    flux build kustomization {{KUSTOMIZATION}} \
    --kustomization-file "./clusters/$CLUSTER_BRANCH/{{KUSTOMIZATION}}.yaml" \
    --path {{KUSTOMIZE_FILE}}

rec KUSTOMIZATION:
    flux reconcile kustomization {{KUSTOMIZATION}} --with-source

# create new testing cluster via k3d
create:
    k3d cluster create $CLUSTER_BRANCH \
    --no-lb \
    --k3s-arg "--disable=traefik@server:0" \
    --image rancher/k3s:latest

FLUX_GIT_REPO := "ssh://git@github.com/GianniBuoni/lab.git"

# bootstrap flux and sops onto current context
bootstrap DEPLOY_KEY_PATH:
    flux bootstrap git \
    --private-key-file={{DEPLOY_KEY_PATH}} \
    --url={{FLUX_GIT_REPO}} \
    --branch=main \
    --path="clusters/$CLUSTER_BRANCH"
    cat $SOPS_AGE_KEY_FILE |
    kubectl create secret generic sops-age \
    --namespace=flux-system \
    --from-file=age.agekey=/dev/stdin
