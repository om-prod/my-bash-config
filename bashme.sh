user=$(whoami)

# Function for disabling Laptop-Keyboard input
keyprio(){
	state=$1

	if [ "$state" == "ext" ]; then
		xinput disable "AT Translated Set 2 keyboard" && echo "Laptop-Keyboard-Priority: External"  
	elif [ "$state" == "int" ]; then
		xinput enable "AT Translated Set 2 keyboard" && echo "Laptop-Keyboard-Priority: internal"
	else 
		echo "The two states of priority are: external (ext) and internal (int)"
	fi
}

# Functions for going to different projects dest./folders
check_pyvenv(){
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

# Initialize File Paths
fp_proj="/home/$user/Documents/Projects_Folder"
fp_cpp="$fp_proj/cpp-projects"
fp_c="$fp_proj/c-projects"
fp_py="$fp_proj/python-projects/"
py_vn=".vn/bin/activate"

proj="$(check_projdest)"

# teleport to directory
tpd(){
	dest=$1
	if [ $proj -eq 1 ]; then
		# Probably much better to do a list and have checks, but idk
		if [ "$dest" == "py" ]; then
			fp_py_="$(file -b $fp_py)"
			py_vn_="$(file -b $fp_py/$py_vn)"

			if [[ "$fp_py_" == "directory" && "$py_vn_" == "ASCII text" ]]; then
				cd $fp_py
				source $py_vn
				echo "py-venv automatically deactivates when jumping to other project-folders,"
				echo "and to deactivate manually, type: deactivate"
			else
				echo "something went wrong with the py-folder-path or py-venv-folder-path. check code."
				cd
			fi
		elif [ "$dest" == "c" ]; then
			fp_c_="$(file -b $fp_c)"

			if [ "$fp_c_" == "directory" ]; then
				$(check_pyvenv)
				cd $fp_c
			else
				echo "something went wrong with the c-folder-path. check code."
				cd
			fi
		elif [ "$dest" == "cpp" ]; then
			fp_cpp_="$(file -b $fp_cpp)"

			if [ "$fp_cpp_" == "directory" ]; then
				$(check_pyvenv)
				cd $fp_cpp
			else
				echo "something went wrong with the cpp-folder-path. check code."
				cd
			fi
		elif [ "$dest" == "home" ]; then
			$(check_pyvenv)
			cd $fp_proj
		else
			echo -e "\nhow come you forgot the project-folders you set?"
			echo -e "those are (for now): 'py', 'c', 'cpp', and the 'home' folders\n"

		fi 
	else
		echo "something went wrong with the project-folder-path. check code."
	fi
}

# Alias for editing this file
fp_self="/home/$user/my_bash_config/bashme.sh"
fp_self_="$(file -b $fp_self)"

if [ "$fp_self_" == "ASCII text" ]; then
	alias bashme='/opt/sublime_text/sublime_text $fp_self'
else
	echo "something went wrong with the bashconfig-folder-path. check code."
fi

# Alias for help function
helpme(){
	declare -A cmds
	cmds[tpd]="jmp <set project-folders> ; changes/jumps to set directories."
	cmds[keyprio]="keyprio <priority> ; changes input (keyboard) priority"	
	cmds[bashme]="Edit this bash-config."
	cmds[helpme]="Prints this."

	echo -e "\npossible issue:"
	echo "the commands would still run normally even after changes in the code;"
	echo "to get feedback, create a new terminal instance."
	echo -e "\nmy-commands: \n"

	for key in "${!cmds[@]}"; do
		echo "$key: ${cmds[$key]}"
	done
		
	echo -e "\n"
}

# Randomized greeter
chara=("Satania" "Gabriel" "Yui" "Mio" "Megumin" "Miu" "$user -- THE OWNER")

size=${#chara[@]}
index=$(($RANDOM % $size))

echo -e "\x1b[1mHello ${chara[$index]}, do whatever you want..\ntype: helpme\x1b[0m\n"
