#!/bin/bash

exec-command()
{
  disable
}

disable()
{
  log-header "Disable Kubernetes"
  disable-node
  log-footer
}

disable-node()
{
  log "- Stop and disable Kubernetes Service"
  spinner-on
  systemctl stop kubernetes >> ${BASEDIR}/logs/console.log 2>&1
  systemctl disable kubernetes >> ${BASEDIR}/logs/console.log 2>&1
  if [ "$(is-kubernetes-enabled)" == "enabled" ]; then
    spinner-off "[${RED}FAILED${NC}]"
  else
    spinner-off "[${GREEN}OK${NC}]"
  fi
}
