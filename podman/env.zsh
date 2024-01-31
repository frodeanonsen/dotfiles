DOCKER_HOST=unix://
if [[ $(uname) == "Darwin" ]]; then
  DOCKER_HOST="${DOCKER_HOST}`podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}'`"
else
  DOCKER_HOST="${DOCKER_HOST}`podman info --format '{{.Host.RemoteSocket.Path}}'`"
fi

export DOCKER_HOST
