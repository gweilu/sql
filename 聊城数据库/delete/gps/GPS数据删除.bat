@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ������Ҫɾ�������ڣ���ʽΪ20160101
set part=20160101

echo alter table BSVCBUSRUNDATALD5 truncate partition P_%part%; > %basedir%\delete\gps\gpsdel.sql

echo exit; >> %basedir%\delete\gps\gpsdel.sql

sqlplus %CONNECTION_STRING% @ %basedir%\delete\gps\gpsdel.sql