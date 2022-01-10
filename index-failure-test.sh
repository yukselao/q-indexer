#!/bin/bash

debugmode=false
source functions.sh
key=$1
if [[ -z "$key" ]]; then
	plog DEBUG set unique selector as 35353535
	key="35353535"
fi

startdate="2022-01-06 18:00:00" 
enddate="2022-01-06 19:00:00" 
targetarielproxy="127.0.0.1:32006"
testmhip="$(getconf testmhip)"

plog INFO params:
plog INFO AQL selector key is $key
plog INFO $startdate - $enddate
plog INFO target ariel proxy server is $targetarielproxy
plog INFO target host is $testmhip

#plog DEBUG "delete all related search from cache (this query takes too much time on production environment)"
#for searchid in $(./qactl -listallsearches |grep "$startdate" | cut -d';' -f3 |cut -d'=' -f2); do ./qactl -deletesearch $searchid; done

plog INFO "creating indexes"
ssh ${testmhip} 'cd /opt/q-indexer; ./qactl -db "'"$(dt2arielformat "$enddate")"'" 60'  &>/dev/null
plog INFO "check files in /store/ariel/events/records/2022/1/6/18/super in $testmhip (expected results: list of ariel indexes)"
plog INFO ssh ${testmhip} 'ls /store/ariel/events/records/2022/1/6/18/super' 


plog INFO "performing a search (expected results: indexFilecount>0, dataFieCount=0)"
./qactl -checkdatafilecount $key "$startdate" "$enddate" 0.2.0.1 $targetarielproxy |egrep 'FileCount|seconds'
plog DEBUG $(cat /tmp/result.json)


# Collect debug logs
plog DEBUG "-- daha sonra bu search u arastiracaz"
plog DEBUG grep $key /var/log/audit/audit.log
plog DEBUG /tmp/result.json
plog DEBUG "--"
/bin/rm -fr /tmp/do-not-delete-search

plog INFO "deleting indexes -> ssh ${testmhip} 'cd /opt/q-indexer; ./qactl -d "'"$enddate"'" 60' "
ssh ${testmhip} 'cd /opt/q-indexer; ./qactl -d "'"$(dt2arielformat "$enddate")"'" 60' &>/dev/null


plog INFO "performing a search (expected results: indexFilecount=0, dataFieCount>0)"
./qactl -checkdatafilecount $key "$startdate" "$enddate" 0.2.0.1 $targetarielproxy |egrep 'FileCount|seconds'

# sonuç 0 indexten gelmeli doğru mu? 
# tamam simdi $1 id's gecen search u grep le
plog INFO "check files in /store/ariel/events/records/2022/1/6/18/super in $testmhip (expected results: super directory not found)"
plog INFO ssh ${testmhip} 'ls /store/ariel/events/records/2022/1/6/18/super' 
ssh ${testmhip} 'ls /store/ariel/events/records/2022/1/6/18/super' 

