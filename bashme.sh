user=$(whoami)

# Alias for disabling Laptop-Keyboard input
alias lku='xinput disable "AT Translated Set 2 keyboard" && echo Laptop-Keyboard: Disabled'
alias lkp='xinput enable "AT Translated Set 2 keyboard" && echo Laptop-Keyboard: Enabled'

# Aliases for going to different projects dest./folders
check_pyvenv(){
 	is_vevn="$(type -t deactivate)"

	if [ "$is_vevn" == "function" ]; then
		echo deactivate
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

goto_py(){
	if [ $proj -eq 1 ]; then
		fp_py_="$(file -b $fp_py)"
		py_vn_="$(file -b $fp_py/$py_vn)"
		
		if [[ "$fp_py_" == "directory" && "$py_vn_" == "ASCII text" ]]; then
			cd $fp_py
			source $py_vn
			echo py-vevn automatically deactivates when using pj* shortcuts,
			echo and to deactivate manually, type: deactivate
		else
			echo something went wrong with the py-folder-path or py-venv-folder-path. check code.
			cd
		fi
	else
		echo something went wrong with the project-folder-path. check code.
	fi
}

goto_c(){
	if [ $proj -eq 1 ]; then	
		fp_c_="$(file -b $fp_c)" 
	
		if [ "$fp_c_" == "directory" ]; then
			$(check_pyvenv)
			cd $fp_c
		else
			echo something went wrong with the c-folder-path. check code.
			cd
		fi
	else
		echo something went wrong with the project-folder-path. check code.
	fi
}

goto_cpp(){
	if [ $proj -eq 1 ]; then
		fp_cpp_="$(file -b $fp_cpp)"
	
		if [ "$fp_cpp_" == "directory" ]; then
			$(check_pyvenv)
			cd $fp_cpp
		else
			echo something went wrong with the cpp-folder-path. check code.
			cd
		fi
	else
		echo something went wrong with the project-folder-path. check code.
	fi
}

goto_home(){
	if [ $proj -eq 1 ]; then
		cd $fp_proj
	else
		echo something went wrong with the project-folder-path. check code.
		cd
	fi
}

# Initialize File Paths
fp_proj="/home/$user/Documents/Projects_Folder"
fp_cpp="$fp_proj/cpp-projects"
fp_c="$fp_proj/c-projects"
fp_py="$fp_proj/python-projects/"
py_vn=".vn/bin/activate"

proj="$(check_projdest)"

# Aliases pointing to their respective functions
alias pjpy='goto_py'
alias pjc='goto_c'
alias pjcpp='goto_cpp'
alias pjhm='goto_home'

# Alias for editing this file
fp_self="/home/$user/my_bash_config/bashme.sh"
fp_self_="$(file -b $fp_self)"

if [ "$fp_self_" == "ASCII text" ]; then
	alias bashme='vim $fp_self'
else
	echo something went wrong with the bashconfig-folder-path. check code.
fi

# Alias for help function
helpfunc(){
	declare -A cmds
	cmds[pjpy]="Go to python-projects-folder."
	cmds[pjc]="Go to c-projects-folder."
	cmds[pjcpp]="Go to cpp-projects-folder."
	cmds[pjhm]="Go to projects-folder."
	cmds[lku]="Turns off Laptop-Keyboard."
	cmds[lkp]="Turns on Laptop-Keyboard."
	cmds[bashme]="Edit this bash-config."
	cmds[helpme]="Prints this."

	echo -e "\npossible issue:"
	echo "the aliases would still run normally even after changes in the code;"
	echo to get feedback, create a new terminal instance.
	echo -e "\nmy aliases: \n"

	for key in "${!cmds[@]}"; do
		echo "$key: ${cmds[$key]}"
	done
		
	echo -e "\n"
}
alias helpme='helpfunc'

# Randomized greeter
chara=("Satania" "Gabriel" "Yui" "Mio" "Megumin" "$user -- THE OWNER")

size=${#chara[@]}
index=$(($RANDOM % $size))

echo -e "\x1b[1mHello ${chara[$index]}, do whatever you want..\x1b[0m\ntype: helpme\n"
