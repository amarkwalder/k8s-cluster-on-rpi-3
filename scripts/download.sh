#!/bin/bash

exec-command()
{
  download $BASEDIR/kubernetes
}

download()
{
  echo -n "... Download Kubernetes  "
  spinner-on
  mkdir -p $1
  curl -sSL https://github.com/kubernetes/kubernetes/releases/download/v${KUBERNETES_VERSION}/kubernetes.tar.gz | tar -C $1 -xz --strip-components=1

  if [ -f $BASEDIR/kubernetes/version ] && [[ $(cat $BASEDIR/kubernetes/version) =~ "v${KUBERNETES_VERSION}" ]]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
