#!/bin/bash
sleep 10

echo SETUP.sh time now: `date +"%T" `
mongo --host mongo-1:27017 <<EOF
 var cfg = {
   "_id": "mongo-replica",
   "version": 1,
   "members": [
     {
       "_id": 0,
       "host": "mongo-1:27017",
       "priority": 2
     },
     {
       "_id": 1,
       "host": "mongo-2:27017",
       "priority": 1
     },
     {
       "_id": 2,
       "host": "mongo-3:27017",
       "priority": 0
     }
   ]
 };
 rs.initiate(cfg, { force: true });
 rs.reconfig(cfg, { force: true });
 rs.secondaryOk();
 
 rs.status();
 
 db.getMongo().setReadPref('nearest');
 db.getMongo().setSecondaryOk();
EOF

