---用sysdb执行
----查询哪个表被锁了 记住 id
SELECT b.owner,b.object_name,a.SESSION_ID,a.LOCKED_MODE FROM v$locked_object a,dba_objects b WHERE b.object_id=a.OBJECT_ID;
---查看是那个session引起的 找到上面语句查到id所在行
SELECT b.USERNAME,b.SID,b.SERIAL#,logon_time FROM v$locked_object a,v$session b WHERE a.SESSION_ID=b.SID ORDER BY b.LOGON_TIME;
---杀掉对应进程
ALTER SYSTEM KILL SESSION '1114,37275';
--其中1114为sid，37275为serial
