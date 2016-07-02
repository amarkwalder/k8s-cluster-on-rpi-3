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
  log "Hyperkube" &&   green $HYPERKUBE_VERSION

  echo ""

  log "Kubernetes Master" && printf "$(status-master LOG)\n" 
  log "Kubernetes Worker" && printf "$(status-worker LOG)\n" 

  #log-footer
  echo ""
}

red()
{
  printf "${RED}$1${NC}\n" 
}

green()
{
  printf "${GREEN}$1${NC}\n" 
}

