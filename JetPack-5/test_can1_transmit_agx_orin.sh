#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

#sudo busybox devmem 0x0c303000 32 0x0000C400
#sudo busybox devmem 0x0c303008 32 0x0000C458

sudo modprobe can
sudo modprobe can_raw
sudo modprobe mttcan
sudo ip link set can1 type can bitrate 500000 dbitrate 2000000 berr-reporting on fd on
sudo ip link set up can1

trap interrupt_func INT
interrupt_func() {
	sudo ip link set can1 down
	read -p 'Press [Enter] to exit' quit_key
}

cangen can1 -v

