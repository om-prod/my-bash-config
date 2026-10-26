#!/bin/bash

read -p "Do you want to keep internal keyboard disabled? [Y/n]: " choice

case $choice in
	[yY]* ) xinput disable "AT Translated Set 2 keyboard" && exit ;;
	[nN]* ) echo $(jq -r '.keyPriority = "int"' "$HOME/my-bash-config/variables.json") > "$HOME/my-bash-config/variables.json" && xinput enable "AT Translated Set 2 keyboard" ;;
	*) xinput disable "AT Translated Set 2 keyboard" && exit ;;
esac