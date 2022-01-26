# q-indexer

Logs:
--

```
[root@qradar q-indexer]# time ./detect.sh 2022-01-06 2022-01-09 0.56.0.1 test 90001 "127.0.0.1:32006" 172.16.60.41 -action=fix
2022-01-10 22:44:13 INFO [1]: startts=1641416400 (2022-01-06)
2022-01-10 22:44:13 INFO [2]: endts=1641675600 (2022-01-09)
2022-01-10 22:44:13 INFO [3]: AQL selector ip: 0.56.0.1
2022-01-10 22:44:13 INFO [4]: session name: test
2022-01-10 22:44:13 INFO [5]: AQL selector key: 90001
2022-01-10 22:44:13 INFO [6]: arielproxyserver: 127.0.0.1:32006
2022-01-10 22:44:13 INFO [7]: ssh host: 172.16.60.41
2022-01-10 22:44:13 INFO [8]: -action=fix
2022-01-10 22:44:13 INFO difference: 3 days
2022-01-10 22:44:13 INFO cmd: ./qactl -checkdatafilecount 90001 '2022-01-06 00:00:00' '2022-01-06 23:59:59' 0.56.0.1 127.0.0.1:32006
2022-01-10 22:44:20 INFO search completed successfully in 7 seconds. (query_execution_time=5188ms)
2022-01-10 22:44:21 INFO delete search id ed6224d0-c679-4168-afdf-5dd5bc7dc6dd
2022-01-10 22:44:21 INFO dataFileCount is 1190...
2022-01-10 22:44:21 INFO indexFileCount is 0...
2022-01-10 22:44:21 WARNING index corruption detected on 2022-01-06
2022-01-10 22:44:21 INFO creating indexes for 2022-01-06 with cmd: time ssh 172.16.60.41 '/opt/q-indexer/qactl -db "2022/01/07 00:00" 1440'
2022-01-10 22:44:21 INFO logfile: /tmp/2022-01-06-action.log
Creating /store/ariel/events/records/2022/1/6/13/super/SourceIP~0 - done
Creating /store/ariel/events/records/2022/1/6/13/super/CREEventList~0 - done
Creating /store/ariel/events/records/2022/1/6/13/super/PartialMatchList~0 - done
Creating /store/ariel/events/records/2022/1/6/13/super/Qid~0 - done
All done in 0:00:01.945
done.

real    1m24.849s
user    0m0.122s
sys     0m0.112s
2022-01-10 22:45:46 INFO after fix, perform a search and check search stats again
2022-01-10 22:45:47 INFO search completed successfully in 1 seconds. (query_execution_time=92ms)
2022-01-10 22:45:48 INFO dataFileCount is 0...
2022-01-10 22:45:48 INFO indexFileCount is 11...
2022-01-10 22:45:48 INFO cmd: ./qactl -checkdatafilecount 90001 '2022-01-07 00:00:00' '2022-01-07 23:59:59' 0.56.0.1 127.0.0.1:32006
2022-01-10 22:45:52 INFO search completed successfully in 4 seconds. (query_execution_time=1881ms)
2022-01-10 22:45:52 INFO delete search id 45f6eaf6-aae0-4997-aea4-a3d2e1a52568
2022-01-10 22:45:52 INFO dataFileCount is 2880...
2022-01-10 22:45:52 INFO indexFileCount is 0...
2022-01-10 22:45:52 WARNING index corruption detected on 2022-01-07
2022-01-10 22:45:52 INFO creating indexes for 2022-01-07 with cmd: time ssh 172.16.60.41 '/opt/q-indexer/qactl -db "2022/01/08 00:00" 1440'
2022-01-10 22:45:52 INFO logfile: /tmp/2022-01-07-action.log
Creating /store/ariel/events/records/2022/1/7/0/super/PartialMatchList~0 - done
Creating /store/ariel/events/records/2022/1/7/0/super/SourceIP~0 - done
Creating /store/ariel/events/records/2022/1/7/0/super/CREEventList~0 - done
Creating /store/ariel/events/records/2022/1/7/0/super/Qid~0 - done
All done in 0:00:02.615
done.

real    0m50.083s
user    0m0.186s
sys     0m0.166s
2022-01-10 22:46:42 INFO after fix, perform a search and check search stats again
2022-01-10 22:46:44 INFO search completed successfully in 1 seconds. (query_execution_time=94ms)
2022-01-10 22:46:44 INFO dataFileCount is 0...
2022-01-10 22:46:44 INFO indexFileCount is 24...
2022-01-10 22:46:44 INFO cmd: ./qactl -checkdatafilecount 90001 '2022-01-08 00:00:00' '2022-01-08 23:59:59' 0.56.0.1 127.0.0.1:32006
2022-01-10 22:46:48 INFO search completed successfully in 3 seconds. (query_execution_time=1499ms)
2022-01-10 22:46:49 INFO delete search id 9e502c7a-3bfb-4177-973b-48a1683e3adf
2022-01-10 22:46:49 INFO dataFileCount is 2880...
2022-01-10 22:46:49 INFO indexFileCount is 0...
2022-01-10 22:46:49 WARNING index corruption detected on 2022-01-08
2022-01-10 22:46:49 INFO creating indexes for 2022-01-08 with cmd: time ssh 172.16.60.41 '/opt/q-indexer/qactl -db "2022/01/09 00:00" 1440'
2022-01-10 22:46:49 INFO logfile: /tmp/2022-01-08-action.log
Creating /store/ariel/events/records/2022/1/8/0/super/CREEventList~0 - done
Creating /store/ariel/events/records/2022/1/8/0/super/UserName~0 - done
Creating /store/ariel/events/records/2022/1/8/0/super/SourceIP~0 - done
Creating /store/ariel/events/records/2022/1/8/0/super/Qid~0 - done
All done in 0:00:02.772
done.

real    0m50.864s
user    0m0.171s
sys     0m0.185s
2022-01-10 22:47:40 INFO after fix, perform a search and check search stats again
2022-01-10 22:47:41 INFO search completed successfully in 1 seconds. (query_execution_time=96ms)
2022-01-10 22:47:42 INFO dataFileCount is 0...
2022-01-10 22:47:42 INFO indexFileCount is 24...
2022-01-10 22:47:42 INFO cmd: ./qactl -checkdatafilecount 90001 '2022-01-09 00:00:00' '2022-01-09 23:59:59' 0.56.0.1 127.0.0.1:32006
2022-01-10 22:47:46 INFO search completed successfully in 4 seconds. (query_execution_time=1732ms)
2022-01-10 22:47:46 INFO delete search id 0043e0b7-98e4-4d04-b89d-e470979c06b6
2022-01-10 22:47:46 INFO dataFileCount is 2880...
2022-01-10 22:47:46 INFO indexFileCount is 0...
2022-01-10 22:47:46 WARNING index corruption detected on 2022-01-09
2022-01-10 22:47:46 INFO creating indexes for 2022-01-09 with cmd: time ssh 172.16.60.41 '/opt/q-indexer/qactl -db "2022/01/10 00:00" 1440'
2022-01-10 22:47:46 INFO logfile: /tmp/2022-01-09-action.log
Creating /store/ariel/events/records/2022/1/9/0/super/SourceIP~0 - done
Creating /store/ariel/events/records/2022/1/9/0/super/UserName~0 - done
Creating /store/ariel/events/records/2022/1/9/0/super/CREEventList~0 - done
Creating /store/ariel/events/records/2022/1/9/0/super/Qid~0 - done
All done in 0:00:02.690
done.

real    0m51.325s
user    0m0.158s
sys     0m0.189s
2022-01-10 22:48:38 INFO after fix, perform a search and check search stats again
2022-01-10 22:48:39 INFO search completed successfully in 1 seconds. (query_execution_time=97ms)
2022-01-10 22:48:40 INFO dataFileCount is 0...
2022-01-10 22:48:40 INFO indexFileCount is 24...

real    4m26.709s
user    0m6.224s
sys     0m4.956s
```
