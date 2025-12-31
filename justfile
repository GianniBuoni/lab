GIT_BRANCH := if env("CLUSTER_BRANCH") == "prod" {"main"} else {env("CLUSTER_BRANCH")}
FLUX_GIT_REPO := "ssh://git@github.com/GianniBuoni/lab.git"

# start up new testing/staiging cluster via minikube
start:
    minikube start -p $CLUSTER_BRANCH
# requires that flux kustomization-file has the same name
# as the system kustomization
build KUSTOMIZATION KUSTOMIZE_FILE:
    flux build kustomization {{KUSTOMIZATION}} \
    --kustomization-file="./clusters/$CLUSTER_BRANCH/{{KUSTOMIZATION}}.yaml" \
    --path={{KUSTOMIZE_FILE}}

rec KUSTOMIZATION:
    flux reconcile kustomization {{KUSTOMIZATION}} --with-source

# bootstraps flux and sops onto current context
bootstrap DEPLOY_KEY_PATH: secrets
    flux bootstrap git \
    --private-key-file={{DEPLOY_KEY_PATH}} \
    --url={{FLUX_GIT_REPO}} \
    --branch={{GIT_BRANCH}} \
    --path="clusters/$CLUSTER_BRANCH"
# create new testing/staging cluster via minikube
create:
    minikube start \
    -p $CLUSTER_BRANCH \
    --driver=kvm2 \
    --memory=16384 \
    --cpus=8 \
    --disk-size=20g \
    --extra-disks=1
# create a new k3d cluster for quick testing
create-testing:
    k3d cluster create $CLUSTER_BRANCH \
    --no-lb \
    --k3s-arg "--disable=traefik@server:*" \
    --image rancher/k3s:latest \
    --subnet 172.28.0.0/16
# adds inital sops secret for flux to use
secrets:
    kubectl create ns flux-system
    cat $SOPS_AGE_KEY_FILE | kubectl create secret generic sops-age \
    --namespace=flux-system \
    --from-file=age.agekey=/dev/stdin
