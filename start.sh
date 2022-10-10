#!/usr/bin/env bash
set -e

#TODO versioning or replace
#TODO Delete some versions back


input="$1"
latest=$(curl -sw '\n' "https://josm.openstreetmap.de/latest")
tested=$(curl -sw '\n' "https://josm.openstreetmap.de/tested")
offline_latest=$(find . -maxdepth 1 -name 'josm-latest-*' -print | sort -rV | head -n1 | sed 's/[^0-9]*//g')
offline_tested=$(find . -maxdepth 1 -name 'josm-tested-*' -print | sort -rV | head -n1 | sed 's/[^0-9]*//g')
Y=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2 | head -n 1)
S=1

function check_resolution () {
if [ "$Y" -ge "1440" ]; then
  S=1.5
fi
}

function check_tested_get_tested () {
if [ -f josm-tested-"${offline_tested}".jar ]; then
  if ! [ "$tested" == "$offline_tested" ]; then
    curl -s "https://josm.openstreetmap.de/josm-tested.jar?lang=en" -o josm-tested-"${tested}".jar
    chmod +x josm-tested-"${tested}".jar
  fi
else
    curl -s "https://josm.openstreetmap.de/josm-tested.jar?lang=en" -o josm-tested-"${tested}".jar
    chmod +x josm-tested-"${tested}".jar
fi
}

function check_latest_get_latest () {
if [ -f josm-latest-"${offline_latest}".jar ]; then
  if ! [ "$latest" == "$offline_latest" ]; then
    curl -s "https://josm.openstreetmap.de/josm-latest.jar?lang=en" -o josm-latest-"${latest}".jar
    chmod +x josm-latest-"${latest}".jar
  fi
else
    curl -s "https://josm.openstreetmap.de/josm-latest.jar?lang=en" -o josm-latest-"${latest}".jar
    chmod +x josm-latest-"${latest}".jar
fi
}

check_resolution

if [ "nc -dzw1 google.com 443" ]
then
  if [ "$input" == "latest" ]
    then
    check_latest_get_latest
    GDK_SCALE=$S java -jar -Xmx12G josm-latest-"${latest}".jar
  else
    check_tested_get_tested
    GDK_SCALE=$S java -jar -Xmx12G josm-tested-"${tested}".jar
  fi

else
  if [ "$input" == "latest" ]
    then
     GDK_SCALE=$S java -jar -Xmx12G josm-latest-"${offline_latest}".jar
    else
     GDK_SCALE=$S java -jar -Xmx12G josm-tested-"${offline_tested}".jar
  fi
fi

