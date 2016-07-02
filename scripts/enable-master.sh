#!/bin/bash

exec-command()
{
  enable-master
}

enable-master()
{
  source $BASEDIR/disable.sh
  disable

  echo -n "... Enable Kubernetes Master   "
  spinner-on
  systemctl enable kubernetes-master
  systemctl start kubernetes-master
  if [  ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
