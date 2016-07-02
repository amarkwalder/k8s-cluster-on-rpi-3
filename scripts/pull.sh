#!/bin/bash

exec-command()
{
  pull
}

pull()
{
  echo -n "... Pulling ETCD      "
  pull-img gcr.io/google_containers/etcd-arm:${ETCD_VERSION}

  echo -n "... Pulling FLANNELD  "
  pull-img gcr.io/google_containers/flannel-arm:${FLANNELD_VERSION}

  echo -n "... Pulling HYPERKUBE "
  pull-img gcr.io/google_containers/hyperkube-arm:v${HYPERKUBE_VERSION}

}

pull-img()
{
  spinner-on
  docker pull $1 >> ${BASEDIR}/logs/console.log 2>&1

  if [ $(docker images $1 | wc -l) -eq 2 ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
