#!/bin/bash

exec-command()
{
  install-client
}

install-client()
{

  log-header "Install Kubernetes Client"

  log "- Download and Install Kubernetes Client Binary"
  spinner-on
  TMP_K8S_DIR=$(mktemp -d)
  download ${TMP_K8S_DIR}/kubernetes.tar.gz https://github.com/kubernetes/kubernetes/releases/download/v${KUBERNETES_VERSION}/kubernetes.tar.gz
  pushd ${TMP_K8S_DIR} > /dev/null
  tar xzvf kubernetes.tar.gz kubernetes/platforms/linux/arm/kubectl > /dev/null
  cp ${TMP_K8S_DIR}/kubernetes/platforms/linux/arm/kubectl /usr/bin/ 
  popd > /dev/null
  if [ -d ${TMP_K8S_DIR}/kubernetes ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log "- Cleanup temporary directory"
  spinner-on
  rm -rf ${TMP_K8S_DIR}
  if [ ! -d ${TMP_K8S_DIR} ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log-footer
}

