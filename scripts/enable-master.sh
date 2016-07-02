#!/bin/bash

exec-command()
{
  enable-master
}

enable-master()
{
  log-header "Enable Kubernetes Master"

  source $BASEDIR/scripts/disable.sh
  disable-master
  disable-worker

  log "- Enable Kubernetes Master"
  spinner-on

  if [[ $( is-system-installed ) == "INSTALLED" ]]; then
    systemctl enable kubernetes-master >> ${BASEDIR}/logs/console.log 2>&1
    systemctl start kubernetes-master >> ${BASEDIR}/logs/console.log 2>&1
    IS_ENABLED_MASTER=$(is-master-enabled)
    IS_ENABLED_WORKER=$(is-worker-enabled)
    if [ "$IS_ENABLED_MASTER" == "ENABLED" ] && [ "$IS_ENABLED_WORKER" == "DISABLED" ]; then
      spinner-off "[${GREEN}OK${NC}]"
    else
      spinner-off "[${RED}FAILED${NC}]"
    fi
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log-footer
}
