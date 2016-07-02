#!/bin/bash

exec-command()
{
  install-worker
}

install-master()
{
  source $BASEDIR/uninstall.sh
  source $BASEDIR/pull.sh
  source $BASEDIR/install.sh
  source $BASEDIR/enable-worker.sh

  uninstall
  pull
  install
  enable-master
}
