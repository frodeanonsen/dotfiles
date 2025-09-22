for pid in $(pgrep nvim); do
	tmux list-panes -aF '#{pane_id} #{pane_current_command}' | awk -v pid=$pid '$2==pid {print "nvim PID " pid " is in tmux session: " $1}'
done
