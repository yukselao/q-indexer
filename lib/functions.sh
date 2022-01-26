#!/bin/bash



function plog() {
	if [[ "$1" == "DEBUG" ]]; then
		if [[ "$debugmode" != "false" ]]; then
        		echo $(date "+%F %T") $@
		fi
	else
        		echo $(date "+%F %T") $@
	fi
}


function getfilename() {
	start="$(echo "$1" |tr -d '-' |tr -d ':' |tr ' ' '-')"
	end="$(echo "$2" |tr -d '-' |tr -d ':' |tr ' ' '-')"
	filename=$start~$end
	echo $filename
}
function wlog() {
	filename=$(getfilename "$start" "$end")
	mkdir -p $wlogfolder &>/dev/null
        echo $(date "+%F %T") $@ >> ${wlogfolder}/$filename~${sessionname}.log
}
function errorlog() {
	filename=$(getfilename "$start" "$end")
	mkdir -p $wlogfolder &>/dev/null
        echo $(date "+%F %T") $@ >> ${wlogfolder}/$filename~${sessionname}-error.log
}
function debuglog() {
	filename=$(getfilename "$start" "$end")
	mkdir -p $wlogfolder &>/dev/null
        echo $(date "+%F %T") $@ >> ${wlogfolder}/$filename~${sessionname}-debug.log
}

function getconf() {
	cat config.ini |grep "$1=" |sed -r "s#^"$1'=(.+?)$#\1#'
}

function getsearch() {
        searchid="$1"
        if [[ -z "$2" ]] ;then
                echo INFO get search infor for searchid=$searchid
                echo curl -k -S -X GET -H "SEC: $apitoken" -H 'Version: '"${apiversion}"'' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches/$searchid"
                curl -k -S -X GET -H "SEC: $apitoken" -H 'Version: '"${apiversion}"'' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches/$searchid" 2>/dev/null
        else
                curl -k -S -X GET -H "SEC: $apitoken" -H 'Version: '"${apiversion}"'' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches/$searchid" 2>/dev/null |jq '.'$2
        fi
}
function getstatus() {
        searchid="$1"
        curl -k -S -X GET -H "SEC: $apitoken" -H 'Version: '"${apiversion}"'' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches/$searchid" 2>/dev/null |jq '.status' |tr -d '"'
}

function deletesearch() {
        searchid=$1
        plog INFO delete search id $searchid
        plog DEBUG curl -k -S -X DELETE -H "SEC: $apitoken" -H 'Version: '"${apiversion}"'' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches/$searchid" result: $(curl -k -S -X DELETE -H "SEC: $apitoken" -H 'Version: '"${apiversion}"'' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches/$searchid" 2>/dev/null | jq '.status')
}


dt2arielformat() {
	d="$1" #  2022-01-06 19:00:00
	python -c "d='$d';print(d.replace('-','/')[0:-3])"
		
}
