#!/bin/bash

exec-command()
{
  enable-worker
}

enable-worker()
{
  source $BASEDIR/disable.sh
  disable

  echo -n "... Enable Kubernetes Worker   "
  spinner-on
  systemctl enable kubernetes-worker
  systemctl start kubernetes-worker
  if [  ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
