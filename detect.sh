#!/bin/bash


debugmode=false

source functions.sh


function print_usage() {
        echo -e 'Usage:
'$0 '2021-12-31 10:00:00" "2021-12-31 10:59:00" 0.5.0.1 test
'$0" 2021-12-31 10:00:00" "2021-12-31 10:59:00" 0.5.0.1 test "10.10.2.10:32011 (for AIO)"'
'$0" 2021-12-31 10:00:00" "2021-12-31 10:59:00" 0.5.0.1 test "10.10.2.10:32006 (for EC or Datanode)"'
'$0" 2021-12-26" "2021-12-31" 0.56.0.1 test 90001 '"'10.10.2.10:32011'" -action=fix'

}

if [[ -z "$6" ]]; then
	print_usage
	exit 1
fi

startdt="$1"
enddt="$2"
testip="$3"
sessionname="$4"
key="$5"
arielproxyserver="$6"
sshhost="$7"
action="$8"
startts="$(date "+%s" -d "$startdt")"
endts="$(date "+%s" -d "$enddt")"


plog INFO "[1]: startts=$startts ($startdt)"
plog INFO "[2]: endts=$endts ($enddt)"
plog INFO "[3]: AQL selector ip: $testip"
plog INFO "[4]: session name: $sessionname"
plog INFO "[5]: AQL selector key: $key"
plog INFO "[6]: arielproxyserver: $arielproxyserver"
plog INFO "[7]: ssh host: $sshhost"
plog INFO "[8]: $action"


fark="$(expr $(expr $endts - $startts) / 86400)"
plog INFO "difference: $fark days"

for d in $(seq 0 $(expr $fark)); do
	secs="$(expr $d \* 86400)"
	#plog DEBUG "expr $startts + $secs"
	mydaystart="$(date "+%F" -d @$(expr $startts + $secs))"
	mydayend="$(date "+%F" -d @$(expr $startts + $secs))"
	nextday="$(date "+%Y/%m/%d" -d @$(expr $startts + $secs + 86400))"
	logfile="/tmp/$mydaystart-action.log"
	#plog INFO "Processing $mydaystart ..."
	if [[ ! -z "$arielproxyserver" ]]; then
		searchcmd="./qactl -checkdatafilecount $key '$mydaystart 00:00:00' '$mydayend 23:59:59' $testip $arielproxyserver"
	else
		searchcmd="./qactl -checkdatafilecount $key '$mydaystart 00:00:00' '$mydayend 23:59:59' $testip"
	fi
	plog INFO cmd: "$searchcmd"
	#stats="$(eval $searchcmd | grep 'FileCount|seconds' | paste - - | sed -r 's#.+dataFileCount is ([0-9]+).+indexFileCount is ([0-9]+).+#\1;\2#')"
	statfile="/tmp/q-indexer_$mydaystart-search-stats.log"
	eval $searchcmd &>$statfile
	cat $statfile
	stats="$(cat $statfile  | grep 'FileCount' | paste - - | sed -r 's#.+dataFileCount is ([0-9]+).+indexFileCount is ([0-9]+).+#\1;\2#')"
	datastat="$(echo $stats | awk -F';' '{print $1}')"
	indexstat="$(echo $stats | awk -F';' '{print $2}')"
	if [[ "$datastat" -gt 3 ]]; then
		plog "WARNING" "index corruption detected on $mydaystart"
		if [[ "$action" == "-action=fix" ]]; then
			if [[ ! -z "$arielproxyserver" ]]; then
				actioncmd="time ssh $sshhost '/opt/q-indexer/qactl -db "'"'"$nextday 00:00"'"'" 1440'" 
				plog INFO "creating indexes for $mydaystart with cmd: $actioncmd"
				plog INFO logfile: $logfile
				eval $actioncmd &> /tmp/$mydaystart-action.log
				tail /tmp/$mydaystart-action.log
				plog INFO "after fix, perform a search and check search stats again"
				eval $searchcmd | egrep "FileCount|seconds" 
			else
				actioncmd="time /opt/q-indexer/qactl -db '$nextday 00:00' 1440" 
				plog INFO "creating indexes for $mydaystart with cmd: $actioncmd"
				plog INFO logfile: $logfile
				eval $actioncmd &> /tmp/$mydaystart-action.log
				tail /tmp/$mydaystart-action.log
				plog INFO "after fix, perform a search and check search stats again"
				eval $searchcmd | egrep "FileCount|seconds" 
			fi
		fi

	fi
	if [[ "$action" == "-action=delete" ]]; then
			if [[ ! -z "$arielproxyserver" ]]; then
				actioncmd="time ssh $sshhost '/opt/q-indexer/qactl -d "'"'"$nextday 00:00"'"'" 1440'" 
				plog "INFO deleting indexes for $mydaystart in $sshhost, cmd: $actioncmd"
				plog INFO logfile: $logfile
				eval $actioncmd &> /tmp/$mydaystart-action.log
				tail /tmp/$mydaystart-action.log
			else
				plog INFO deleting indexes
				plog DEBUG "index process is starting for $mydaystart with cmd: $actioncmd"
				actioncmd="time /opt/q-indexer/qactl -d '$nextday 00:00' 1440" 
				eval $actioncmd &> /tmp/$mydaystart-action.log
				tail /tmp/$mydaystart-action.log
			fi
	fi
	wlog "$mydaystart;dataFilecount:$datastat;indexFileCount:$indexstat;$searchcmd;$actioncmd"
done
