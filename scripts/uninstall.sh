#!/bin/bash

exec-command()
{
  uninstall
}

uninstall()
{
  source $BASEDIR/install.sh
  stop-kubernetes-master
  stop-kubernetes-worker

  echo -n "... Unnstall Kubernetes  "
  spinner-on
  [ -f /etc/kubernetes ] && rm -rf /etc/kubernetes
  mkdir -p /etc/kubernetes/master
  rm /etc/systemd/system/kubernetes-master.service
  rm /etc/systemd/system/kubernetes-worker.service
  systemctl daemon-reload
  if [  ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
