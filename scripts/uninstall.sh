#!/bin/bash

exec-command()
{
  uninstall-kubernetes
}

uninstall-kubernetes()
{

  # Check installation and service state
  if [[ "$(is-kubernetes-installed)" == "INSTALLED" ]] && [[ $(is-kubernetes-enabled) == "ENABLED" ]]; then
    echo ""
    echo "Disable Kubernetes first before you uninstall."
    echo "Command: rpi-cluster disable"
    log-footer
    exit 1
  fi

  log-header "Remove Kubernetes" 
  K8S_ETC_DIR=/etc/kubernetes
  
  remove ${K8S_ETC_DIR}/scripts/kubernetes.sh 
  remove ${K8S_ETC_DIR}/scripts/master.sh 
  remove ${K8S_ETC_DIR}/scripts/turndown.sh 
  remove ${K8S_ETC_DIR}/scripts/worker.sh 
  remove ${K8S_ETC_DIR}/scripts/
  
  remove ${K8S_ETC_DIR}/k8s.conf
  remove ${K8S_ETC_DIR}/

  remove /etc/systemd/system/kubernetes.service

  log "- Reload Services"
  spinner-on
  systemctl daemon-reload
  if [ "$(is-kubernetes-installed)" == "NOT INSTALLED" ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log-footer
}

remove()
{
  log "  - $1"
  spinner-on
  rm -rf $1
  if [ -f $1 ]; then
    spinner-off "[${RED}FAILED${NC}]"
  else
    spinner-off "[${GREEN}OK${NC}]"
  fi
}

