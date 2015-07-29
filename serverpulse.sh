
#!/bin/bash

#The purpose of this tool is to gather all server stats into one place for a quick analysis of the server.
echo ""
echo ""
echo ""
echo ""

#grabs load times and puts them in seperate variables
loadtimes=$(load 2>/dev/null) 
if [ "$?" = "0" ]; then
    IFS=' ' read load1 load5 load10 notload notload2 <<< $loadtimes
    echo "These are the load times in order of 1 minute, 5 minutes, and 10 minutes: "
    echo $load1
    echo $load5
    echo $load10
    echo ""

    #number of processors
    processors=$(cat /proc/cpuinfo | grep processor | wc -l)
    echo "Number of processors: $processors "
    echo ""

    #calculating accurate traffic data for output
    division1=$(bc <<< "scale = 2; ($load1/$processors)")
    division5=$(bc <<< "scale = 2; ($load5/$processors)")
    division10=$(bc <<< "scale = 2; ($load10/$processors)")
    echo "Here is the traffic load divided by the number of processors: "

    if (( $(bc <<< "$division1 <= 1") ));
    then
	status1=$(echo "Excellent!")
    elif (( $(bc <<< "1 < $division1") )) && (( $(bc <<< "$division1 <= 2") ));
    then
	status1=$(echo "Good.")
    elif (( $(bc <<< "2 < $division1") )) && (( $(bc <<< "$division1 <= 3") ));
    then
	status1=$(echo "Ok..")
    elif (( $(bc <<< "3 < $division1") )) && (( $(bc <<< "$division1 <= 4") ));
    then
	status1=$(echo "Bad.")
    else
	status1=$(echo "Unacceptable.")
    fi

    if (( $(bc <<< "$division5 <= 1") ));
    then
    	status2=$(echo "Excellent!")
    elif (( $(bc <<< "1 < $division5") )) && (( $(bc <<< "$division5 <= 2") ));
    then
        status2=$(echo "Good.")
    elif (( $(bc <<< "2 < $division5") )) && (( $(bc <<< "$division5 <= 3") ));
    then
    	status1=$(echo "Ok..")
    elif (( $(bc <<< "3 < $division5") )) && (( $(bc <<< "$division5 <= 4") ));
    then
    	status2=$(echo "Bad.")
    else
    	status2=$(echo "Unacceptable.")
    fi

    if (( $(bc <<< "$division10 <= 1") ));
    then
    	status3=$(echo "Excellent!")
    elif (( $(bc <<< "1 < $division10") )) && (( $(bc <<< "$division10 <= 2") ));
    then
        status3=$(echo "Good.")
    elif (( $(bc <<< "2 < $division10") )) && (( $(bc <<< "$division10 <= 3") ));
    then
    	status3=$(echo "Ok..")
    elif (( $(bc <<< "3 < $division10") )) && (( $(bc <<< "$division10 <= 4") ));
    then
    	status3=$(echo "Bad.")
    else
    	status3=$(echo "Unacceptable.")
    fi

    echo "$division1  $status1"
    echo "$division5  $status2"
    echo "$division10  $status3"
    echo ""
    echo ""

    swap=$(top -n 1 -b | grep Swap)

    IFS=' ' read total notused bla used others <<< $swap
    echo "Swap: $used"

    wait=$(top -n 1 -b | grep %wa | egrep -o "[0-9.]+%wa")
    echo "Wait: $wait"
else 
    echo "The load command is not currently installed, unable to retrieve server pulse." 1>&2
fi

