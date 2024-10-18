# Disable podman for now

# DOCKER_HOST=unix://
# if [[ $(uname) == "Darwin" ]]; then
#   if [[ `podman system connection list | grep ssh` == 0 ]]; then
#     DOCKER_HOST="${DOCKER_HOST}`podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}'`"
#   fi
# else
#   DOCKER_HOST="${DOCKER_HOST}`podman info --format '{{.Host.RemoteSocket.Path}}'`"
# fi
#
# export DOCKER_HOST
