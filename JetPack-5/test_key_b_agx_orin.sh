#sudo echo 446 > /sys/class/gpio/export
#sudo echo 350 > /sys/class/gpio/export
#sudo echo 452 > /sys/class/gpio/export
#sudo echo 444 > /sys/class/gpio/export

#sudo echo low > /sys/class/gpio/PP.06/direction
#sudo echo high > /sys/class/gpio/PA.02/direction
#sudo echo high > /sys/class/gpio/PQ.04/direction
#sudo echo high > /sys/class/gpio/PP.04/direction

trap interrupt_func INT
interrupt_func() {
	#sudo echo 446 > /sys/class/gpio/unexport
	#sudo echo 350 > /sys/class/gpio/unexport
	#sudo echo 452 > /sys/class/gpio/unexport
	#sudo echo 444 > /sys/class/gpio/unexport
	echo ""
}

watch -n 0.1 lsusb

