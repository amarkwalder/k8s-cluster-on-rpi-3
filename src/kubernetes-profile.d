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
