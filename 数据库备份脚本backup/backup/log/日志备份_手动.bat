@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ���ñ����ļ�����ľ���·����ע��ĩβ��Ҫ��'\'
set dumpdir=E:\dumpdir
@rem ������Ҫ���ݵ��·ݣ���ʽΪ201601
set part=201601

echo userid=%CONNECTION_STRING% > %basedir%\backup\log\log.par

echo tables=(DBLOGSEQ:P_%part%,FDISDISPATCHLOG:P_%part%,FDISLOGFORHANDLELD:P_%part%,FDISDISCMDRECGD:P_%part%) >> %basedir%\backup\log\log.par

type %basedir%\backup\log\loader.txt >> %basedir%\backup\log\log.par

echo file=%dumpdir%\aptslog%part%.dmp log=%dumpdir%\aptslog%part%.log >> %basedir%\backup\log\log.par

exp parfile=%basedir%\backup\log\log.par