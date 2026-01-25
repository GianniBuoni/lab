mod kustomizations
mod clusters

# switch context
switch:
    case $CLUSTER_BRANCH in \
        dev) echo "use flake .#prod" > .envrc; direnv reload;; \
        prod) echo "use flake ." > .envrc; direnv reload;; \
    esac
# creates a cluster for local development and testing
@create:
    echo "Pick a backend:"; \
    echo ""; \
    echo "0) k3d"; \
    echo "1) talos docker"; \
    echo ""; \
    read -p "Choose [0..1]: " choice; \
    case $choice in \
        0) just clusters::_k3d;; \
        1) just clusters::_talos;; \
        *) exit 1;; \
    esac
# destroys and cleans up a local cluster
@destroy:
    echo "Pick a backend:"; \
    echo ""; \
    echo "0) k3d"; \
    echo "1) talos docker"; \
    echo ""; \
    read -p "Choose [0..1]: " choice; \
    case $choice in \
        0) k3d cluster delete $CLUSTER_BRANCH;; \
        1) talosctl cluster destroy --name $CLUSTER_BRANCH;; \
        *) exit 1;; \
    esac
