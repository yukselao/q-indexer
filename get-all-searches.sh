#!/bin/bash


#aql='select "AQL Statement", "Ariel Cursor ID" from events where (qid=28250254 AND userName='"'"commandapiuser"'"') LAST 24 HOURS'
aql='select "Ariel Cursor ID" from events where (qid=28250254 AND userName='"'"commandapiuser"'"') LAST 24 HOURS'
echo "INFO Get Ariel Cursor IDs with aql -> $aql"
/opt/qradar/bin/ariel_query -f /opt/q-indexer/token -q "$aql" 2>/dev/null |grep -v Cursor
