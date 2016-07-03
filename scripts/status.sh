#!/bin/bash

exec-command()
{
  status 
}

status()
{
  log-header "Status Kubernetes" "EMPTY"

  log "RPI Cluster" && green $RPI_CLUSTER_VERSION
  log "Kubernetes" &&  green $KUBERNETES_VERSION
  log "Etc" &&         green $ETCD_VERSION
  log "Flannel" &&     green $FLANNELD_VERSION
  log "Hyperkube" &&   green $HYPERKUBE_VERSION
  log "Pause" &&       green $PAUSE_VERSION

  echo ""

  log "Kubernetes Master" && printf "$(status-master LOG)\n" 
  log "Kubernetes Worker" && printf "$(status-worker LOG)\n" 

  echo ""
}

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

red()
{
  printf "${RED}$1${NC}\n"
}

green()
{
  printf "${GREEN}$1${NC}\n"
}
