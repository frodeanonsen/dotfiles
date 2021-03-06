kan() {
  command kubectl "$@" --all-namespaces
}

wkan() {
  command watch kubectl "$@" --all-namespaces
}

if [ $commands[kubectl] ]; then
  alias kx='kubectx'
  alias kn='kubens'

  alias k='kubectl'
  alias wk='watch kubectl'
  alias ke='EDITOR=vim kubectl edit'
  alias klbaddr="kubectl get svc -ojsonpath='{.status.loadBalancer.ingress[0].hostname}'"

  alias kdebug='kubectl run -i -t debug --rm --image=caarlos0/debug --restart=Never'
  alias knrunning='kubectl get pods --field-selector=status.phase!=Running'
  alias kfails='kubectl get po -owide --all-namespaces | grep "0/" | tee /dev/tty | wc -l'
  alias kimg="kubectl get deployment --output=jsonpath='{.spec.template.spec.containers[*].image}'"

  alias kgp="kubectl get pod"
  alias kdp="kubectl describe pod"
  alias klf="kubectl logs -f"
fi

if [ $commands[helm] ]; then
  alias h='helm'
fi
