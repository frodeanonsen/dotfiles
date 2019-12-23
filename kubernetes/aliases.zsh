if command -v kubectl >/dev/null 2>&1; then
  #kubectl() {
  #	  # shellcheck disable=SC1090,SC2039
  #	  source <(command kubectl completion zsh | sed s/kubectl/k/g)
  #	  command k "$@"
  #}

  kan() {
    command kubectl "$@" --all-namespaces
  }

  wkan() {
    command watch kubectl "$@" --all-namespaces
  }


  alias kx='kubectx'
  alias kn='kubens'

  source <(kubectl completion zsh)
  if command -v helm >/dev/null 2>&1; then
    source <(helm completion zsh)
  fi
  if command -v kind >/dev/null 2>&1; then
    source <(kind completion zsh)
  fi
  complete -o default -F __start_kubectl k
  complete -o default -F __start_kubectl kan
  alias k='kubectl'
  alias wk='watch kubectl'
  alias ke='EDITOR=vim kubectl edit'
  alias klbaddr="kubectl get svc -ojsonpath='{.status.loadBalancer.ingress[0].hostname}'"

  alias kdebug='kubectl run -i -t debug --rm --image=caarlos0/debug --restart=Never'
  alias knrunning='kubectl get pods --field-selector=status.phase!=Running'
  alias kfails='kubectl get po -owide --all-namespaces | grep "0/" | tee /dev/tty | wc -l'
  alias kimg="kubectl get deployment --output=jsonpath='{.spec.template.spec.containers[*].image}'"
fi
