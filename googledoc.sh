#!/bin/bash

VAR="$(curl -s 'https://docs.google.com/spreadsheets/d/1k_9zo-CZj4rbcar-dulukCWMzidbVnXMSD0rQEXpDJA/export?format=csv&id' | awk --field-separator=',' '{print $1}' | grep '[0-9]')"

if (("$VAR" >= 50)); then

    exit

else

    echo "content of message" | mail -s "Subject" example@email.com

fi
