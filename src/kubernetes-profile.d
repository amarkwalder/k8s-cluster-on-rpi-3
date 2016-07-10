. /etc/kubernetes/k8s.conf

docker-bootstrap(){
  /usr/bin/docker -H unix:///var/run/docker-bootstrap.sock "$@"
}

docker(){
  /usr/bin/docker -H unix:///var/run/docker.sock "$@"
}

docker-bootstrap-rm-stopped(){
  CIDS=$(docker-bootstrap ps --filter status=exited -aq)
  if [[ ! -z ${CIDS} ]]; then
    docker-bootstrap rm ${CIDS} 
  fi
}

docker-rm-stopped(){ 
  CIDS=$(docker ps --filter status=exited -aq)
  if [[ ! -z ${CIDS} ]]; then
    docker rm ${CIDS} 
  fi
}

docker-bootstrap-rm-all(){
  CIDS=$(docker-bootstrap ps -aq)
  if [[ ! -z ${CIDS} ]]; then
    docker-bootstrap rm ${CIDS}
  fi
}

docker-rm-all(){
  CIDS=$(docker ps -aq)
  if [[ ! -z ${CIDS} ]]; then
    docker rm ${CIDS}
  fi
}

kubectl(){
  /usr/bin/kubectl -s ${MASTER_IP}:8080 $@
}

reboot-nodes(){
  for i in $@
  do
    echo "Reboot Node $i"
    ssh $i "sudo reboot < /dev/null > /tmp/reboot.log 2>&1 &"
  done
}

shutdown-nodes(){
  for i in $@
  do
    echo "Shutdown Node $i"
    ssh $i "sudo shutdown now < /dev/null > /tmp/shutdown.log 2>&1 &"
  done
}


