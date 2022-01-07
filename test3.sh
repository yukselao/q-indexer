#!/bin/bash


if [[ "$1" == "-db" ]]; then
	time ./qactl -db "2021/12/31 11:00" 60 &>/dev/null
fi

if [[ "$1" == "-d" ]]; then
	time ./qactl -d "2021/12/31 11:00" 60
fi
echo INFO deleting all searches which are performed by apiuser
for searchid in $(./get-all-searches.sh); do
	./qactl -deletesearch  $searchid &>/dev/null
done

echo INFO checking file counts
./qactl -checkdatafilecount 551955 '2021-12-31 10:00:00' '2021-12-31 11:00:00' 0.5.0.1 10.10.2.10:32011 |grep FileCount
