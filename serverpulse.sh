#!/bin/bash

#The purpose of this tool is to gather all server stats into one place for a quick analysis of the server.
echo ""
echo ""
echo ""
echo ""

#grabs load times and puts them in seperate variables
loadtimes=$(top -b -n 1 | head -n 1 | rev | awk '{print $1,$2,$3}' | rev | tr -d ,) 
if [ "$?" = "0" ]; then
	IFS=' ' read load1 load5 load10 <<< $loadtimes
	echo "These are the load times in order of 1 minute, 5 minutes, and 10 minutes: "
	echo $load1
	echo $load5
	echo $load10
	echo ""

	#number of processors
	processors=$(nproc)
	if [ "$?" = "0" ]; then
		echo "Number of processors: $processors "
		echo ""
	else
		echo "The nproc command is not currently installed, unable to retrieve server pulse."
		return 1
	fi

	#calculating accurate traffic data for output
	division1=$(bc <<< "scale = 2; ($load1/$processors)")
	if [ "$?" = "0" ]; then
		:
	else
		echo "The bc command is not currently installed, unable to retrieve server pulse."
		return 1
	fi		
	division5=$(bc <<< "scale = 2; ($load5/$processors)")
	division10=$(bc <<< "scale = 2; ($load10/$processors)")
	echo "Here is the traffic load divided by the number of processors: "

	for i in $division1 $division5 $division10 ;
	do
		if (( $(bc <<< "$i <= 1") ));
		then
			status=$(echo "Excellent!")
		elif (( $(bc <<< "1 < $i") )) && (( $(bc <<< "$i <= 2") ));
		then
			status=$(echo "Good.")
		elif (( $(bc <<< "2 < $i") )) && (( $(bc <<< "$i <= 3") ));
		then
			status=$(echo "Ok..")
		elif (( $(bc <<< "3 < $i") )) && (( $(bc <<< "$i <= 4") ));
		then
			status=$(echo "Bad.")
		else
			status=$(echo "Unacceptable.")
		fi
		echo "$i  $status"
	done
    
	swapf=$(top -b -n 1 | grep Swap | grep -Eo "[0-9]*\ *free" | tr -d free)
	swapt=$(top -b -n 1 | grep Swap | grep -Eo "[0-9]*\ *total" | tr -d total)

	echo ""
	echo "Total Swap: $swapt"
	echo "Free Swap: $swapf"

	wait=$(top -n 1 -b | head -3 | grep wa | egrep -o "[0-9.]*\ *wa" | tr -d wa)
	echo "I/O Wait: $wait"
	echo ""
else 
	echo "The top command is not currently installed, unable to retrieve server pulse." 1>&2
	return 1
fi

