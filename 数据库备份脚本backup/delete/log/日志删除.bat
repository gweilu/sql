@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ������Ҫɾ�����·ݣ���ʽΪ201601
set part=201601

echo alter table DBLOGSEQ truncate partition P_%part%; > %basedir%\delete\log\logdel.sql

echo alter table FDISDISPATCHLOG truncate partition P_%part%; >> %basedir%\delete\log\logdel.sql

echo alter table FDISLOGFORHANDLELD truncate partition P_%part%; >> %basedir%\delete\log\logdel.sql

echo alter table FDISDISCMDRECGD truncate partition P_%part%; >> %basedir%\delete\log\logdel.sql

echo exit; >> %basedir%\delete\log\logdel.sql

sqlplus %CONNECTION_STRING% @ %basedir%\delete\log\logdel.sql