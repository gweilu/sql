@rem �������ӷ�
set CONNECTION_STRING=aptshz5/hz5@APTS_HZ_LOCAL
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=D:\BACKUP
@rem ���ñ����ļ�����ľ���·����ע��ĩβ��Ҫ��'\'
set dumpdir=D:\dumpdir

echo userid=%CONNECTION_STRING% > %basedir%\backup\meta.par

echo ROWS=n >> %basedir%\backup\meta.par

echo file=%dumpdir%\aptsmeta%date:~0,4%%date:~5,2%%date:~8,2%.dmp log=%dumpdir%\aptsmeta%date:~0,4%%date:~5,2%%date:~8,2%.log >> %basedir%\backup\meta.par

exp parfile=%basedir%\backup\meta.par
