#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sleep_time=0.3

sudo echo 406 > /sys/class/gpio/export
sudo echo out > /sys/class/gpio/PJ.00/direction
sudo echo 407 > /sys/class/gpio/export
sudo echo out > /sys/class/gpio/PJ.01/direction

sleep $sleep_time

echo "DIGITAL_OUT0 OFF"
sudo echo 0 > /sys/class/gpio/PJ.00/value
echo "DIGITAL_OUT1 OFF"
sudo echo 0 > /sys/class/gpio/PJ.01/value

#Single Test
echo "step: 1/15"
echo "DIGITAL_OUT0 ON"
sudo echo 1 > /sys/class/gpio/PJ.00/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
sudo echo 0 > /sys/class/gpio/PJ.00/value
sleep $sleep_time

echo "step: 2/15"
echo "DIGITAL_OUT1 ON"
sudo echo 1 > /sys/class/gpio/PJ.01/value
sleep $sleep_time
echo "DIGITAL_OUT1 OFF"
sudo echo 0 > /sys/class/gpio/PJ.01/value
sleep $sleep_time

#Double Test
echo "step: 5/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
sudo echo 1 > /sys/class/gpio/PJ.00/value
sudo echo 1 > /sys/class/gpio/PJ.01/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
sudo echo 0 > /sys/class/gpio/PJ.00/value
sudo echo 0 > /sys/class/gpio/PJ.01/value
sleep $sleep_time

echo "Completed"

sleep 1
sudo echo 1 > /sys/class/gpio/PJ.00/value
sudo echo 1 > /sys/class/gpio/PJ.01/value
sleep 1

sudo echo 406 > /sys/class/gpio/unexport
sudo echo 407 > /sys/class/gpio/unexport

