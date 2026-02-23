#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sudo echo 470 > /sys/class/gpio/export
sudo echo 472 > /sys/class/gpio/export
sudo echo 478 > /sys/class/gpio/export
sudo echo 477 > /sys/class/gpio/export
sudo echo 474 > /sys/class/gpio/export

sudo echo low > /sys/class/gpio/PY.00/direction
sudo echo high > /sys/class/gpio/PY.02/direction
sudo echo low > /sys/class/gpio/PZ.00/direction
sudo echo high > /sys/class/gpio/PY.07/direction
sudo echo low > /sys/class/gpio/PY.04/direction

sudo gtkterm -p /dev/ttyTHS4 -s 115200

sudo echo 470 > /sys/class/gpio/unexport
sudo echo 472 > /sys/class/gpio/unexport
sudo echo 478 > /sys/class/gpio/unexport
sudo echo 477 > /sys/class/gpio/unexport
sudo echo 474 > /sys/class/gpio/unexport

