#!/bin/bash

startdt="$1"
enddt="$2"
testip="$3"
sessionname="$4"
key="$5"
startts="$(date "+%s" -d "$startdt")"
endts="$(date "+%s" -d "$enddt")"

source functions.sh

plog INFO "startts=$startts ($startdt)"
plog INFO "endts=$endts ($enddt)"

function print_usage() {
	echo 'Usage:'$0 \ 
'"2021-12-31 10:00:00" "2021-12-31 10:59:00" 0.5.0.1'
}

fark="$(expr $(expr $endts - $startts) / 86400)"
plog INFO "fark=$fark days"

for d in $(seq 0 $fark); do
	secs="$(expr $d \* 86400)"
	#plog DEBUG "expr $startts + $secs"
	mydaystart="$(date "+%F" -d @$(expr $startts + $secs + 86400))"
	mydayend="$(date "+%F" -d @$(expr $startts + $secs + 86400))"
	#plog INFO "Processing $mydaystart ..."
	cmd="./qactl -checkdatafilecount $key '$mydaystart 00:00:00' '$mydayend 23:59:59' $testip"
	#plog INFO "$cmd"
	stats="$(eval $cmd | grep FileCount | paste - - | sed -r 's#.+dataFileCount is ([0-9]+).+indexFileCount is ([0-9]+).+#\1;\2#')"
	datastat="$(echo $stats | awk -F';' '{print $1}')"
	indexstat="$(echo $stats | awk -F';' '{print $2}')"
	wlog "$(date "+%F %T");$mydaystart;dataFilecount:$datastat;indexFileCount:$indexstat;$cmd"
	if [[ "$datastat" -gt 3 ]]; then
		plog "WARNING" "index corruption detected on $mydaystart"
	fi
done
