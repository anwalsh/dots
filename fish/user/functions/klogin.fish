function klogin --argument-names cluster
    if test "$cluster" != prod -a "$cluster" != staging
        echo "Invalid cluster. Use 'prod' or 'staging'."
        return 1
    end

    set namespace cloud-ops
    set -l old_kubeconfig $KUBECONFIG
    set -x KUBECONFIG ~/.kube/config.$cluster
    mkdir -p (dirname $KUBECONFIG)
    kanopy-oidc kube setup $cluster >$KUBECONFIG
    kanopy-oidc kube login
    kubectl config set-context (kubectl config current-context) --namespace=$namespace
    set -x KUBECONFIG $old_kubeconfig
end
