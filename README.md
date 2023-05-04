## 部署架构
一主两从

## 新增用户及权限
db.createUser({user:"admin",pwd:"admin",roles:[{"role":"userAdminAnyDatabase","db":"admin"},{"role":"readWrite","db":"testdb"}]})


## 主节点
```
root@fbd4a30d1dbe:/# mongo --host mongo-1:27017
MongoDB shell version v5.0.5
connecting to: mongodb://mongo-1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("4020e958-4681-4374-abdf-a19dacc7b463") }
MongoDB server version: 5.0.5
================
Warning: the "mongo" shell has been superseded by "mongosh",
which delivers improved usability and compatibility.The "mongo" shell has been deprecated and will be removed in
an upcoming release.
For installation instructions, see
https://docs.mongodb.com/mongodb-shell/install/
================
---
The server generated these startup warnings when booting: 
        2023-04-28T09:09:13.958+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
        2023-04-28T09:09:14.577+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
---
---
        Enable MongoDB's free cloud-based monitoring service, which will then receive and display
        metrics about your deployment (disk utilization, CPU, operation statistics, etc).

        The monitoring data will be available on a MongoDB website with a unique URL accessible to you
        and anyone you share the URL with. MongoDB may use this information to make product
        improvements and to suggest MongoDB products and deployment options to you.

        To enable free monitoring, run the following command: db.enableFreeMonitoring()
        To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
---
mongo-replica:PRIMARY> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
mongo-replica:PRIMARY> use testdb
switched to db testdb
mongo-replica:PRIMARY> db.testdb.insert({age:1})
WriteResult({ "nInserted" : 1 })
mongo-replica:PRIMARY> 
```


## 从节点
```
root@3325ad7f6358:/# mongo --host mongo-3:27017
MongoDB shell version v5.0.5
connecting to: mongodb://mongo-3:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("8408241d-e91c-406e-8434-d2f05ef72402") }
MongoDB server version: 5.0.5
================
Warning: the "mongo" shell has been superseded by "mongosh",
which delivers improved usability and compatibility.The "mongo" shell has been deprecated and will be removed in
an upcoming release.
For installation instructions, see
https://docs.mongodb.com/mongodb-shell/install/
================
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
        https://docs.mongodb.com/
Questions? Try the MongoDB Developer Community Forums
        https://community.mongodb.com
---
The server generated these startup warnings when booting: 
        2023-04-28T09:09:13.958+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
        2023-04-28T09:09:14.578+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
---
---
        Enable MongoDB's free cloud-based monitoring service, which will then receive and display
        metrics about your deployment (disk utilization, CPU, operation statistics, etc).

        The monitoring data will be available on a MongoDB website with a unique URL accessible to you
        and anyone you share the URL with. MongoDB may use this information to make product
        improvements and to suggest MongoDB products and deployment options to you.

        To enable free monitoring, run the following command: db.enableFreeMonitoring()
        To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
---
mongo-replica:SECONDARY> show dbs
uncaught exception: Error: listDatabases failed:{
        "topologyVersion" : {
                "processId" : ObjectId("644b8d39851d74feb84181ab"),
                "counter" : NumberLong(3)
        },
        "ok" : 0,
        "errmsg" : "not master and slaveOk=false",
        "code" : 13435,
        "codeName" : "NotPrimaryNoSecondaryOk",
        "$clusterTime" : {
                "clusterTime" : Timestamp(1682673406, 1),
                "signature" : {
                        "hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
                        "keyId" : NumberLong(0)
                }
        },
        "operationTime" : Timestamp(1682673406, 1)
} :
_getErrorWithCode@src/mongo/shell/utils.js:25:13
Mongo.prototype.getDBs/<@src/mongo/shell/mongo.js:145:19
Mongo.prototype.getDBs@src/mongo/shell/mongo.js:97:12
shellHelper.show@src/mongo/shell/utils.js:956:13
shellHelper@src/mongo/shell/utils.js:838:15
@(shellhelp2):1:1
mongo-replica:SECONDARY> db.getMongo().setSecondaryOk()
mongo-replica:SECONDARY> use testdb
switched to db testdb
mongo-replica:SECONDARY> db.testdb.find()
{ "_id" : ObjectId("644b8ec9d0158b0f63859e0c"), "age" : 1 }
mongo-replica:SECONDARY>  
```
