#!/bin/bash

exec-command()
{
  install-client $@
}

install-client()
{
  if [ "$1" == "" ]; then
    echo ""
    echo "Argument is missing."
    echo "Command: rpi-cluster install-client [ARCH]"
    log-footer
    exit 1
  fi

  log-header "Install Kubernetes Client"

  log "- Install Kubernetes Binaries"
  ARCH=$1
  install-binaries 

  log-footer
}

install-binaries()
{
  echo ""
  copy kubectl
}

copy()
{
  log "  - $1 ($ARCH)"
  spinner-on
  BINDIR=$BASEDIR/build/kubernetes-server-linux-$ARCH/server/bin/
  cp $BINDIR/$1 /usr/bin
  if [ -f /usr/bin/$1 ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}



