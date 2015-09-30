#!/bin/bash

function sitecheck {
	for i in $(ls -l /etc/httpd/sites-enabled/ | awk '{ print $9 }' | sed s/'.conf'/''/ ); do
		echo $i
		curl -Is $i | grep HTTP
	done
}

SITECHECK=$(sitecheck)

echo "$SITECHECK"
echo "$SITECHECK" | mail -s "Daily Site Check" colinhamilton579@gmail.com
