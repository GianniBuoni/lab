# requires that flux kustomization-file has the same name
# as the system kustomization
build KUSTOMIZATION KUSTOMIZE_FILE:
    flux build kustomization {{KUSTOMIZATION}} \
    --kustomization-file="./clusters/$CLUSTER_BRANCH/{{KUSTOMIZATION}}.yaml" \
    --path={{KUSTOMIZE_FILE}}

rec KUSTOMIZATION:
    flux reconcile kustomization {{KUSTOMIZATION}} --with-source

# creates a k3d testing cluster and bootstrap flux and sops onto current context
bootstrap DEPLOY_KEY_PATH: secrets
    flux bootstrap git \
    --private-key-file={{DEPLOY_KEY_PATH}} \
    --url={{FLUX_GIT_REPO}} \
    --branch=main \
    --path="clusters/$CLUSTER_BRANCH"

# create new testing cluster via k3d
start:
    minikube start \
    -p $CLUSTER_BRANCH \
    --driver=kvm2 \
    --disk-size=5g \
    --extra-disks=3

FLUX_GIT_REPO := "ssh://git@github.com/GianniBuoni/lab.git"

# adds inital sops secret for flux to use
secrets:
    kubectl create ns flux-system
    cat $SOPS_AGE_KEY_FILE | kubectl create secret generic sops-age \
    --namespace=flux-system \
    --from-file=age.agekey=/dev/stdin
