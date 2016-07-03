#!/bin/bash

exec-command()
{
  install-server
}

install-server()
{

  if [ "$(is-system-installed)" == "INSTALLED" ] && ([ $(is-master-enabled) == "ENABLED" ] || [ $(is-worker-enabled) == "ENABLED" ]); then
    echo ""
    echo "Disable the whole system first before you install any server components."
    echo "Command: rpi-cluster disable" 
    log-footer
    exit 1
  fi

  log-header "Install Kubernetes"

  log "- Install Kubernetes Binaries"
  install-binaries

  log "- Install Kubernetes Master Configuration"
  install-config master

  log "- Install Kubernetes Master Service"
  install-service kubernetes-master /etc/systemd/system/kubernetes-master.service

  log "- Install Kubernetes Worker Configuration"
  install-config worker

  log "- Install Kubernetes Worker"
  install-service kubernetes-worker /etc/systemd/system/kubernetes-worker.service

  log-footer
}

install-binaries()
{
  echo ""
  
  copy federation-apiserver
  copy federation-controller-manager
  copy hyperkube
  copy kube-apiserver
  copy kube-controller-manager
  copy kubectl
  copy kube-dns
  copy kubelet
  copy kubemark
  copy kube-proxy
  copy kube-scheduler
}

copy()
{
  log "  - $1"
  spinner-on
  BINDIR=$BASEDIR/build/kubernetes-server-linux-arm/server/bin/
  cp $BINDIR/$1 /usr/bin
  if [ -f /usr/bin/$1 ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
