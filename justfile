FLUX_GIT_REPO := "ssh://git@github.com/GianniBuoni/lab.git"

# start up new testing/staiging cluster via minikube
start:
    minikube start -p $CLUSTER_BRANCH
# builds kustomization manifests for validation
build KUSTOMIZATION *FLAGS:
    kubectl kustomize ./kustomizations/{{KUSTOMIZATION}}/$CLUSTER_BRANCH \
    {{FLAGS}}
# local testing cluster only: applies kustomization imperatively to cluster
apply KUSTOMIZATION *FLAGS:
    just build {{KUSTOMIZATION}}
    kubectl apply -k ./kustomizations/{{KUSTOMIZATION}}/$CLUSTER_BRANCH \
    {{FLAGS}}
# bootstraps flux and sops onto current context
bootstrap DEPLOY_KEY_PATH: secrets
    flux bootstrap git \
    --private-key-file={{DEPLOY_KEY_PATH}} \
    --url={{FLUX_GIT_REPO}} \
    --branch=main \
    --path="clusters/$CLUSTER_BRANCH" \
    --silent
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
    kubectl -n kube-system create secret tls sealed-secrets-key --cert="$TLS_CRT_FILE" --key="$TLS_KEY_FILE"
    kubectl -n kube-system label secret sealed-secrets-key sealedsecrets.bitnami.com/sealed-secrets-key=active
# suspends staging cluster flux resources for cleanup
suspend:
    flux suspend kustomization config
    flux suspend kustomization infra
# removes tailscale resources
cleanup-tailscale:
    kubectl delete svc traefik-int -n ingress
    kubectl delete svc pihole-dns -n pihole
