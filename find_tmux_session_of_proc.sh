for pid in $(pgrep nvim); do
	tmux list-panes -aF '#{session_name} #{pane_pid}' | awk -v pid=$pid '$2==pid {print "nvim PID " pid " is in tmux session: " $1}'
done
