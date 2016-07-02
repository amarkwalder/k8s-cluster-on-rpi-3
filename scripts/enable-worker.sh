#!/bin/bash

exec-command()
{
  enable-worker
}

enable-worker()
{
  log-header "Enable Kubernetes Worker"

  source $BASEDIR/scripts/disable.sh
  disable-master
  disable-worker

  log "- Enable Kubernetes Worker"
  spinner-on

  if [[ $( is-system-installed ) == "INSTALLED" ]]; then
    systemctl enable kubernetes-worker >> ${BASEDIR}/logs/console.log 2>&1
    systemctl start kubernetes-worker >> ${BASEDIR}/logs/console.log 2>&1
    IS_ENABLED_MASTER=$(is-master-enabled)
    IS_ENABLED_WORKER=$(is-worker-enabled)
    if [ "$IS_ENABLED_MASTER" == "DISABLED" ] && [ "$IS_ENABLED_WORKER" == "ENABLED" ]; then
      spinner-off "[${GREEN}OK${NC}]"
    else
      spinner-off "[${RED}FAILED${NC}]"
    fi
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log-footer
}
