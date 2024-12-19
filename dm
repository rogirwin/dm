#!/bin/bash
trap ctrl_c INT
RED='\033[1;31m'
NC='\033[0m' # No Color

function ctrl_c() {
	echo
        echo "Press q to exit"
}

while true
do
	clear
	if [[ $SelectedCommand == "h" ]]; then
		echo "Enter the command and the number of the Container you want."
		echo "eg Type r6 to restart container number 6."
		echo
	fi

	counter=1
	declare -a ContainersArray
	format="%-3s%-30s%-s\n"
	printf "$format" "" "Name" "Hostname"
	##################################################################################
	for id in $(docker container ls -q)
	do
		printf "$format" "$counter" $(docker inspect --format='{{.Name}}' $id | sed s/[^A-Za-z\_\-]//g)\
			                    $(docker inspect --format='{{.Config.Hostname}}' $id | sed s/[^A-Za-z\_\-]//g)
		ContainersArray["$counter"]="$id"
		let counter++
	done
	printf "Command: [${RED}L${NC}] View Log File [${RED}C${NC}] Connect [${RED}R${NC}] Restart [${RED}T${NC}] Top [${RED}H${NC}] Help [${RED}Q${NC}] Exit & Host Number: "
	read select

	SelectedCommand=$(echo "$select"| sed s/[^A-Za-z]//g | sed 's/[A-Z]/\L&/g')
	SelectedContainer=$(echo "$select"| sed s/[^0-9]//g )

	if [[ $SelectedCommand == "l" ]]; then
		LogPath=$(docker inspect --format='{{.LogPath}}' ${ContainersArray[$SelectedContainer]})
		tail -f "$LogPath"

	fi
	if [[ $SelectedCommand == "c" ]]; then
		docker exec -it ${ContainersArray[$SelectedContainer]} bash
	fi

	if [[ $SelectedCommand == "r" ]]; then
		Container=$(docker inspect --format='{{.Name}}' ${ContainersArray[$SelectedContainer]})
		echo "Restarting $Container"
		docker restart ${ContainersArray[$SelectedContainer]}
	fi

	if [[ $SelectedCommand == "t" ]]; then
		docker exec -it ${ContainersArray[$SelectedContainer]} top
	fi

	if [[ $SelectedCommand == "q" ]]; then
		exit
	fi
done
MainLoop
echo "Good Bye"
