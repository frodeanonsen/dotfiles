if curl -I "https://127.0.0.1:6443" 2>&1 | grep -w "200\|301" ; then

  if [ $commands[kubectl] ]; then
    source <(kubectl completion zsh)
    complete -o default -F __start_kubectl k
    complete -o default -F __start_kubectl kan
    complete -o default -F __start_kubectl klf
    complete -o default -F __start_kubectl kgp
  fi

  if [ $commands[kind] ]; then
    source <(kind completion zsh)
  fi

  if [ $commands[helm] ]; then
    source <(helm completion zsh)
    complete -o default -F __start_helm helm
    complete -o default -F __start_helm h
  fi

fi
