#!/bin/bash

exec-command()
{
  flash 
}

flash()
{

  if [[ "${OSTYPE}" != "darwin"* ]]; then
    echo "Flashing SD cards is only supported by Mac OSX."
    exit 1
  fi

  image=$HYPRIOT_OS_IMAGE
  filename=$(basename "${image}")
  extension="${filename##*.}"
  filename="${filename%.*}"

  log-header "Flash SD Card with Hypriot OS"

  download-and-extract
  try-to-find-disk
  flash-to-disk
  wait-for-boot
  config-boot
  unmount-disk

  log-footer
}

download-and-extract(){

  if [ -f "/tmp/${filename}" ]; then
    image=/tmp/${filename}
    log "Using cached Hypriot OS image"
    log-status "[${GREEN}OK${NC}]"
  else
    log "Download Hypriot OS image"
    spinner-on
    download /tmp/image.img.${extension} ${image}    
    image=/tmp/image.img.${extension}
    if [ -f $image ]; then
      spinner-off "[${GREEN}OK${NC}]"
    else
      spinner-off "[${RED}FAILED${NC}]"
    fi

    if [[ "$(file "${image}")" == *"Zip archive"* ]]; then
      log "Uncompress (zip)"
      spinner-on
      unzip -o "${image}" -d /tmp >> ${BASEDIR}/logs/console.log 2>&1 
      image=$(unzip -l "${image}" | grep --color=never -v Archive: | grep --color=never img | awk 'NF>1{print $NF}')
      image="/tmp/${image}"
    elif [[ "$(file "${image}")" == *"gzip compressed data"* ]]; then
      log "Uncompress (gzip)"
      spinner-on
      gzip -d "${image}" -c > /tmp/image.img >> ${BASEDIR}/logs/console.log 2>&1
      image=/tmp/image.img
    elif [[ "$(file "${image}")" == *"xz compressed data"* ]]; then
      log "Uncompress (xz)"
      spinner-on
      xz -d "${image}" -c > /tmp/image.img >> ${BASEDIR}/logs/console.log 2>&1
      image=/tmp/image.img
    else
      log "Unsupported file format"
      spinner-off "[${RED}FAILED${NC}]"
      exit 1 
    fi

    if [ -f $image ]; then
      spinner-off "[${GREEN}OK${NC}]"
    else
      spinner-off "[${RED}FAILED${NC}]"
    fi

  fi

}

try-to-find-disk(){

  while true; do
    disk=$(diskutil list | grep --color=never FDisk_partition_scheme | awk 'NF>1{print $NF}')
    if [ "${disk}" == "" ]; then
      log "No SD card found, please insert SD card"
      log-status "[${YELLOW}WAITING${NC}]"
      while [ "${disk}" == "" ]; do
        sleep 1
        disk=$(diskutil list | grep --color=never FDisk_partition_scheme | awk 'NF>1{print $NF}')
      done
    fi
    
    sleep 1 
    echo ""
    df -h
    echo ""
    while true; do
      read -rp "Is /dev/${disk} correct (y/n)? " yn
      case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) ;;
      esac
    done

    diskutil unmountDisk "/dev/${disk}s1" >> ${BASEDIR}/logs/console.log 2>&1
    diskutil unmountDisk "/dev/${disk}" >> ${BASEDIR}/logs/console.log 2>&1
    readonlymedia=$(diskutil info "/dev/${disk}" | grep "Read-Only Media" | awk 'NF>1{print $NF}')
    echo ""
    if [ "$readonlymedia" == "No" ]; then
      log "Unmount /dev/${disk}"
      log-status "[${GREEN}OK${NC}]"
      break
    else
      log "SD card is write protected"
      log-status "[${RED}FAILED${NC}]"
    fi
  done

}

flash-to-disk(){

  log "Flash image to /dev/${disk}"
  spinner-on
  sudo /bin/dd bs=1m if=${image} "of=/dev/r${disk}" >> ${BASEDIR}/logs/console.log 2>&1
  if [[ $? == 0 ]]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
    exit 1
  fi  

}

wait-for-boot(){

  log "Wait for partition"
  spinner-on
  boot=$(df | grep --color=never "/dev/${disk}s1" | /usr/bin/sed 's,.*/Volumes,/Volumes,')
  if [ "${boot}" == "" ]; then
    COUNTER=0
    while [ $COUNTER -lt 5 ]; do
      sleep 1
      boot=$(df | grep --color=never "/dev/${disk}s1" | /usr/bin/sed 's,.*/Volumes,/Volumes,')
      if [ "${boot}" != "" ]; then
        break
      fi
      let COUNTER=COUNTER+1
    done
    if [ "${boot}" == "" ]; then
      spinner-off "[${RED}FAILED${NC}]"
      exit 1
    else
      spinner-off "[${GREEN}OK${NC}]"
    fi
  else
    spinner-off "[${GREEN}OK${NC}]"
  fi

}

config-boot(){

  log "Set hostname and boot parameter"
  log-status "[${YELLOW}WAITING${NC}]"

  echo ""
  while [[ ${SD_HOSTNAME} == "" ]]; do
    read -rp "Please enter hostname for cluster node: " SD_HOSTNAME
  done
  echo ""
  
  /usr/bin/sed -i ".bak" -e "s/.*hostname:.*\$/hostname: ${SD_HOSTNAME}/" "${boot}/device-init.yaml" 
  /usr/bin/sed -i ".bak" -e "s/cgroup_enable=memory/cgroup_enable=memory cgroup_enable=cpuset/g" "${boot}/cmdline.txt"

}

unmount-disk(){

  log "Unmounting and ejecting /dev/${disk}"
  spinner-on
  sleep 1
  diskutil unmountDisk "/dev/${disk}s1" >> ${BASEDIR}/logs/console.log 2>&1
  diskutil unmountDisk "/dev/${disk}s2" >> ${BASEDIR}/logs/console.log 2>&1
  diskutil eject "/dev/${disk}" >> ${BASEDIR}/logs/console.log 2>&1
  if [ $? -eq 0 ]; then
    spinner-off "[${GREEN}OK${NC}]"
  else
    spinner-off "[${RED}FAILED${NC}]"
  fi

}



