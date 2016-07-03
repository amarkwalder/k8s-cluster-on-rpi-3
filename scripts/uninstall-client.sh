#!/bin/bash

exec-command()
{
  uninstall-client
}

uninstall-client()
{
  log-header "Remove Kubernetes (Client)" 

  log "- Uninstall Kubernetes (Binaries)"
  echo ""
  remove kubectl

  log-footer
}

remove()
{
  log "  - $1"
  spinner-on
  rm -f /usr/bin/$1
  if [ -f /usr/bin/$1 ]; then
    spinner-off "[${RED}FAILED${NC}]"
  else
    spinner-off "[${GREEN}OK${NC}]"
  fi
}
