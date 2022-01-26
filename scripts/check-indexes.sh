#!/bin/bash

homedir="/opt/q-indexer"

targethost="$1"
startdate="$2"
enddate="$3"
sessionname="$4"
ssh="ssh -o StrictHostKeyChecking=false $targethost"
mkdir -p $homedir


source functions.sh

function print_usage() {
	echo 'Usage: '$0'
<target-host> (key auhentication required) <start-date> <end-date> <session-name>

'
}

function savesession() {
	sessionid="$1"
	sessionfile="${homedir}/indexer-session.lst"
	sed -r -i  "/$sessionid/d" $sessionfile 2>/dev/null
	echo $(date "+%F %T")" $sesionid;$2"
	echo $(date "+%F %T")" $sesionid;$2" >> $sessionfile

}

if [[ -z "$targethost" ]]; then
	print_usage
	exit 1
fi

plog INFO "targethost=$targethost"
plog INFO "startdate=$startdate"
plog INFO "enddate=$enddate"
plog INFO "sessionname=$sessionname"

cmd1="screen -S $sessioname -X kill"
ssh -t $targethost $cmd1

cmd2="screen -d -m -S $sessionname /opt/indexer/test.sh"
ssh $targethost $cmd2
if [[ $? -eq 0 ]]; then
	savesession $sessionname "HOST:$targethost, CMD:$cmd, SCREEN:$sessionname"
fi
