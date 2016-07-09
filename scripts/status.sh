#!/bin/bash

exec-command()
{
  status 
}

status()
{
  log-header "Status Kubernetes" "EMPTY"

  log "RPI Cluster" && green $RPI_CLUSTER_VERSION
  log "Kubernetes" &&  green $KUBERNETES_VERSION
  log "Etc" &&         green $ETCD_VERSION
  log "Flannel" &&     green $FLANNELD_VERSION

  echo ""

  if [[ "${OSTYPE}" != "darwin"* ]]; then
    log "Kubernetes" && printf "$(status-kubernetes LOG)\n" 
    log "Master|Worker" && printf "$(is-master-or-worker LOG)\n"
    echo ""
  fi

}

