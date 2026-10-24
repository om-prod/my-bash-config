#!/bin/bash

read -p "Do you want to keep internal keyboard disabled? [Y/n]: " choice

case $choice in
	[yY]* ) exit ;;
	[nN]* ) echo $(jq -r '.keyPriority = "int"' "$HOME/my_bash_config/variables.json") > "$HOME/my_bash_config/variables.json" && xinput disable "AT Translated Set 2 keyboard" ;;
	*) exit ;;
esac