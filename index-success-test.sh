#!/bin/bash


logfile=index-success-test.log
# tüm index leri uçur
#echo "INFO delete all related search from cache (this query takes too much time on production environment)"
#for searchid in $(./qactl -listallsearches |grep '2022-01-06 18:00:00' | cut -d';' -f3 |cut -d'=' -f2); do ./qactl -deletesearch $searchid; done

# şu an index ler düzgünken 1 adet search çalıştır ama silinmesin

echo "INFO removing super indexes"
time ssh 172.16.60.41 'cd /opt/q-indexer; ./qactl -d "2022/01/06 19:00" 60'  &>/dev/null

touch /tmp/do-not-delete-search
echo "INFO perform a search and do not delete search results"
# search i at anahtar $1
./qactl -checkdatafilecount $1 "2022-01-06 18:00:00" "2022-01-06 19:00:00" 0.2.0.1 127.0.0.1:32006 |grep FileCount
# tamam simdi $1 id's gecen search u grep le

echo $(date "+%F %T") >> $logfile
echo "-- daha sonra bu search u arastiracaz" >> $logfile
grep $1 /var/log/audit/audit.log >> $logfile
cat /tmp/result.json >> $logfile
echo "--" >> $logfile


# sonuç 0 indexten gelmeli doğru mu? 
# evet tamam şimdi index i sil
echo "INFO building super indexes"
time ssh 172.16.60.41 'cd /opt/q-indexer; ./qactl -db "2022/01/06 19:00" 60' &>/dev/null


/bin/rm -fr /tmp/do-not-delete-search


./qactl -checkdatafilecount $1 "2022-01-06 18:00:00" "2022-01-06 19:00:00" 0.2.0.1 127.0.0.1:32006 |grep FileCount

# sonuç 0 indexten gelmeli doğru mu? 
# tamam simdi $1 id's gecen search u grep le

echo INFO check index file count in /store/ariel/events/records/2022/1/6/18/super
ssh 172.16.60.41 'ls /store/ariel/events/records/2022/1/6/18/super |wc -l' 

