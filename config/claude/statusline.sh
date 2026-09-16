#!/usr/bin/env bash
# Claude Code status line: model | dir | context usage %
input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "?"')
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=${dir/#$HOME/\~}

# Prefer the precomputed percentage; fall back to computing from token counts.
pct=$(printf '%s' "$input" | jq -r '
  if (.context_window.used_percentage // null) != null then
    (.context_window.used_percentage | round)
  elif (.context_window.context_window_size // 0) > 0 then
    (((.context_window.current_usage // {}) |
      ((.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)))
     * 100 / .context_window.context_window_size | round)
  else
    empty
  end')

if [ -n "$pct" ]; then
  if   [ "$pct" -ge 90 ]; then color='\033[31m'   # red
  elif [ "$pct" -ge 70 ]; then color='\033[33m'   # yellow
  else                         color='\033[32m'   # green
  fi
  ctx=$(printf "${color}ctx %s%%\033[0m" "$pct")
else
  ctx='ctx --'
fi

printf '%s | %s | %b\n' "$model" "$dir" "$ctx"
