#!/bin/bash

exec-command()
{
  enable
}

enable()
{
  log-header "Enable Kubernetes"
  enable-node
  log-footer
}

enable-node()
{
  log "- Enable and start Kubernetes Service"
  spinner-on
  systemctl enable kubernetes >> ${BASEDIR}/logs/console.log 2>&1
  systemctl start kubernetes >> ${BASEDIR}/logs/console.log 2>&1
  if [ "$(is-kubernetes-active)" == "ACTIVE" ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
