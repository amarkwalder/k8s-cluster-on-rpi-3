#!/bin/bash

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

repeat() {
  str=$1
  num=$2
  v=$(printf "%-${num}s" "$str")
  printf "%s" "${v// /$str}"
}
