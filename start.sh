#!/bin/bash

# latest version number of josm as a variable
latest=$(curl -sw '\n' "https://josm.openstreetmap.de/latest")

# download the latest josm
function get_latest () {
curl -s "https://josm.openstreetmap.de/josm-latest.jar?lang=en" -o josm-latest.jar
mv josm-latest.jar josm-latest-${latest}.jar
chmod +x josm-latest-${latest}.jar
}

# if josm is found here, get version number from it, else download latest josm
if [ -e josm* ]
then
installed=$(ls josm-latest-*.jar | cut -c 13-17)
else
get_latest
fi

# latest is newer
if [ $installed != $latest ]
then
rm josm-latest-${installed}.jar
get_latest
fi

# run josm
java -jar -Xmx6G josm-latest-${latest}.jar