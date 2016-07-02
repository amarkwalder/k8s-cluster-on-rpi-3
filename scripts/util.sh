#!/bin/bash

if [ ! -f $BASEDIR/rpi-cluster-config ]; then
  echo "Configuration file 'rpi-cluster-config' does not exist, please set configuration first!"
  exit 1
fi
source $BASEDIR/rpi-cluster-config

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

spinner-on()
{
  local i sp n
  sp="/-\|"
  n=${#sp}
#  printf " "
  ( while sleep 0.1; do
      printf "%s\b" "${sp:i++%n:1}"
    done
  ) &
  PID=$!
  disown
}

spinner-off()
{
  kill $PID
  printf "%s\b" " "
  printf "$1\n"
}
