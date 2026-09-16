# The everyday subset of aliases.zsh.
if command -v kubectl >/dev/null 2>&1; then
	alias k='kubectl'
	alias wk='watch kubectl'
	alias kgp='kubectl get pod'
	alias kdp='kubectl describe pod'
	alias klf='kubectl logs -f'
	alias knrunning='kubectl get pods --field-selector=status.phase!=Running'
	kan() { command kubectl "$@" --all-namespaces; }
	# Reuse kubectl's completion for the short forms.
	if declare -F __start_kubectl >/dev/null 2>&1 || source /usr/share/bash-completion/completions/kubectl 2>/dev/null; then
		complete -o default -F __start_kubectl k kan
	fi
fi
command -v helm >/dev/null 2>&1 && alias h='helm'
