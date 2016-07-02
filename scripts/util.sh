#!/bin/bash

if [ ! -f $BASEDIR/rpi-cluster-config ]; then
  echo "Configuration file 'rpi-cluster-config' does not exist, please set configuration first!"
  exit 1
fi
source $BASEDIR/rpi-cluster-config

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

source $BASEDIR/scripts/spinner.sh
source $BASEDIR/scripts/logger.sh
source $BASEDIR/scripts/service.sh
source $BASEDIR/scripts/is-status.sh

status-master()
{
  if [ "$(is-master-installed)" == "INSTALLED" ]; then
    if [ "$(is-master-enabled)" == "ENABLED" ]; then
      if [ "$(is-master-active)" == "ACTIVE" ]; then
        [ "$1" == "LOG" ] && echo "${GREEN}ENABLED${NC}" || echo "ENABLED"
      else
        [ "$1" == "LOG" ] && echo "${YELLOW}ENABLED - NOT ACTIVE${NC}" || echo "ENABLED - NOT ACTIVE"
      fi
    else
      [ "$1" == "LOG" ] && echo "${YELLOW}DISABLED${NC}" || echo "DISABLED"
    fi
  else
    [ "$1" == "LOG" ] && echo "${RED}NOT INSTALLED${NC}" || echo "NOT INSTALLED"
  fi   
}

status-worker()
{
  if [ "$(is-worker-installed)" == "INSTALLED" ]; then
    if [ "$(is-worker-enabled)" == "ENABLED" ]; then
      if [ "$(is-worker-active)" == "ACTIVE" ]; then
        [ "$1" == "LOG" ] && echo "${GREEN}ENABLED${NC}" || echo "ENABLED"
      else
        [ "$1" == "LOG" ] && echo "${YELLOW}ENABLED - NOT ACTIVE${NC}" || echo "ENABLED - NOT ACTIVE"
      fi
    else
      [ "$1" == "LOG" ] && echo "${YELLOW}DISABLED${NC}" || echo "DISABLED"
    fi
  else
    [ "$1" == "LOG" ] && echo "${RED}NOT INSTALLED${NC}" || echo "NOT INSTALLED"
  fi
}

