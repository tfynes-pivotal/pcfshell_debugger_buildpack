#!/bin/bash

if [ "$#" -ne 4 ];
  then 
     echo "Usage addAppDebuggerRoute.sh <app-name> <debugger-host> <cf-space> <debugger-domain>" && exit 1
fi


######################################################################################################
# search for route with passed in listen port, return it's GUID if found or null if not.
# iterates through pages of results
function getRouteGuidWithHostname() {
  hostname=$1
#  echo "DEBUGGER HOSTNAME = $hostname"
  totalpages=$(cf curl /v2/routes?results-per-page=100 | jq -r .total_pages)
  for (( i = 1; i <= $totalpages; i++ )) do
  result=$(cf curl /v2/routes?order-direction=asc\&page=$i\&results-per-page=100 | jq -r ".resources[] | select(.entity.host==\"$hostname\")" | jq -r .metadata.guid)
  if [ ! -z $result ]
    then
      echo $result
      return
      #break
  fi
  done
}
######################################################################################################


# app name is $1
appname=$1
echo "appname = $appname"
# debugger-host is $2
debugger_host=$2
echo "debugger_host = $debugger_host"
echo
space=$3
echo "space = $space"
echo
debugger_domain=$4
echo "debugger_domain = $debugger_domain"
echo

# need app guid
appguid=$(cf app $1 --guid)
echo "app guid = $appguid"
echo

#HARDCODING DEBUGGER PORT TO 18080
export DEBUGGER_PORT=18080
# add port to app - assumes that exist port 8080 is only one in use
addAppPortArgs="{\"ports\":[8080, $DEBUGGER_PORT ]}"
addAppPortCommand="cf curl /v2/apps/$appguid -X PUT -d ""'"$addAppPortArgs"'"""
eval $addAppPortCommand
sleep 2
appports=`cf curl /v2/apps/$appguid | jq .entity.ports`
echo "App Ports = $appports"

#delete route to ensure it's not locked
cf delete-route $debugger_domain --hostname $debugger_host -f
sleep 2
#create route if it doesn't exist
cf create-route $space $debugger_domain --hostname $debugger_host
sleep 2

# need route guid
#routeguid=$(cf curl /v2/routes?results-per-page=100 | jq -r ".resources[] | select(.entity.port==$2)" | jq -r .metadata.guid)
routeguid=$(getRouteGuidWithHostname $debugger_host)
echo "route guid = $routeguid"
echo

postdata="{\"app_guid\":\"$appguid\",\"route_guid\":\"$routeguid\",\"app_port\":$DEBUGGER_PORT}"
cf curl /v2/route_mappings -X POST -d "'"$postdata"'"
sleep 2

cf restage $appname



