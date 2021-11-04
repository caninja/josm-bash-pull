#!/bin/bash 

#TODO versioning or replace

input="$1"
latest=$(curl -sw '\n' "https://josm.openstreetmap.de/latest")
tested=$(curl -sw '\n' "https://josm.openstreetmap.de/tested")
offline_latest=$(\ls . | grep josm-latest-*.jar | sed 's/[^0-9]*//g')
offline_tested=$(\ls . | grep josm-tested-*.jar | sed 's/[^0-9]*//g')

function check_tested_get_tested () {
if [ -f josm-tested-*.jar ]; then
  if [ "$tested" !== "$offline_tested" ]; then
    curl -s "https://josm.openstreetmap.de/josm-tested.jar?lang=en" -o josm-tested-${tested}.jar
    chmod +x josm-tested-${tested}.jar
  fi
else
    curl -s "https://josm.openstreetmap.de/josm-tested.jar?lang=en" -o josm-tested-${tested}.jar
    chmod +x josm-tested-${tested}.jar
fi
}

function check_latest_get_latest () {
if [ -f josm-latest-*.jar ]; then
  if [ "$latest" !== "$offline_latest" ]; then
    curl -s "https://josm.openstreetmap.de/josm-latest.jar?lang=en" -o josm-latest-${latest}.jar
    #mv josm-tested.jar josm-latest-${latest}.jar
    chmod +x josm-latest-${latest}.jar
  fi
else
    curl -s "https://josm.openstreetmap.de/josm-latest.jar?lang=en" -o josm-latest-${latest}.jar
    chmod +x josm-latest-${latest}.jar
fi
}

if [ "nc -dzw1 google.com 443" ]
then#gotnet
  if [ "$input" == "latest" ]
    then
    check_latest_get_latest
    java -jar -Xmx6G josm-latest-${latest}.jar
  else
    check_tested_get_tested
    java -jar -Xmx6G josm-tested-${tested}.jar
  fi

else#notgotnet
  if [ "$input" == "latest" ]
    then
    java -jar -Xmx6G josm-latest-*.jar
    else
    java -jar -Xmx6G josm-tested-*.jar
  fi
fi

