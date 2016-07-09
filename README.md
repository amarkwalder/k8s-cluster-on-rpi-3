# Kubernetes Cluster on Raspberry Pi 3

## Prepare RPI 

### Clone RPI Cluster Repository
To start with flashing the SD cards for the Raspberry Pi 3, you have to clone the "Kubernetes Cluster on RPI 3" Repository to your local machine.
```
git clone http://github.com/amarkwalder/k8s-cluster-on-rpi
```

### Flash SD Card for RPI
Each Raspberry Pi requires an SD card with an operating system installed. The Kubernetes Cluster requires Docker to run, therefore
we decided to use Hypriot OS (http://blog.hypriot.com) which will be downloaded during the flashing process.
To start the flash process start the shell script from the cloned repository.
```
cd k8s-cluster-on-rpi
. ./rpi-cluster flash
```
Answer all the questions and insert the SD card when requested.
After the SD card has been prepared, go to the next chapter and boot the Raspberry.
 
### Boot and prepare RPI

## Install Kubernetes Master and Worker Nodes 

### Clone RPI Cluster Repository to RPI
### Install Kubernetes Server and Client

## Test it out 
