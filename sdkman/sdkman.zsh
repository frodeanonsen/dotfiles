if [[ -d ~/.sdkman ]]; then
  export SDKMAN_DIR="${HOME}/.sdkman"
  source ${SDKMAN_DIR}/bin/sdkman-init.sh
fi
