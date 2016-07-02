#!/bin/bash

is-system-installed()
{
  if [ "$(is-master-installed)" == "INSTALLED" ] && [ "$(is-worker-installed)" == "INSTALLED" ]; then 
    [ "$1" == "LOG" ] && echo "${GREEN}INSTALLED${NC}" || echo "INSTALLED"
  else
    [ "$1" == "LOG" ] && echo "${RED}NOT INSTALLED${NC}" || echo "NOT INSTALLED"
  fi
}

is-master-installed()
{
  if [ -f /etc/kubernetes/master/kubernetes-master.yaml ] && [ -f /etc/systemd/system/kubernetes-master.service ]; then 
    [ "$1" == "LOG" ] && echo "${GREEN}INSTALLED${NC}" || echo "INSTALLED"
  else
    [ "$1" == "LOG" ] && echo "${RED}NOT INSTALLED${NC}" || echo "NOT INSTALLED"
  fi
}

is-worker-installed()
{
  if [ -f /etc/kubernetes/worker/kubernetes-worker.yaml ] && [ -f /etc/systemd/system/kubernetes-worker.service ]; then 
    [ "$1" == "LOG" ] && echo "${GREEN}INSTALLED${NC}" || echo "INSTALLED"
  else
    [ "$1" == "LOG" ] && echo "${RED}NOT INSTALLED${NC}" || echo "NOT INSTALLED"
  fi
}

is-master-active()
{
  if [ $(systemctl is-active kubernetes-master) == "active" ]; then
    [ "$1" == "LOG" ] && echo "${GREEN}ACTIVE${NC}" || echo "ACTIVE"
  else
    [ "$1" == "LOG" ] && echo "${RED}NOT ACTIVE${NC}" || echo "NOT ACTIVE"
  fi
}

is-worker-active()
{
  if [ $(systemctl is-active kubernetes-worker) == "active" ]; then
    [ "$1" == "LOG" ] && echo "${GREEN}ACTIVE${NC}" || echo "ACTIVE"
  else
    [ "$1" == "LOG" ] && echo "${RED}NOT ACTIVE${NC}" || echo "NOT ACTIVE"
  fi
}

is-master-enabled()
{
  if [ $(systemctl is-enabled kubernetes-master) == "enabled" ]; then
    [ "$1" == "LOG" ] && echo "${GREEN}ENABLED${NC}" || echo "ENABLED"
  else
    [ "$1" == "LOG" ] && echo "${RED}DISABLED${NC}" || echo "DISABLED"
  fi
}

is-worker-enabled()
{
  if [ $(systemctl is-enabled kubernetes-worker) == "enabled" ]; then
    [ "$1" == "LOG" ] && echo "${GREEN}ENABLED${NC}" || echo "ENABLED"
  else
    [ "$1" == "LOG" ] && echo "${RED}DISABLED${NC}" || echo "DISABLED"
  fi
}


