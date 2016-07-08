#!/bin/bash

exec-command()
{
  cat << EOF
rpi-cluster   ${RPI_CLUSTER_VERSION} 
kubernetes    ${KUBERNETES_VERSION} 
etcd          ${ETCD_VERSION} 
flannel       ${FLANNELD_VERSION} 
EOF
}
