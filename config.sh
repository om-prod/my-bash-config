#!/bin/bash

# modules:
# - adb 
# - jq (for reading and writing JSON-files)
# - ~
__wtfa__="$HOME/my_bash_config/"
__json_file__="$HOME/my_bash_config/variables.json"

# aliases
alias buttery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias bye='exit'
alias wtfa='cd $__wtfa__'
# git related aliases
alias gpo='git push origin'

# to edit this file
__fp_self__="$HOME/my_bash_config/config.sh"
__is_fp__="$(file -b $__fp_self__)"

if [ "$__is_fp__" == "Bourne-Again shell script, Unicode text, UTF-8 text executable" ]; then
	alias editme='/opt/sublime_text/sublime_text $__fp_self__'
else
	echo "> something went wrong with the bashconfig-folder-path. check code."
fi

# refresh function to refresh config-script
refresh()
{
	cd_=$(pwd)
	clear
	source $__fp_self__
	cd $cd_
}

tim(){
	file=$1

	if [ "$file" != "" ]; then
		gnome-terminal --tab -- nvim $file
	else 
		echo "> provide a file to edit."
	fi
}

# function for saving current-working-directory
swd()
{
	clear=$1
	directory=$(pwd)
	
	if [ "$clear" == "clear" ]; then
		ujson=$(jq '.previousWorkingDirectory = null' $__json_file__)
		echo $ujson > $__json_file__ && echo "> wd-cache cleared."
	else
		gjson=$(jq -r '.previousWorkingDirectory' $__json_file__)
		ujson=$(jq --arg dir "$directory" '.previousWorkingDirectory = $dir' $__json_file__)

		if [ "$(pwd)" != "$gjson" ]; then
			echo $ujson > $__json_file__ && echo "> saved this directory; run a new terminal to check."
		fi
	fi
}

# function for disabling Laptop-Keyboard input
keyprio()
{
	state=$1

	if [ "$state" == "ext" ]; then
		ujson=$(jq '.keyPriority = "ext"' $__json_file__)
		echo $ujson > $__json_file__
		xinput disable "AT Translated Set 2 keyboard" && echo "> Laptop-Keyboard-Priority: External (Resets to internal on-boot)"  

	elif [ "$state" == "int" ]; then
		jujson=$(jq '.keyPriority = "int"' $__json_file__)
		echo $ujson > $__json_file__
		xinput enable "AT Translated Set 2 keyboard" && echo "> Laptop-Keyboard-Priority: Internal"
	else 
		echo "> (priority: $(jq '.keyPriority' $__json_file__)) The two states of priority are: external (ext) and internal (int)"
	fi
}

# functions for going to different projects dest./folders
check_pyvenv()
{
 	is_vevn="$(type -t deactivate)"

	if [ "$is_vevn" == "function" ]; then
		echo "deactivate"
		# returns keyword "deactivate" and $(..) runs it
	fi
}

check_projdest()
{
	fp_proj_="$(file -b $fp_proj)"

	if [ "$fp_proj_" == "directory" ]; then
		echo 1
	else
		echo 0
	fi
}

# teleport to directory
tpd()
{
	# Initialize File Paths
	fp_proj="$HOME/Documents/Projects_Folder"
	fp_cpp="$fp_proj/cpp-projects"
	fp_c="$fp_proj/c-projects"
	fp_py="$fp_proj/python-projects"
	py_vn=".vn/bin/activate"
	
	proj="$(check_projdest)"	
	
	dest=$1 # <- argv[i]
	$(check_pyvenv)

	# Jump to saved-working-directory
	gjson=$(jq -r '.previousWorkingDirectory' $__json_file__)
	if [[ "$dest" == "saved" ]]; then
		cd $gjson	
	elif [ $proj -eq 1 ]; then
		# Probably much better to do a list and have checks, but idk

		if [[ "$dest" == "py" || "$dest" == "python" ]]; then
			fp_py_="$(file -b $fp_py)"
			py_vn_="$(file -b $fp_py/$py_vn)"

			if [[ $fp_py_ == "directory" && $py_vn_ == "ASCII text" ]]; then
				cd $fp_py
				source $py_vn
				echo "> py-venv automatically deactivates when jumping to other project-folders,"
				echo "> and to deactivate manually, type: deactivate"
			else
				echo "> something went wrong with the py-folder-path or py-venv-folder-path. check code."
				cd
			fi
		elif [ "$dest" == "c" ]; then
			fp_c_="$(file -b $fp_c)"

			if [ $fp_c_ == "directory" ]; then
				cd $fp_c
			else
				echo "> something went wrong with the c-folder-path. check code."
				cd
			fi
		elif [ "$dest" == "cpp" ]; then
			fp_cpp_="$(file -b $fp_cpp)"

			if [ $fp_cpp_ == "directory" ]; then
				cd $fp_cpp
			else
				echo "> something went wrong with the cpp-folder-path. check code."
				cd
			fi
		elif [ "$dest" == "home" ]; then
			cd $fp_proj
		else
			echo -e "how come you forgot the project-folders you set?"
			echo -e "those are (for now): 'py', 'c', 'cpp', and the 'home' folders"

		fi 
	else
		echo "> something went wrong with the project-folder-path. check code."
	fi
}

