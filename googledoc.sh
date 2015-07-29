#!/bin/bash

VAR="$(curl -s 'https://docs.google.com/spreadsheets/d/1k_9zo-CZj4rbcar-dulukCWMzidbVnXMSD0rQEXpDJA/export?format=csv&id' | awk --field-separator=',' '{print $1}' | grep '[0-9]')"

if (("$VAR" >= 50)); then

    exit

else

    echo "Did it work?" | mail -s "Checking" colinhamilton579@gmail.com

fi
