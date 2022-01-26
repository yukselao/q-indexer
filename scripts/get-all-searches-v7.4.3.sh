#!/bin/bash
#aql='select "AQL Statement", "Ariel Cursor ID" from events where (qid=28250254 AND userName='"'"commandapiuser"'"') LAST 24 HOURS'
aql='select "payload" from events where (qid=28250254 AND userName='"'"apiuser"'"') LAST 24 HOURS'
for line in $(/opt/qradar/bin/ariel_query -f /opt/q-indexer/token -q "$aql" 2>/dev/null |grep -v Cursor | grep -v payload); do
	echo $line | base64 -d | sed -r 's#.+Params:Id:(.+), DB:.+#\1#'
done
