#!/bin/bash 

# Script to update all wordpress sites in the public_html


# Help flag
if [ "$1" == "-h" ];
then
	echo ""
	echo "Site's won't update unless wordpress command line is installed with the alias 'wpcli'."
	echo ""
	exit 0
fi


#  Bash variable to find all wordpress sites
configfiles=$(find2perl ~/public_html/ -type f -name wp-config.php | perl)

for y in $configfiles;
do
	# Grab the directory without the file at the end so that the script can then change directories into it
	x=$(echo $y | grep -Eo "^(.*/.*/)(\1)*")		
	cd $x
	# if-statement to see if it was able to change directories
	if [[ $? == 0 ]];
	then
		# wpcli error doesn't register as an error, for that reason I had to run grep after for the if-statement
		wpcli core update-db 2>/dev/null | grep -i "success" >/dev/null 2>&1
		# if-statement to see if the command can be run successfully
		if [[ $? == 0 ]];
		then
			# previous version of wpcli I had used had a function called 'wpcli --update-all' that made this easier.  Now I have to update plugins, themes, database, and core separately.
			wpcli core update 2>/dev/null | grep -i "success" >/dev/null 2>&1
			wpcli plugin update --all 2>/dev/null | grep -i "success" >/dev/null 2>&1
			wpcli theme update --all 2>/dev/null | grep -i "success" >/dev/null 2>&1
			echo "$x updated successfully!"
		else
			echo "Unable to update $x!" >&2
		fi
	else
		echo "Unable to move into $x!" >&2
	fi
done
