#!/bin/bash

exec-command()
{
  download
}

download()
{
  log-header "Download & Extract Kubernetes" 

  log "Download Kubernetes"
  download-kubernetes https://github.com/kubernetes/kubernetes/releases/download/v${KUBERNETES_VERSION}/kubernetes.tar.gz $BASEDIR/build/kubernetes/

  log "Extract Kubernetes Server (ARM)" 
  extract $BASEDIR/build/kubernetes/server/kubernetes-server-linux-arm.tar.gz $BASEDIR/build/kubernetes-server-linux-arm/

#  log "Extract Kubernetes Server (ARM64)"
#  extract $BASEDIR/build/kubernetes/server/kubernetes-server-linux-arm64.tar.gz $BASEDIR/build/kubernetes-server-linux-arm64/

#  log "Extract Kubernetes Server (AMD64)"
#  extract $BASEDIR/build/kubernetes/server/kubernetes-server-linux-amd64.tar.gz $BASEDIR/build/kubernetes-server-linux-amd64/

#  log "Extract Kubernetes Server (PPC64)"
#  extract $BASEDIR/build/kubernetes/server/kubernetes-server-linux-ppc64le.tar.gz $BASEDIR/build/kubernetes-server-linux-ppc64le/

  log "Extract Kubernetes Manifests"
  extract $BASEDIR/build/kubernetes/server/kubernetes-manifests.tar.gz $BASEDIR/build/kubernetes-manifests/

  log "Extract Kubernetes Salt"
  extract $BASEDIR/build/kubernetes/server/kubernetes-salt.tar.gz $BASEDIR/build/kubernetes-salt/
  
  log-footer
}

download-kubernetes()
{
  spinner-on
  mkdir -p $2 
  curl -sSL $1 | tar -C $2 -xz --strip-components=1
  if [ -f $2/version ] && [[ $(cat $2/version) =~ "v${KUBERNETES_VERSION}" ]]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}

extract()
{
  spinner-on
  rm -rf $2
  mkdir -p $2
  tar -C $2 -xzf $1 --strip-components=1
  if [ -d $2 ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi
}
