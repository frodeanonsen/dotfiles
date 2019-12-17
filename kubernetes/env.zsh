export KUBECONFIG=$(echo $(find ~/.kube -type f -name config.\*.yaml) | sed 's/[[:space:]]/:/g')
