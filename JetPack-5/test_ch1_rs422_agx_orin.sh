#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sudo echo 353 > /sys/class/gpio/export
sudo echo 355 > /sys/class/gpio/export
sudo echo 354 > /sys/class/gpio/export
sudo echo 468 > /sys/class/gpio/export
sudo echo 352 > /sys/class/gpio/export

sudo echo low > /sys/class/gpio/PA.05/direction
sudo echo high > /sys/class/gpio/PA.07/direction
sudo echo high > /sys/class/gpio/PA.06/direction
sudo echo low > /sys/class/gpio/PX.06/direction
sudo echo low > /sys/class/gpio/PA.04/direction

sudo gtkterm -p /dev/ttyTHS1 -s 115200

sudo echo 353 > /sys/class/gpio/unexport
sudo echo 355 > /sys/class/gpio/unexport
sudo echo 354 > /sys/class/gpio/unexport
sudo echo 468 > /sys/class/gpio/unexport
sudo echo 352 > /sys/class/gpio/unexport

