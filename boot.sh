#!/bin/bash
# this is ran by the on-start service
# c0f4:05c0 is my current USBs mac addr
json_file="$HOME/my_bash_config/variables.json"
boot_finish=false

if [[ "$(jq -r '.keyPriority' $json_file)" == "ext" && "$(lsusb | grep 'c0f4:05c0')" == "" ]]; then
	xinput enable "AT Translated Set 2 keyboard"
	echo $(jq -r '.keyPriority = "int"' $json_file) > $json_file
elif [[ "$(jq -r '.keyPriority' $json_file)" == "ext" && "$(lsusb | grep 'c0f4:05c0')" != "" ]]; then
	gnome-terminal --window --wait --geometry=60x10 -- $HOME/my_bash_config/keyPrioConfirmPopUp.sh
	boot_finish=true
fi

if [[ $boot_finish == true ]]; then
	/opt/sublime_text/sublime_text
	gnome-terminal --geometry=168x50
	sleep 3
	wmctrl -r sublime -t 1
	wmctrl -r sysadmin -t 2
fi