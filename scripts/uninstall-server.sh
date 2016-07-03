#!/bin/bash

exec-command()
{
  uninstall-server
}

uninstall-server()
{
  log-header "Remove Kubernetes" 

  log "- Stopping Kubernetes Master"
  remove-service kubernetes-master /etc/systemd/system/kubernetes-master.service

  log "- Stopping Kubernetes Worker"
  remove-service kubernetes-worker /etc/systemd/system/kubernetes-worker.service

  log "- Uninstall Kubernetes (Konfiguration)"
  spinner-on
  rm -rf /etc/kubernetes
  if [[ $(is-system-installed) == "NOT INSTALLED" ]]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  remove federation-apiserver
  remove federation-controller-manager
  remove hyperkube
  remove kube-apiserver
  remove kube-controller-manager
  remove kubectl
  remove kube-dns
  remove kubelet
  remove kubemark
  remove kube-proxy
  remove kube-scheduler

  log-footer
}

remove()
{
  log "  - $1"
  spinner-on
  rm -f /usr/bin/$1
  if [ -f /usr/bin/$1 ]; then
    spinner-off "[${RED}FAILED${NC}]"
  else
    spinner-off "[${GREEN}OK${NC}]"
  fi
}

