#!/usr/bin/env bash

Help(){
	echo "Tool for connecting and disconnecting bluetooth devices"
	echo "Syntax: "
	echo "	bluetoothControl.sh [-h|c|d|p]"
	echo
	echo "options:"
	echo "	h	Print this Help."
	echo "	c	Connect device"
	echo "	d	Disconnect device"
	echo "	p	Pair device (currently not functional)"
	echo



	return 0;
}

selector="$HOME/.config/rofi/select.rasi"

SELECT_CMD="rofi -dmenu -i -theme ${selector}"

listDevices(){
	echo $(bluetoothctl devices $1 | cut -f2 -d' ')
}

getDeviceName(){
	echo $(bluetoothctl info $1 | grep "Alias" | cut -f2 -d':' | sed -e 's/^[ \t]*//')
}

getDeviceIcon(){
	echo $(bluetoothctl info $1 | grep "Icon" | cut -f2 -d':' | sed -e 's/^[ \t]*//' | sed "s/audio-/   /g" | sed "s/input-/   /g")
}

isPaired(){
	local paired=$(bluetoothctl info $1 | grep "Paired" | cut -f2 -d':' | sed -e 's/^[ \t]*//')
	if [ $paired = "yes" ]; then
		return 0;
	else
		return 1;
	fi
}

isConnected(){
	local connected=$(bluetoothctl info $1 | grep "Connected" | cut -f2 -d':' | sed -e 's/^[ \t]*//')
	if [ $connected = "yes" ]; then
		return 0;
	else
		return 1;
	fi
}

getUUIDfromChoice(){
	echo $(echo $1 | cut -f2 -d'@' | sed -e 's/^[ \t]*//')
}

formatDeviceEntry(){
	echo "$(echo $1 | sed "s/audio/ /g" | sed "s/input/ /g") $2"
}

connect(){
	choice=$(
		echo $(listDevices Paired) | sed "s/ /\n/g" | while read uuid; do
			(! $(isConnected "$uuid")) && \
			echo $(formatDeviceEntry "$(getDeviceIcon $uuid)" "$(getDeviceName $uuid)") @ $uuid
		done | $SELECT_CMD -p "󰂯 Connect Device")

	[[ -z "$choice" ]] && exit 1
	uuid=$(getUUIDfromChoice "$choice")
	bluetoothctl connect $uuid
}

disconnect(){
	choice=$(
		echo $(listDevices Connected) | sed "s/ /\n/g" | while read uuid; do
			echo $(formatDeviceEntry "$(getDeviceIcon $uuid)" "$(getDeviceName $uuid)") @ $uuid
		done | $SELECT_CMD -p "󰂯 Disconnect Device")

	[[ -z "$choice" ]] && exit 1
	uuid=$(getUUIDfromChoice "$choice")
	bluetoothctl disconnect $uuid
}

pair(){
	#echo $(hci-tool scan | )
	#[[ -z "$choice" ]] && exit 1
	#uuid=$(getUUIDfromChoice "$choice")
	bluetoothctl connect $uuid
}

while getopts ":hcdp" option; do
	case $option in
		h) 
			Help
			exit;;
		c)
			connect
			exit;;
		d)
			disconnect
			exit;;
		p)
			pair
			exit;;
		\?)
			echo "Error: invalid option"
	esac
done