#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	echo "Quitting ..."
	exit 1
fi

# Check the scipts' folder
SCRIPTS_FOLDER=${PWD}
if [ $# -eq 1 ]; then
	SCRIPTS_FOLDER=$1
fi
if [ $# -gt 1 ]; then
	echo "Please type test scripts' folder path"
	echo "Please run as:"
	echo "sudo $0 <test_scripts'_full_path>"
	echo "Quitting ..."
	exit 1
fi
if [ -d "$SCRIPTS_FOLDER" ]; then
	if [ "${SCRIPTS_FOLDER: -1}" != "/" ]; then
		SCRIPTS_FOLDER="$SCRIPTS_FOLDER/"
	fi
	echo "$SCRIPTS_FOLDER folder exists"
	chmod +x $SCRIPTS_FOLDER/iperf3_*.sh
	chmod +x $SCRIPTS_FOLDER/test_*.sh
	echo "All script files made executable"
else
	echo "$SCRIPTS_FOLDER folder does not exist"
	echo "Quitting ..."
	exit 1
fi

function apt_install_pkg {
	REQUIRED_PKG=$1
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo "Checking for $REQUIRED_PKG: $PKG_OK"
	if [ "" = "$PKG_OK" ]; then
		echo ""
		echo "$REQUIRED_PKG not found. Setting it up..."
		sudo apt-get --yes install $REQUIRED_PKG 

		PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
		echo ""
		echo "Checking for $REQUIRED_PKG: $PKG_OK"

		if [ "" = "$PKG_OK" ]; then
			echo ""
			echo "$REQUIRED_PKG not installed. Please try again later"
			exit 1
		fi

	fi
}

# Check GtkTerm installed
apt_install_pkg 'gtkterm'

# Check gpiod installed
apt_install_pkg 'gpiod'

# Check nvidia-l4t-gstreamer installed for CSI tests
apt_install_pkg 'nvidia-l4t-gstreamer'


function check_nvgetty_service {
	echo -n "nvgetty.service status: "
	if [ "$(systemctl is-enabled nvgetty.service)" = "enabled" ]; then
		echo "enabled"
		sleep 2
		sudo systemctl disable nvgetty.service
		echo "Service disabled, rebooting now ..."
		sleep 10
		sudo reboot
	elif [ "$(systemctl is-enabled nvgetty.service)" = "disabled" ]; then
		echo "disabled"
	else
		echo "Failed to get unit file state -> No such file or directory"
		echo "Skipping..."
	fi
}


function test_menu {
	continue_test=true

	while $continue_test; do
		sleep 1
		echo ""
		echo "****************************"
		echo "*** Production Test Menu ***"
		echo "1) Previous Tests"
		echo "2) Disks (M.2 SSD) Test"
		echo "3) Network Speed Test"
		echo "4) Local Network Test (iperf3)"
		echo "5) Public Network Test (ping)"
		echo "6) USB Test"
		echo "7) M.2 Key-B Test"
		echo "8) RS-232_0 Test"
		echo "9) RS-422_0 Test"
		echo "10) RS-485_0 Write Test"
		echo "11) RS-485_0 Read Test"
		echo "12) RS-232_1 Test"
		echo "13) RS-422_1 Test"
		echo "14) RS-485_1 Write Test"
		echo "15) RS-485_1 Read Test"
		echo "16) CAN Bus-0 (Transmit) Test"
		echo "17) CAN Bus-0 (Receive) Test"
		echo "18) CAN Bus-1 (Transmit) Test"
		echo "19) CAN Bus-1 (Receive) Test"
		echo "20) Digital Out Test"
		echo "21) Digital In-0 Test"
		echo "22) Digital In-1 Test"
		echo "23) 6-AXIS IMU & Temperature Sensor Test"
		echo "24) Fan Test"
		read -p "Type the test number (or quit) [1/.../q]: " choice
		echo ""

		case $choice in
			1 ) 
				echo "* Set the device in recovery mode, connect recovery USB and check the device in recovery mode with lsusb (0955:7*23)"
				echo "* Reset the device, connect Debug UART and check the serial connection"
				;;
			2 )
				echo "Check M.2 SSD and SD card detected"
				gnome-terminal -- gnome-disks
				;;
			3 )
				echo "Network Speed Test"
				gnome-terminal -- $SCRIPTS_FOLDER/test_net_speed.sh
				;;
			4 )
				echo "Local Network Test"
				read -p "Server or Client (s/c): " network_choice
				case $network_choice in
					[Ss]* )
						gnome-terminal -- $SCRIPTS_FOLDER/iperf3_server.sh
						;;
					[Cc]* )
						gnome-terminal -- $SCRIPTS_FOLDER/iperf3_client.sh
						;;
					* )
						echo "Wrong choice"
						;;
				esac
				;;
			5 )
				echo "Public Network Test"
				gnome-terminal -- $SCRIPTS_FOLDER/test_public_net.sh
				;;
			6 )
				echo "USB Test"
				gnome-terminal -- watch -n 0.1 lsusb
				;;
			7 )
				echo "M.2 Key-B Test"
				gnome-terminal -- watch -n 0.1 lsusb
				;;
			8 )
				echo "RS232_0 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs232_agx_orin.sh
				;;
			9 )
				echo "RS422_0 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs422_agx_orin.sh
				;;
			10 )
				echo "RS485_0 Write Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs485_write_agx_orin.sh
				;;
			11 )
				echo "RS485_0 Read Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs485_read_agx_orin.sh
				;;
			12 )
				echo "RS232_1 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs232_agx_orin.sh
				;;
			13 )
				echo "RS422_1 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs422_agx_orin.sh
				;;
			14 )
				echo "RS485_1 Write Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs485_write_agx_orin.sh
				;;
			15 )
				echo "RS485_1 Read Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs485_read_agx_orin.sh
				;;
			16 )
				echo "CAN Bus-0 (Transmit) Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can0_transmit_agx_orin.sh
				;;
			17 )
				echo "CAN Bus-0 (Receive) Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can0_receive_agx_orin.sh
				;;
			18 )
				echo "CAN Bus-1 (Transmit) Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can1_transmit_agx_orin.sh
				;;
			19 )
				echo "CAN Bus-1 (Receive) Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can1_receive_agx_orin.sh
				;;
			20 )
				echo "Digital Out Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_out_multi_agx_orin.sh
				;;
			21 )
				echo "Digital In-0 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_in0_agx_orin.sh
				;;
			22 )
				echo "Digital In-1 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_in1_agx_orin.sh
				;;
			23 )
				echo "6-AXIS IMU & Temperature Sensor Test"
				if [[ $(i2cget -f -y 7 0x6b 0x0f) == "0x6a" ]]; then
					gnome-terminal -- watch i2cdump -f -y 7 0x6b
				else
					echo "Could not found"
				fi
				;;
			24 )
				echo "Fan Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_fan.sh
				;;
			[Qq]* )
				echo "Quitting ..."
				exit 1
				;;
			* )
				echo "Wrong choice"
				;;
		esac
	done
}


test_menu

