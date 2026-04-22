#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

# PWM1 - 3280000.pwm
echo 0 > /sys/class/pwm/pwmchip0/export
echo 5000000 > /sys/class/pwm/pwmchip0/pwm0/period
echo 2500000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable

# PWM5 - 32c0000.pwm
echo 0 > /sys/class/pwm/pwmchip2/export
echo 5000000 > /sys/class/pwm/pwmchip2/pwm0/period
echo 2500000 > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip2/pwm0/enable

cat /sys/kernel/debug/pwm

