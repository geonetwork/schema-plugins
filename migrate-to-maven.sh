#!/bin/bash

PLUGINNAME=$1


function showUsage 
{
  echo -e "\nThis script is used to migrate a GeoNetwork schema plugin" 
  echo -e "\nfrom the folder structure to maven module."
  echo
  echo -e "Usage: ./`basename $0 $1`"
  echo
  echo -e "Example:"
  echo -e "\t./`basename $0 $1` iso19135"
  echo
}

if [ "$1" = "-h" ]
then
        showUsage
        exit
fi

echo "Migrating plugin $PLUGINNAME ..."
echo "  Creating maven module structure"
mkdir -p $PLUGINNAME/src/main/plugin/$PLUGINNAME
mkdir -p $PLUGINNAME/src/main/resources
echo "  Moving configuration folder to src/main/plugin/$PLUGINNAME"
mv $PLUGINNAME/* $PLUGINNAME/src/main/plugin/$PLUGINNAME/.
echo "  Creating pom.xml"
sed -es/PLUGINNAME/$PLUGINNAME/g iso19139.xyz/pom.xml > $PLUGINNAME/pom.xml
echo "  Creating Spring configuration (default schema plugin bean will be an ISO19139). If you need custom relation management or multilingual support, you need to create a custom bean for the schema."
sed -es/PLUGINNAME/$PLUGINNAME/g iso19139.xyz/src/main/resources/config-spring-geonetwork.xml > $PLUGINNAME/src/main/resources/config-spring-geonetwork.xml



