@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ���ñ����ļ�����ľ���·����ע��ĩβ��Ҫ��'\'
set dumpdir=E:\dumpdir
@rem ������Ҫ���ݵ��·ݣ���ʽΪ201601
set part=201601

echo userid=%CONNECTION_STRING% > %basedir%\backup\plan\plan.par

echo tables=(FDISDISPLANLD:P_%part%,FDISBUSRUNRECGD:P_%part%) >> %basedir%\backup\plan\plan.par

type %basedir%\backup\plan\loader.txt >> %basedir%\backup\plan\plan.par

echo file=%dumpdir%\aptsplan%part%.dmp log=%dumpdir%\aptsplan%part%.log >> %basedir%\backup\plan\plan.par

exp parfile=%basedir%\backup\plan\plan.par