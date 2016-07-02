#!/bin/bash

exec-command()
{
  disable
}

disable()
{
  echo -n "... Stop and disable all Kubernetes Services  "
  spinner-on

  systemctl stop kubernetes-master
  systemctl disable kubernetes-master

  systemctl stop kubernetes-worker
  systemctl disable kubernetes-worker

  if [  ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
