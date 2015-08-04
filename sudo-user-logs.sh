#!/bin/bash -e

# This is my script to record all specified sudo users sudo commands into a neat log system.

# This is my Array where all sudo users are placed
USERS=(colin erick)

# These are the dates that I search by and save by
d=$(date +%b%-d)
D=$(date +%b"  "%-d)

# For loop to run through the array and record all the sudo users and their commands for that day into a txt document
for name in ${USERS[*]}; do
	cat /var/log/secure | grep "$D" | grep sudo | grep "$name" > /var/log/sudo-users/$name/"$d"-sudo-"$name".txt
done
