@rem �������ӷ�
set CONNECTION_STRING=aptshz5/hz5@APTS_HZ_LOCAL
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=D:\BACKUP
@rem ���ñ����ļ�����ľ���·����ע��ĩβ��Ҫ��'\'
set dumpdir=d:\dumpdir

call %basedir%\backup\basic\table_name.bat

echo userid=%CONNECTION_STRING% > %basedir%\backup\basic\basic.par

type %basedir%\backup\basic\table_name.txt >> %basedir%\backup\basic\basic.par

type %basedir%\backup\basic\loader.txt >> %basedir%\backup\basic\basic.par

echo file=%dumpdir%\apts%date:~0,4%%date:~5,2%%date:~8,2%.dmp log=%dumpdir%\apts%date:~0,4%%date:~5,2%%date:~8,2%.log >> %basedir%\backup\basic\basic.par

exp parfile=%basedir%\backup\basic\basic.par

