#!/bin/bash

exec-command()
{
  disable
}

disable()
{
  log-header "Disable Kubernetes"
  disable-master
  disable-worker
  log-footer
}

disable-master()
{
  log "- Stop and disable Kubernetes Master Service"
  spinner-on
  systemctl stop kubernetes-master >> ${BASEDIR}/logs/console.log 2>&1
  systemctl disable kubernetes-master >> ${BASEDIR}/logs/console.log 2>&1
  IS_ENABLED=$(systemctl is-enabled kubernetes-master >> ${BASEDIR}/logs/console.log 2>&1)
  if [ "$IS_ENABLED" == "enabled" ]; then
    spinner-off "[${RED}FAILED${NC}]"
  else
    spinner-off "[${GREEN}OK${NC}]"
  fi
}

disable-worker()
{
  log "- Stop and disable Kubernetes Worker Service"
  spinner-on
  systemctl stop kubernetes-worker >> ${BASEDIR}/logs/console.log 2>&1
  systemctl disable kubernetes-worker >> ${BASEDIR}/logs/console.log 2>&1
  IS_ENABLED=$(systemctl is-enabled kubernetes-worker >> ${BASEDIR}/logs/console.log 2>&1)
  if [ "$IS_ENABLED" == "enabled" ]; then
    spinner-off "[${RED}FAILED${NC}]"
  else
    spinner-off "[${GREEN}OK${NC}]"
  fi
}
