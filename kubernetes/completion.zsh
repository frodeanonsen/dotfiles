if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
  complete -o default -F __start_kubectl k
  complete -o default -F __start_kubectl kan
fi

if [ $commands[kind] ]; then
  source <(kind completion zsh)
fi

if [ $commands[helm] ]; then
  source <(helm completion zsh)
  complete -o default -F __start_helm helm
  complete -o default -F __start_helm h
fi
