#!/bin/bash

remove-service()
{
  spinner-on
  K8S_MASTER_IS_ACTIVE=$(systemctl is-active $1)
  if [ "$IS_ACTIVE" == "active" ]; then
    systemctl stop $1
    IS_ACTIVE=$(systemctl is-active $1)
    if [ "$IS_ACTIVE" != "active" ]; then
      [ -f $2 ] && rm $2
      systemctl daemon-reload
      spinner-off "[${GREEN}OK${NC}]"
    else
      spinner-off "[${RED}FAILED${NC}]"
    fi
  else
    [ -f $2 ] && rm $2
    systemctl daemon-reload
    spinner-off "[${GREEN}OK${NC}]"
  fi
}

install-service()
{
  spinner-on
  cp $BASEDIR/src/$1.service $2
  systemctl daemon-reload

  IS_ENABLED=$(systemctl is-enabled $1)
  if [ "$IS_ENABLED" == "disabled" ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}

install-config()
{
  spinner-on
  mkdir -p /etc/kubernetes/$1
  cp $BASEDIR/src/kubernetes-$1.yaml /etc/kubernetes/$1/kubernetes-$1.yaml
  if [ -f /etc/kubernetes/$1/kubernetes-$1.yaml ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}

