echo spool %basedir%\backup\basic\table_name.txt > %basedir%\backup\basic\table_name.sql

echo set head off >> %basedir%\backup\basic\table_name.sql
echo set feedback off >> %basedir%\backup\basic\table_name.sql
echo set pagesize 1000 >> %basedir%\backup\basic\table_name.sql
echo set term off >> %basedir%\backup\basic\table_name.sql
echo select 'tables=' ^|^| t.table_name from user_tables t where t.table_name not in >> %basedir%\backup\basic\table_name.sql
echo ('BSVCBUSRUNDATALD', 'BSVCBUSRUNDATAER', 'PKG_GETSEQUENCE_LOGS','BSVCBUSRUNDATALD5','DVR_ERRORLOGGS','DVR_ONLINERECORDGD','DVR_ALERTINFOGS','FDISDISPLANLDABNORMITY','FDISDISPATCHLOG','FDISPREDISPLANLD','DEVEVENT5','BSVCDEVMALRPTLD5','UPGRADELOG', >> %basedir%\backup\basic\table_name.sql
echo 'INFOPUBPERMANENT','INFOPUBTEMP','LOGMAIN','FDISLOGLD','FDISLOGFORHANDLELD','MCUSERLOGINOUTGS','FDISBIGINTERVALRECGD','BSVCBUSARRLFTLD5','DBLOGSEQ','TUPDATERECORDGS','FDISBUSRUNPROPORTIONLD','DFDISBUSABNORMITYPROCESS','FDISDISCMDRECGD'); >> %basedir%\backup\basic\table_name.sql
echo spool off >> %basedir%\backup\basic\table_name.sql
echo exit; >> %basedir%\backup\basic\table_name.sql

sqlplus %CONNECTION_STRING% @%basedir%\backup\basic\table_name.sql