# creating a way to open files in sublime through the terminal
#sublime()
#{
#	path="/opt/sublime_text/sublime_text"
#	file=$1
#	/opt/sublime_text/sublime_text $file
#}

# adb connect and shell in one function;
# basic adb ...  not much to see here. 
# needs adb to work 
shelldroid(){
	custom_ip=$1
	custom_port=$2

	if [[ "$custom_ip" != "" && "$custom_port" != "" ]]; then
		activity="$(adb devices | grep $custom_ip)"
		
		if [ "$activity" != "" ]; then
			clear
			echo -e "[open-connection on $custom_ip:$custom_port ; still active]\n[deactivate by 'shelldroid off']\n"
			echo -e "================================================\n"
			adb shell
		# the IP-regex came from good ol' StackOverflow 
		elif [[ $custom_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ && $custom_port -ge 0 && $custom_port -le 65535 ]]; then
			clear; adb connect $custom_ip:$custom_port && adb shell
		else 
			echo "> ip -- port error"
		fi
	elif [[ "$custom_ip" == "off" ]]; then
		echo "[bashme-adb] $(adb disconnect)"; 
	else
		echo "> forgot to include ip or port?: shelldroid <ip> <port>"
	fi
}

# for ettercap default command-paste
mim()
{
	nt_interface=$1
	network=$2; target=$3

	if [[ $nt_interface != "" && $network != "" && $target != "" ]]; then
		if [[ $network =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ && $target =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
			sudo ettercap -T -S -i $nt_interface -M arp:remote /$network// /$target//
		else
			echo "> error whilst parsing ip-address."
		fi			
	else
		echo "> required fields: <network interface (wlan0, etc.)> <network ip> <target ip>"
	fi
}

# help function
tasukete(){
	declare -A cmds

	cmds[tim]="tim <file> ; opens a new terminal-tab and edits provided file with vim"
	cmds[mim]="mim <network interface> <network ip> <target ip> ; does ettercap stuff"
	cmds[refresh]="Refreshes the config.sh to apply new changes."
	cmds[swd]="swd or swd clear ; saves current working directory, so that if new session opens it will cd to there."
	cmds[shelldroid]="shelldroid <ip-addr> <port-addr> ; connects and shells to device."
	cmds[tpd]="jmp <set project-folders> ; changes/jumps to set directories."
	cmds[keyprio]="keyprio <priority> ; changes input (keyboard) priority"	
	cmds[editme]="Edit this bash-config."
	cmds[tasukete]="Prints this."

	echo -e "tip\s:"
	echo "made changes to code? type refresh to apply"
	echo -e "\nmy-commands: \n"

	for key in "${!cmds[@]}"; do
		if [ "$key" == "tasukete" ]; then
			echo -e "\x1b[4;1m$key || helpme\x1b[0m: ${cmds[$key]}"
		else
			echo -e "\x1b[4;1m$key\x1b[0m: ${cmds[$key]}"
		fi
	done
		
	echo -e ""
}

alias helpme='tasukete'

# randomized greeter
__user__=$(whoami) # sigma
__chara__=("Satania" "Gabriel" "Yui" "Mio" "Megumin" "Miu" "$__user__")

__size__=${#__chara__[@]}
__index__=$(($RANDOM % $__size__))

echo -e "\x1b[1mこんにちは${__chara__[$__index__]}さん, 何でもやってもいいよ..\nconfig-cmds: helpme or tasukete\x1b[0m\n"

__gjson__=$(jq -r '.previousWorkingDirectory' $__json_file__)
__currwd__=$(pwd)
	
if [[ ("$__gjson__" != "null" && "$__gjson__" != "") && ("$__currwd__" == "$HOME" && "$__currwd" != "$__gjson__") ]]; then
	echo "> Continuing from where you left off.."
	echo -e "To clear wd-cache type: swd clear\n"
	cd $__gjson__
fi