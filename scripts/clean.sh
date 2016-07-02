#!/bin/bash

exec-command()
{
  echo -n "... Delete directory: kubernetes        "
  del-dir $BASEDIR/kubernetes/

  echo -n "... Delete directory: logs              "
  del-dir $BASEDIR/logs/
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
