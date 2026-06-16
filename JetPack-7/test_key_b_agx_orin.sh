#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

#gpiochip0 - tegra234-gpio
#gpiochip1 - tegra234-gpio-aon

function run_gpioset_out {
	# $1 -> GPIO chip
	# $2 -> GPIO index
	# $3 -> output value

	# If there is a gpioset command working in background (for the selected GPIO), kill it
	for pid in `ps -ef | grep "$1 $2" | awk '{print $2}'` ; do
		if [ $(ps $pid | grep "gpioset" | wc -l) -ne 0 ]; then
			kill $pid
		fi
	done

	# Run the gpioset command in background (to keep the GPIO value continuously)
	gpioset --mode=signal $1 $2=$3 &
}

M2B_RESET=`gpiofind "PP.06"`
M2B_FULLCARDPWRON=`gpiofind "PA.02"`
M2B_WENABLE1=`gpiofind "PQ.04"`
M2B_WENABLE2=`gpiofind "PP.04"`
#run_gpioset_out $M2B_RESET 0
#run_gpioset_out $M2B_FULLCARDPWRON 1
#run_gpioset_out $M2B_WENABLE1 1
#run_gpioset_out $M2B_WENABLE2 1

watch -n 0.1 lsusb

