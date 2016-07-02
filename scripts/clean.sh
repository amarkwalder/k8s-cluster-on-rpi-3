#!/bin/bash

exec-command()
{
  clean
}

clean()
{

  log-header "Clean directory"

  log "- Delete directory: kubernetes"
  del-dir $BASEDIR/kubernetes/

  log "- Delete directory: logs"
  del-dir $BASEDIR/logs/

  log-footer
}

del-dir()
{
  spinner-on
  [ -f $1 ] && rm -rf $1

  if [ -f $1 ]; then
    spinner-off "[${RED}FAILED${NC}]"
  else
    spinner-off "[${GREEN}OK${NC}]"
  fi
}
