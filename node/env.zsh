if [ $commands[ipconfig] ]; then
  alias serve="browser-sync start -s -f . --no-notify --host `ipconfig getifaddr en0` --port 9000"
fi

if [ $commands[yarn] ]; then
  PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi
