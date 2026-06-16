#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

HALF_FULL=`gpiofind "PY.00"`
HALF_FULL_VAL=1
RS422_232=`gpiofind "PY.02"`
RS422_232_VAL=1
TX_ENABLE=`gpiofind "PZ.00"`
TX_ENABLE_VAL=1
RX_DISABLE=`gpiofind "PY.07"`
RX_DISABLE_VAL=1
TERM_RESIST=`gpiofind "PY.04"`
TERM_RESIST_VAL=0

gpioset --mode=signal $HALF_FULL=$HALF_FULL_VAL &
PID_HALF_FULL=$!
gpioset --mode=signal $RS422_232=$RS422_232_VAL &
PID_RS422_232=$!
gpioset --mode=signal $TX_ENABLE=$TX_ENABLE_VAL &
PID_TX_ENABLE=$!
gpioset --mode=signal $RX_DISABLE=$RX_DISABLE_VAL &
PID_RX_DISABLE=$!
gpioset --mode=signal $TERM_RESIST=$TERM_RESIST_VAL &
PID_TERM_RESIST=$!

sudo gtkterm -p /dev/ttyTHS3 -s 115200 -w RS485

kill $PID_HALF_FULL
kill $PID_RS422_232
kill $PID_TX_ENABLE
kill $PID_RX_DISABLE
kill $PID_TERM_RESIST

