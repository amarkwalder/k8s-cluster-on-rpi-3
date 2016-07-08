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

log-header()
{
  printf "%s\n" ""
  if [ "$2" == "EMPTY" ]; then
    printf "%-50s%s\n" "$1" ""
  elif [ "$2" != "" ]; then
    printf "%-50s%s\n" "$1" "$2"
  else
    printf "%-50s%s\n" "$1" "[STATUS]"
  fi
  repeat "-" 65
  printf "\n"
}

log()
{
  printf "%-50s" "$1"
}

log-footer()
{
  printf "%s\n" ""
  source $BASEDIR/scripts/status.sh
  status
}

red()
{
  printf "${RED}$1${NC}\n"
}

green()
{
  printf "${GREEN}$1${NC}\n"
}

repeat() {
  str=$1
  num=$2
  v=$(printf "%-${num}s" "$str")
  printf "%s" "${v// /$str}"
}

is-master-or-worker()
{
  MY_IP=$(hostname -I | awk '{print $1}')
  if [[ ${MY_IP} == ${MASTER_IP} ]] || [[ -z ${MASTER_IP} ]]; then
    [ "$1" == "LOG" ] && echo "${GREEN}MASTER${NC}" || echo "MASTER"
  else
    [ "$1" == "LOG" ] && echo "${GREEN}WORKER${NC}" || echo "WORKER"
  fi
}

is-kubernetes-installed()
{
  if [ -f /etc/kubernetes/k8s.conf ] && [ -f /etc/systemd/system/kubernetes.service ]; then
    [ "$1" == "LOG" ] && echo "${GREEN}INSTALLED${NC}" || echo "INSTALLED"
  else
    [ "$1" == "LOG" ] && echo "${RED}NOT INSTALLED${NC}" || echo "NOT INSTALLED"
  fi
}

is-kubernetes-active()
{
  if [ "$(systemctl is-active kubernetes)" == "active" ]; then
    [ "$1" == "LOG" ] && echo "${GREEN}ACTIVE${NC}" || echo "ACTIVE"
  else
    [ "$1" == "LOG" ] && echo "${RED}NOT ACTIVE${NC}" || echo "NOT ACTIVE"
  fi
}

is-kubernetes-enabled()
{
  if [ "$(systemctl is-enabled kubernetes)" == "enabled" ]; then
    [ "$1" == "LOG" ] && echo "${GREEN}ENABLED${NC}" || echo "ENABLED"
  else
    [ "$1" == "LOG" ] && echo "${RED}DISABLED${NC}" || echo "DISABLED"
  fi
}

status-kubernetes()
{
  if [ "$(is-kubernetes-installed)" == "INSTALLED" ]; then
    if [ "$(is-kubernetes-enabled)" == "ENABLED" ]; then
      if [ "$(is-kubernetes-active)" == "ACTIVE" ]; then
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

spinner-on()
{
  local i sp n
  sp="/-\|"
  n=${#sp}
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
