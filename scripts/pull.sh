#!/bin/bash

exec-command()
{
  pull
}

pull()
{
  log-header "Pull Kubernetes Images"

  log "- Pulling Etc"
  pull-img gcr.io/google_containers/etcd-arm64:${ETCD_VERSION}

  log "- Pulling Flannel"
  pull-img gcr.io/google_containers/flannel-arm64:${FLANNELD_VERSION}

  log "- Pulling Hyperkube"
  pull-img gcr.io/google_containers/hyperkube-arm64:v${HYPERKUBE_VERSION}

  log "- Pulling Pause"
  pull-img gcr.io/google_containers/pause-arm64:${PAUSE_VERSION}

  log-footer
}

pull-img()
{
  spinner-on
  docker pull $1 >> ${BASEDIR}/logs/console.log 2>&1

  if [ $(docker images $1 | wc -l) -eq 2 ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
