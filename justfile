mod kustomizations
mod clusters

# switch context
switch:
    case $CLUSTER_BRANCH in \
        dev) echo "use flake .#prod" > .envrc; direnv reload;; \
        prod) echo "use flake ." > .envrc; direnv reload;; \
    esac
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
