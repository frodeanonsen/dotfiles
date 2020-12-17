#if [[ -d ~/.kube ]]; then
#  export KUBECONFIG=$(echo $(find ~/.kube -type f -name config.\*.yaml) | sed 's/[[:space:]]/:/g')
#fi
# export KUBECONFIG=~/.kube/config.yaml
