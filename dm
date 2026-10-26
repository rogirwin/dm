#!/bin/bash
trap ctrl_c INT
RED='\033[1;31m'
NC='\033[0m' # No Color

ShowAll=0

function ctrl_c() {
	echo
	echo "Press q to exit"
}

function pause() {
	echo
	read -p "Press Enter to continue..."
}

function confirm() {
	read -p "$1 [y/N] " answer
	[[ $answer == "y" || $answer == "Y" ]]
}

function show_help() {
	echo "Enter the command and the number of the Container you want."
	echo "eg Type r6 to restart container number 6."
	echo
	printf "  ${RED}L${NC}  View log (follow)         ${RED}C${NC}  Connect (bash, falls back to sh)\n"
	printf "  ${RED}R${NC}  Restart                   ${RED}T${NC}  Top (processes in container)\n"
	printf "  ${RED}S${NC}  Start                     ${RED}X${NC}  Stop\n"
	printf "  ${RED}K${NC}  Kill                      ${RED}P${NC}  Pause / Unpause\n"
	printf "  ${RED}D${NC}  Delete (remove)           ${RED}I${NC}  Inspect\n"
	printf "  ${RED}O${NC}  Ports                     ${RED}M${NC}  Stats (CPU / Memory)\n"
	printf "  ${RED}E${NC}  Execute a command\n"
	echo
	echo "Commands without a container number:"
	printf "  ${RED}A${NC}  Toggle showing stopped containers\n"
	printf "  ${RED}M${NC}  Stats for all running containers\n"
	printf "  ${RED}G${NC}  List images\n"
	printf "  ${RED}H${NC}  Help                      ${RED}Q${NC}  Exit\n"
	echo
}

while true
do
	clear
	if [[ $SelectedCommand == "h" ]]; then
		show_help
	fi

	counter=1
	unset ContainersArray
	declare -a ContainersArray
	format="%-4s%-30s%-20s%-s\n"
	if [[ $ShowAll == 1 ]]; then
		ListOptions="-a"
	else
		ListOptions=""
	fi
	printf "$format" "" "Name" "Hostname" "Status"
	##################################################################################
	for id in $(docker container ls -q $ListOptions)
	do
		Name=$(docker inspect --format='{{.Name}}' $id | sed 's/^\///')
		Hostname=$(docker inspect --format='{{.Config.Hostname}}' $id)
		Status=$(docker inspect --format='{{.State.Status}}' $id)
		printf "$format" "$counter" "$Name" "$Hostname" "$Status"
		ContainersArray["$counter"]="$id"
		let counter++
	done
	printf "Command: [${RED}L${NC}]og [${RED}C${NC}]onnect [${RED}R${NC}]estart [${RED}T${NC}]op [${RED}S${NC}]tart [${RED}X${NC}] Stop [${RED}K${NC}]ill [${RED}P${NC}]ause [${RED}D${NC}]elete\n"
	printf "         [${RED}I${NC}]nspect P[${RED}O${NC}]rts [${RED}M${NC}] Stats [${RED}E${NC}]xec [${RED}A${NC}]ll [${RED}G${NC}] Images [${RED}H${NC}]elp [${RED}Q${NC}] Exit & Host Number: "
	read select

	SelectedCommand=$(echo "$select"| sed s/[^A-Za-z]//g | sed 's/[A-Z]/\L&/g')
	SelectedContainer=$(echo "$select"| sed s/[^0-9]//g )
	Container=${ContainersArray[$SelectedContainer]}

	# Commands that do not need a container
	case $SelectedCommand in
		q)
			echo "Good Bye"
			exit
			;;
		h|"")
			continue
			;;
		a)
			ShowAll=$((1 - ShowAll))
			continue
			;;
		g)
			docker image ls
			pause
			continue
			;;
		m)
			if [[ -z $Container ]]; then
				docker stats --no-stream
				pause
				continue
			fi
			;;
	esac

	if [[ -z $Container ]]; then
		echo "Please enter a valid container number, eg ${SelectedCommand}1"
		pause
		continue
	fi
	ContainerName=$(docker inspect --format='{{.Name}}' $Container | sed 's/^\///')

	case $SelectedCommand in
		l)
			docker logs -f --tail 100 $Container
			;;
		c)
			docker exec -it $Container bash || docker exec -it $Container sh
			;;
		r)
			echo "Restarting $ContainerName"
			docker restart $Container
			;;
		t)
			docker exec -it $Container top
			;;
		s)
			echo "Starting $ContainerName"
			docker start $Container
			;;
		x)
			echo "Stopping $ContainerName"
			docker stop $Container
			;;
		k)
			if confirm "Kill $ContainerName?"; then
				docker kill $Container
			fi
			;;
		p)
			if [[ $(docker inspect --format='{{.State.Paused}}' $Container) == "true" ]]; then
				echo "Unpausing $ContainerName"
				docker unpause $Container
			else
				echo "Pausing $ContainerName"
				docker pause $Container
			fi
			;;
		d)
			if confirm "Remove $ContainerName? This cannot be undone."; then
				docker rm -f $Container
			fi
			pause
			;;
		i)
			docker inspect $Container | less
			;;
		o)
			echo "Ports for $ContainerName:"
			docker port $Container
			pause
			;;
		m)
			docker stats $Container
			;;
		e)
			read -p "Command to run in $ContainerName: " ExecCommand
			if [[ -n $ExecCommand ]]; then
				docker exec -it $Container sh -c "$ExecCommand"
			fi
			pause
			;;
		*)
			echo "Unknown command: $SelectedCommand (type h for help)"
			pause
			;;
	esac
done
