@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ������Ҫɾ�����·ݣ���ʽΪ201601
set part=201601

echo alter table BSVCBUSARRLFTLD5 truncate partition P_%part%; > %basedir%\delete\station\stationdel.sql

echo exit; >> %basedir%\delete\station\stationdel.sql

sqlplus %CONNECTION_STRING% @ %basedir%\delete\station\stationdel.sql