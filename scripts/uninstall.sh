#!/bin/bash

exec-command()
{
  uninstall
}

uninstall()
{
  log-header "Remove Kubernetes" 

  log "- Stopping Kubernetes Master"
  remove-service kubernetes-master /etc/systemd/system/kubernetes-master.service

  log "- Stopping Kubernetes Worker"
  remove-service kubernetes-worker /etc/systemd/system/kubernetes-worker.service

  log "- Uninstall Kubernetes"
  spinner-on
  rm -rf /etc/kubernetes
  
  if [[ $(is-system-installed) == "NOT INSTALLED" ]]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log-footer
}

