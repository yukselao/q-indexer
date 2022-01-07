#!/bin/bash

for searchid in $(./get-all-searches-v7.4.3.sh); do
	./qactl -deletesearch $searchid 
done
