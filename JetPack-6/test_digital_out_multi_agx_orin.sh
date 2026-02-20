#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sleep_time=0.3

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

DIGITAL_OUT0=`gpiofind "PJ.00"`
DIGITAL_OUT1=`gpiofind "PJ.01"`

run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT1 1

sleep $sleep_time

echo "DIGITAL_OUT0 OFF"
run_gpioset_out $DIGITAL_OUT0 0
echo "DIGITAL_OUT1 OFF"
run_gpioset_out $DIGITAL_OUT1 0

sleep $sleep_time

#Single Test
echo "step: 1/6"
echo "DIGITAL_OUT0 ON"
run_gpioset_out $DIGITAL_OUT0 1
sleep $sleep_time

echo "step: 2/6"
echo "DIGITAL_OUT0 OFF"
run_gpioset_out $DIGITAL_OUT0 0
sleep $sleep_time

echo "step: 3/6"
echo "DIGITAL_OUT1 ON"
run_gpioset_out $DIGITAL_OUT1 1
sleep $sleep_time

echo "step: 4/6"
echo "DIGITAL_OUT1 OFF"
run_gpioset_out $DIGITAL_OUT1 0
sleep $sleep_time

#Double Test
echo "step: 5/6"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT1 1
sleep $sleep_time

echo "step: 6/6"
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
run_gpioset_out $DIGITAL_OUT0 0
run_gpioset_out $DIGITAL_OUT1 0
sleep $sleep_time

echo "Completed"

sleep 1
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT1 1
sleep 1

