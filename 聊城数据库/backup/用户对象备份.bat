@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ���ñ����ļ�����ľ���·����ע��ĩβ��Ҫ��'\'
set dumpdir=E:\dumpdir

echo userid=%CONNECTION_STRING% > %basedir%\backup\meta.par

echo ROWS=n >> %basedir%\backup\meta.par

echo file=%dumpdir%\aptsmeta%date:~0,4%%date:~5,2%%date:~8,2%.dmp log=%dumpdir%\aptsmeta%date:~0,4%%date:~5,2%%date:~8,2%.log >> %basedir%\backup\meta.par

exp parfile=%basedir%\backup\meta.par
