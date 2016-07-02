#!/bin/bash

exec-command()
{
  install
}

install()
{
  log-header "Install Kubernetes"

  log "- Install Kubernetes Master Configuration"
  install-config master

  log "- Install Kubernetes Master Service"
  install-service kubernetes-master /etc/systemd/system/kubernetes-master.service

  log "- Install Kubernetes Worker Configuration"
  install-config worker

  log "- Install Kubernetes Worker"
  install-service kubernetes-worker /etc/systemd/system/kubernetes-worker.service

  log-footer
}
