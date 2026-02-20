#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

watch -n 0.1 gpioget `gpiofind "PA.00"`

