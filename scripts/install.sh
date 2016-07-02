#!/bin/bash

exec-command()
{
  install
}

install()
{
  stop-kubernetes-master
  stop-kubernetes-worker
  install-kubernetes
}

stop-kubernetes-master()
{
  echo -n "... Stopping Kubernetes Master  "
  spinner-on
  systemctl stop kubernetes-master
  if [  ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}

stop-kubernetes-worker()
{
  echo -n "... Stopping Kubernetes Worker  "
  spinner-on
  systemctl stop kubernetes-worker
  if [  ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}

install-kubernetes()
{
  echo -n "... Install Kubernetes  "
  spinner-on
  [ -f /etc/kubernetes ] && rm -rf /etc/kubernetes
  mkdir -p /etc/kubernetes/master
  cp $BASEDIR/src/kubernetes-master.service /etc/systemd/system/
  cp $BASEDIR/src/kubernetes-master.yaml /etc/kubernetes/master/kubernetes-master.yaml
  cp $BASEDIR/src/kubernetes-worker.service /etc/systemd/system/
  cp $BASEDIR/src/kubernetes-worker.yaml /etc/kubernetes/worker/kubernetes-worker.yaml
  systemctl daemon-reload
  if [  ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
