#!/bin/bash 

# Script to export all wordpress databases in the public_html


# Help flag
if [ "$1" == "-h" ];
then
	echo ""
	echo "Site's won't export db unless wordpress command line is installed with the alias 'wpcli'."
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
		wpcli db export 2>/dev/null | grep -i "success" >/dev/null 2>&1
		# if-statement to see if the command can be run successfully
		if [[ $? == 0 ]];
		then
			echo "$x exported successfully!"
		else
			echo "Unable to export $x!" >&2
		fi
	else
		echo "Unable to move into $x!" >&2
	fi
done
