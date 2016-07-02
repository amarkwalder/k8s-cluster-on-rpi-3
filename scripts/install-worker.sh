#!/bin/bash

exec-command()
{
  install-master
}

install-master()
{
  source $BASEDIR/uninstall.sh
  source $BASEDIR/pull.sh
  source $BASEDIR/install.sh
  source $BASEDIR/enable-master.sh

  uninstall
  pull
  install
  enable-master
}
