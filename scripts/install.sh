#!/bin/bash

exec-command()
{
  install
}

install()
{

  # Check installation and service state
  if [[ "$(is-kubernetes-installed)" == "INSTALLED" ]] && [[ $(is-kubernetes-enabled) == "ENABLED" ]]; then
    echo ""
    echo "Disable Kubernetes first before you install."
    echo "Command: rpi-cluster disable" 
    log-footer
    exit 1
  fi

  log-header "Install Kubernetes"

  log "- Clone Kubernetes Deploy Repository"
  spinner-on 
  TMPDIR=$(mktemp -d) 
  git clone https://github.com/kubernetes/kube-deploy.git ${TMPDIR}/kube-deploy >> ${BASEDIR}/logs/console.log 2>&1 
  if [ -d ${TMPDIR}/kube-deploy ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log "- Patch Kubernetes Deploy Source"
  spinner-on
  pushd ${TMPDIR}/kube-deploy > /dev/null 
  git config --local user.email "rpi-cluster"
  git config --local user.name "rpi-cluster"
  git am --whitespace=nowarn ${BASEDIR}/src/*.patch >> ${BASEDIR}/logs/console.log 2>&1
  popd > /dev/null 
  if [ -f ${TMPDIR}/kube-deploy/docker-multinode/kubernetes.sh ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log "- Copy Kubernetes start/stop scripts"
  spinner-on
  K8S_ETC_DIR=/etc/kubernetes
  K8S_SCRIPTS_DIR=${K8S_ETC_DIR}/scripts
  rm -rf ${K8S_ETC_DIR}
  mkdir -p ${K8S_SCRIPTS_DIR}
  cp ${TMPDIR}/kube-deploy/docker-multinode/common.sh ${K8S_SCRIPTS_DIR} 
  cp ${TMPDIR}/kube-deploy/docker-multinode/kubernetes.sh ${K8S_SCRIPTS_DIR} 
  cp ${TMPDIR}/kube-deploy/docker-multinode/master.sh ${K8S_SCRIPTS_DIR} 
  cp ${TMPDIR}/kube-deploy/docker-multinode/turndown.sh ${K8S_SCRIPTS_DIR} 
  cp ${TMPDIR}/kube-deploy/docker-multinode/worker.sh ${K8S_SCRIPTS_DIR} 
  cp ${BASEDIR}/src/kubernetes.service /etc/systemd/system/
  cp ${BASEDIR}/src/kubernetes-profile.d /etc/profile.d/kubernetes.sh
  cat << EOF > ${K8S_ETC_DIR}/k8s.conf 
MASTER_IP="${MASTER_IP}"
OFFLINE_MODE="true"
K8S_VERSION="v${KUBERNETES_VERSION}"

SILENT_MODE="true"

#STOP_ALL_CONTAINERS_IN_SILENT_MODE="Y"
#CLEAN_KUBELET_DIR_IN_SILENT_MODE="Y"

#ETCD_VERSION="${ETCD_VERSION}"

#FLANNEL_VERSION="${FLANNELD_VERSION}"
#FLANNEL_IPMASQ="true"
#FLANNEL_BACKEND="udp"
#FLANNEL_NETWORK="10.1.0.0/16"

#RESTART_POLICY="unless-stopped"

#ARCH="arm"

#NET_INTERFACE="eth0"
EOF
  if [ -f /etc/systemd/system/kubernetes.service ] && \
     [ -f /etc/profile.d/kubernetes.sh ] && \
     [ -f ${K8S_ETC_DIR}/k8s.conf ] && \
     [ -f ${K8S_ETC_DIR}/scripts/kubernetes.sh ] && \
     [ -f ${K8S_ETC_DIR}/scripts/master.sh ] && \
     [ -f ${K8S_ETC_DIR}/scripts/turndown.sh ] && \
     [ -f ${K8S_ETC_DIR}/scripts/worker.sh ]; then 
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log "- Reload Kubernetes Service"
  spinner-on
  systemctl daemon-reload
  if [ "$(is-kubernetes-installed)" == "INSTALLED" ] && [ "$(is-kubernetes-enabled)" == "DISABLED" ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

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
  rm -rf ${TMPDIR}
  rm -rf ${TMP_K8S_DIR}
  if [ ! -d ${TMPDIR} ] && [ ! -d ${TMP_K8S_DIR} ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

  log-footer
}

