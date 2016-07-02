#!/bin/bash

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
