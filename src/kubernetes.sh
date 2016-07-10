#!/bin/bash

kube::multinode::service-main(){

  BASEDIR=$(dirname "$0")
  source ${BASEDIR}/common.sh

  # 1.) Environment variable CONFIG
  # 2.) Location: CONFIG=/etc/kubernetes/k8s.conf.
  # 3.) Location: CONFIG=$(dirname "$0")/k8s.conf
  # 4.) Location: CONFIG=./k8s.conf
  # 5.) Using default values
  if [[ ${CONFIG} != "" ]] && [[ -f ${CONFIG} ]]; then
    CONFIG=$(realpath ${CONFIG})
    kube::log::status "Configuration: Loading configuration values from [${CONFIG}]"
    . ${CONFIG}
  elif [[ -f /etc/kubernetes/k8s.conf ]]; then
    CONFIG=$(realpath /etc/kubernetes/k8s.conf)
    kube::log::status "Configuration: Loading configuration values from [${CONFIG}]"
    . ${CONFIG}
  elif [[ -f $(dirname "$0")/k8s.conf ]]; then
    CONFIG=$(realpath $(dirname "$0")/k8s.conf)
    kube::log::status "Configuration: Loading configuration values from [${CONFIG}]"
    . ${CONFIG}
  elif [[ -f ./k8s.conf ]]; then
    CONFIG=$(realpath ./k8s.conf)
    kube::log::status "Configuration: Loading configuration values from [$(realpath $CONFIG)]"
    . $CONFIG
  else
    CONFIG=
    kube::log::status "Configuration: Using default values"
  fi

  case "$1" in
    start)
      kube::multinode::service-start
      ;;
    stop)
      kube::multinode::service-stop
      ;;
    *)
      kube::log::status "Invalid argument '$1' passed to script"
      ;;
  esac

}

kube::multinode::service-start(){

  MY_IP=$(hostname -I | awk '{print $1}')

  kube::log::status "My IP     : ${MY_IP}"
  kube::log::status "Master IP : ${MASTER_IP}"

  if [[ ${MY_IP} == ${MASTER_IP} ]] || [[ -z ${MASTER_IP} ]]; then
    kube::log::status "Start Kubernetes MASTER on this node..."
    . ${BASEDIR}/master.sh
  else
    kube::log::status "Start Kubernetes WORKER on this node..."
    . ${BASEDIR}/worker.sh
  fi

}

kube::multinode::service-stop(){

  . ${BASEDIR}/turndown.sh

}

kube::multinode::service-main $@
