@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ������Ҫɾ�����·ݣ���ʽΪ201601
set part=201601

echo alter table FDISDISPLANLD truncate partition P_%part%; > %basedir%\delete\plan\plandel.sql

echo alter table FDISBUSRUNRECGD truncate partition P_%part%; >> %basedir%\delete\plan\plandel.sql

echo exit; >> %basedir%\delete\plan\plandel.sql

sqlplus %CONNECTION_STRING% @ %basedir%\delete\plan\plandel.sql